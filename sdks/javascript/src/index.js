"use strict";
/**
 * b4n1-audit SDK (JavaScript) — wrapper del binario precompilado.
 *
 *   const { run, binaryPath, AuditError } = require("b4n1-audit");
 *   const report = run("json", ".");   // objeto si la salida es JSON, si no string
 */
const { execFileSync } = require("child_process");
const { binaryPath } = require("./binary");

class AuditError extends Error {
  /** Fallo tipado del binario o del entorno (§5: loud, nunca silencioso). */
  constructor(message) {
    super(message);
    this.name = "AuditError";
  }
}

/** Normaliza llamadas: run("json", "."), run(["json", "."], {timeout}) y
 * run(["json", "."], options) — strings → args, array → se concatena,
 * objeto → options. Devuelve {args, options} siempre válido. */
function normalize(all) {
  const args = [];
  let options = {};
  for (const item of all) {
    if (Array.isArray(item)) args.push(...item);
    else if (item && typeof item === "object") options = item;
    else if (typeof item === "string") args.push(item);
    else throw new AuditError(`argumento no soportado: ${typeof item}`);
  }
  return { args, options };
}

/** Invoca el binario con *args* y devuelve stdout crudo. Exit ≠ 0 → AuditError. */
function runRaw(...rest) {
  const { args, options } = normalize(rest);
  const bin = binaryPath();
  const argv = Array.isArray(args) ? args : [String(args)];
  try {
    return execFileSync(bin, argv, {
      encoding: "utf8",
      maxBuffer: 64 * 1024 * 1024,
      timeout: options.timeout,
      stdio: ["ignore", "pipe", "pipe"],
    });
  } catch (e) {
    if (e instanceof AuditError) throw e;
    const stderr = e.stderr ? String(e.stderr).slice(0, 2000) : "";
    throw new AuditError(
      `b4n1-audit exit=${e.status ?? "killed"}: ${argv.join(" ")}\nstderr: ${stderr}`
    );
  }
}

/** Como runRaw pero parsea el stdout como JSON si lo es (objeto/array). */
function run(...rest) {
  const out = runRaw(...rest);
  try {
    const parsed = JSON.parse(out);
    if (parsed && typeof parsed === "object") return parsed;
  } catch (_) {
    /* salida no-JSON: se entrega como string */
  }
  return out;
}

module.exports = { run, runRaw, binaryPath, AuditError };
