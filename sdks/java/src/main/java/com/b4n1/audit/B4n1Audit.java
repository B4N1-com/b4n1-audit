package com.b4n1.audit;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.TimeUnit;
import java.util.stream.Collectors;

/**
 * Wrapper Java del binario precompilado b4n1-audit
 * (patrón one-binary-N-wrappers).
 *
 * Orden de resolución: B4N1_AUDIT_BIN &gt; binario empaquetado &gt; PATH &gt;
 * error loud (§5, sin fallbacks silenciosos).
 */
public final class B4n1Audit {

    private static final String BIN_ENV = "B4N1_AUDIT_BIN";
    private static final String BINARY = "b4n1-audit";

    /** Fallo tipado del binario o del entorno (§5: loud, nunca silencioso). */
    public static final class AuditException extends RuntimeException {
        public AuditException(String message) {
            super(message);
        }
    }

    private B4n1Audit() {}

    /** (so, arquitectura) → nombre empaquetado; null si la plataforma es desconocida. */
    static String platformBinaryName() {
        String os = System.getProperty("os.name", "").toLowerCase();
        String archRaw = System.getProperty("os.arch", "").toLowerCase();
        String arch;
        if (archRaw.equals("amd64") || archRaw.equals("x86_64")) arch = "amd64";
        else if (archRaw.equals("aarch64") || archRaw.equals("arm64")) arch = "arm64";
        else if (archRaw.equals("x86") || archRaw.equals("i386") || archRaw.equals("i686")) arch = "ia32";
        else arch = null;
        if (arch == null) return null;
        if (os.contains("linux")) return "b4n1-audit-linux-" + arch;
        if (os.contains("mac") || os.contains("darwin"))
            return "b4n1-audit-macos-" + ("arm64".equals(arch) ? "arm64" : "x64");
        if (os.contains("windows"))
            return "b4n1-audit-windows-" + arch + ".exe";
        return null;
    }

    /** Binario resuelto o AuditException con todo lo probado. */
    public static String binaryPath() {
        List<String> searched = new ArrayList<>();

        String envBin = System.getenv(BIN_ENV);
        if (envBin != null && !envBin.isBlank()) {
            if (Files.isRegularFile(Path.of(envBin))) return envBin;
            searched.add(BIN_ENV + "=" + envBin + " (no existe)");
        }

        String name = platformBinaryName();
        if (name != null) {
            // Recurso empaquetado extraído al directorio temporal en runtime,
            // o binario suelto junto al jar (native/ del paquete).
            Path bundled = Path.of("native", name);
            searched.add(bundled.toString());
            if (Files.isRegularFile(bundled)) return bundled.toString();
        }

        String pathEnv = System.getenv("PATH");
        if (pathEnv != null) {
            for (String dir : pathEnv.split(java.io.File.pathSeparator)) {
                if (dir.isBlank()) continue;
                Path candidate = Path.of(dir, BINARY);
                searched.add(candidate.toString());
                if (Files.isRegularFile(candidate)) return candidate.toString();
            }
        }

        throw new AuditException(
            "b4n1-audit binario no resuelto — probado: " + String.join(" | ", searched));
    }

    /** Invoca el binario; stdout crudo. Exit ≠ 0 → AuditException. */
    public static String runRaw(String... args) {
        List<String> cmd = new ArrayList<>();
        cmd.add(binaryPath());
        cmd.addAll(List.of(args));
        try {
            Process proc = new ProcessBuilder(cmd)
                .redirectErrorStream(false)
                .start();
            String out;
            String err;
            try (BufferedReader o = new BufferedReader(
                     new InputStreamReader(proc.getInputStream(), StandardCharsets.UTF_8));
                 BufferedReader e = new BufferedReader(
                     new InputStreamReader(proc.getErrorStream(), StandardCharsets.UTF_8))) {
                out = o.lines().collect(Collectors.joining("\n"));
                err = e.lines().collect(Collectors.joining("\n"));
            }
            if (!proc.waitFor(2, TimeUnit.HOURS)) {
                proc.destroyForcibly();
                throw new AuditException("timeout (2h): " + String.join(" ", args));
            }
            if (proc.exitValue() != 0) {
                throw new AuditException("b4n1-audit exit=" + proc.exitValue()
                    + ": " + String.join(" ", args)
                    + "\nstderr: " + truncate(err, 2000));
            }
            return out;
        } catch (IOException e) {
            throw new AuditException("no se pudo ejecutar " + cmd.get(0) + ": " + e.getMessage());
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new AuditException("interrumpido invocando b4n1-audit");
        }
    }

    /** Como runRaw pero devuelve el texto tal cual (JSON lo parsea el llamador). */
    public static String run(String... args) {
        return runRaw(args);
    }

    private static String truncate(String s, int max) {
        return s.length() <= max ? s : s.substring(0, max) + "…";
    }
}
