using System;
using System.Diagnostics;
using System.IO;
using System.Runtime.InteropServices;
using System.Text;
using System.Text.Json;

namespace B4n1Audit;

/// <summary>
/// Wrapper .NET del binario precompilado b4n1-audit (patrón one-binary-N-wrappers).
/// Orden de resolución: B4N1_AUDIT_BIN &gt; binario empaquetado &gt; PATH &gt; error loud (§5).
/// </summary>
public static class B4n1Audit
{
    private const string BinEnv = "B4N1_AUDIT_BIN";

    /// <summary>Fallo tipado del binario o del entorno (§5: loud, nunca silencioso).</summary>
    public class AuditException : Exception
    {
        public AuditException(string message) : base(message) { }
    }

    /// <summary>(so, arquitectura) → nombre empaquetado; null si la plataforma es desconocida.</summary>
    public static string? PlatformBinaryName()
    {
        string? arch = RuntimeInformation.ProcessArchitecture switch
        {
            Architecture.X64 => "amd64",
            Architecture.Arm64 => "arm64",
            Architecture.X86 => "ia32",
            _ => null,
        };
        if (arch is null) return null;
        if (RuntimeInformation.IsOSPlatform(OSPlatform.Linux))
            return $"b4n1-audit-linux-{arch}";
        if (RuntimeInformation.IsOSPlatform(OSPlatform.OSX))
            return $"b4n1-audit-macos-{(arch == "arm64" ? "arm64" : "x64")}";
        if (RuntimeInformation.IsOSPlatform(OSPlatform.Windows))
            return $"b4n1-audit-windows-{arch}.exe";
        return null;
    }

    /// <summary>Binario resuelto o AuditException con todo lo probado.</summary>
    public static string BinaryPath()
    {
        var searched = new StringBuilder();

        var envBin = Environment.GetEnvironmentVariable(BinEnv);
        if (!string.IsNullOrWhiteSpace(envBin))
        {
            if (File.Exists(envBin)) return envBin;
            searched.Append(BinEnv).Append('=').Append(envBin).Append(" (no existe) | ");
        }

        var name = PlatformBinaryName();
        if (name is not null)
        {
            var bundled = Path.Combine(AppContext.BaseDirectory, "native", name);
            searched.Append(bundled).Append(" | ");
            if (File.Exists(bundled)) return bundled;
        }

        foreach (var dir in (Environment.GetEnvironmentVariable("PATH") ?? "").Split(Path.PathSeparator))
        {
            if (dir.Length == 0) continue;
            var candidate = Path.Combine(dir, "b4n1-audit");
            searched.Append(candidate).Append(" | ");
            if (File.Exists(candidate)) return candidate;
        }

        throw new AuditException($"b4n1-audit binario no resuelto — probado: {searched}");
    }

    /// <summary>Invoca el binario; stdout crudo. Exit ≠ 0 → AuditException.</summary>
    public static string RunRaw(params string[] args) => RunRaw(null, args);

    /// <summary>Con timeout opcional (ms).</summary>
    public static string RunRaw(int? timeoutMs, params string[] args)
    {
        var psi = new ProcessStartInfo
        {
            FileName = BinaryPath(),
            RedirectStandardOutput = true,
            RedirectStandardError = true,
            UseShellExecute = false,
        };
        foreach (var a in args) psi.ArgumentList.Add(a);

        using var proc = Process.Start(psi) ?? throw new AuditException("no se pudo iniciar el binario");
        var stdout = proc.StandardOutput.ReadToEnd();
        var stderr = proc.StandardError.ReadToEnd();
        if (timeoutMs is int t && !proc.WaitForExit(t))
        {
            try { proc.Kill(entireProcessTree: true); } catch { /* ya terminado */ }
            throw new AuditException($"timeout tras {t} ms: {string.Join(' ', args)}");
        }
        proc.WaitForExit();
        if (proc.ExitCode != 0)
            throw new AuditException($"b4n1-audit exit={proc.ExitCode}: {string.Join(' ', args)}\nstderr: {Truncate(stderr, 2000)}");
        return stdout;
    }

    /// <summary>Como RunRaw pero parsea JSON (JsonElement) cuando la salida lo es.</summary>
    public static object Run(params string[] args)
    {
        var outText = RunRaw(args);
        try
        {
            using var doc = JsonDocument.Parse(outText);
            return doc.RootElement.Clone();
        }
        catch (JsonException)
        {
            return outText; // salida no-JSON: texto humano
        }
    }

    private static string Truncate(string s, int max) =>
        s.Length <= max ? s : s[..max] + "…";
}
