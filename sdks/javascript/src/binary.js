"use strict";
/**
 * Resolución del binario b4n1-audit (patrón one-binary-N-wrappers).
 * Orden: B4N1_AUDIT_BIN > binario empaquetado > PATH > fail loud (§5).
 */
const fs = require("fs");
const os = require("os");
const path = require("path");
const { execFileSync } = require("child_process");

const BIN_ENV = "B4N1_AUDIT_BIN";

/** (so, arquitectura) → nombre empaquetado; null si la plataforma es desconocida. */
function platformBinaryName() {
  const archMap = {
    x64: "amd64",
    arm64: "arm64",
    ia32: "ia32",
    x86: "ia32",
  };
  const arch = archMap[os.arch()] || null;
  if (!arch) return null;
  if (process.platform === "linux") return `b4n1-audit-linux-${arch}`;
  if (process.platform === "darwin")
    return `b4n1-audit-macos-${arch === "arm64" ? "arm64" : "x64"}`;
  if (process.platform === "win32")
    return `b4n1-audit-windows-${arch}.exe`;
  return null;
}

/** Resuelve el binario o lanza con la lista completa de sitios probados. */
function binaryPath() {
  const searched = [];

  const envBin = (process.env[BIN_ENV] || "").trim();
  if (envBin) {
    if (fs.existsSync(envBin)) return envBin;
    searched.push(`${BIN_ENV}=${envBin} (no existe)`);
  }

  const name = platformBinaryName();
  if (name) {
    const bundled = path.join(__dirname, "..", "bin", name);
    searched.push(bundled);
    if (fs.existsSync(bundled)) return bundled;
  }

  // PATH: búsqueda manual (sin dependencias)
  const exe = process.platform === "win32" ? ".exe" : "";
  for (const dir of (process.env.PATH || "").split(path.delimiter)) {
    if (!dir) continue;
    const candidate = path.join(dir, `b4n1-audit${exe}`);
    searched.push(candidate);
    if (fs.existsSync(candidate)) return candidate;
  }

  throw new Error(
    "b4n1-audit binario no resuelto — probado: " + searched.join(" | ")
  );
}

module.exports = { binaryPath, platformBinaryName, BIN_ENV };
