<?php
namespace B4N1\Audit;

/** Wrapper PHP del binario precompilado de b4n1-audit (one-binary-N-wrappers). */
class AuditClient {
    private string $binary;

    public function __construct(?string $binaryPath = null) {
        $this->binary = $binaryPath ?? self::binaryPath();
    }

    public static function binaryPath(): string {
        $env = getenv("B4N1_AUDIT_BIN");
        if ($env) return $env;

        $arch = PHP_INT_SIZE === 8 ? "amd64" : "ia32";
        $family = PHP_OS_FAMILY;
        if ($family === "Linux") $name = "b4n1-audit-linux-$arch";
        elseif ($family === "Darwin") $name = "b4n1-audit-macos-x64";
        elseif ($family === "Windows") $name = "b4n1-audit-windows-$arch.exe";
        else $name = null;

        if ($name) {
            $bundled = __DIR__ . "/../bin/$name";
            if (file_exists($bundled)) return $bundled;
        }
        return "b4n1-audit";
    }

    /** Invoca el binario; exit != 0 lanza RuntimeException (§5). */
    public function runRaw(array $args): string {
        $cmd = escapeshellarg($this->binary) . " " . implode(" ", array_map("escapeshellarg", $args)) . " 2>&1";
        $lines = [];
        $rc = 0;
        exec($cmd, $lines, $rc);
        $out = rtrim(implode("\n", $lines));
        if ($rc !== 0) {
            throw new \RuntimeException("b4n1-audit exit=$rc: " . implode(" ", $args) . "\nstderr: " . substr($out, 0, 2000));
        }
        return $out;
    }

    public function help(): string { return $this->runRaw(["--help"]); }
    public function scan(string $path): string { return $this->runRaw(["scan", $path]); }
    public function json(string $path): string { return $this->runRaw(["json", $path]); }
}
