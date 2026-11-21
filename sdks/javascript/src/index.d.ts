/** Tipos del SDK b4n1-audit (JavaScript) — sin paso de build. */

export type RunOptions = {
  /** Timeout en ms; sin él no hay límite. */
  timeout?: number;
};

export declare class AuditError extends Error {
  name: "AuditError";
}

/** Binario resuelto (B4N1_AUDIT_BIN > empaquetado > PATH > lanza AuditError). */
export declare function binaryPath(): string;

/**
 * Invoca el binario; stdout crudo. Exit ≠ 0 → AuditError.
 * Acepta variadic ("json", ".") o array (["json", "."], {timeout}).
 */
export declare function runRaw(
  ...rest: (string | string[] | RunOptions)[]
): string;

/** Como runRaw pero parsea JSON (objeto/array) cuando la salida lo es. */
export declare function run(
  ...rest: (string | string[] | RunOptions)[]
): unknown | string;
