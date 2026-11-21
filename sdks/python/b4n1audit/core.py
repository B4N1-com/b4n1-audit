"""b4n1audit — wrapper Python del binario ``b4n1-audit`` (patrón one-binary-N-wrappers).

Contrato:
- ``binary_path()`` resuelve el binario (env > empaquetado > PATH > fail loud §5).
- ``run(*args)`` lo invoca como subproceso y devuelve el stdout parseado como
  JSON (dict/list) cuando es JSON; ``run_raw`` devuelve el texto crudo.
- Exit ≠ 0 → ``AuditError`` con stderr tipado (nunca fallback silencioso).

Este módulo NO reimplementa escaneo: solo localiza, invoca y parsea.
"""

from __future__ import annotations

import json
import os
import platform
import shutil
import subprocess
import sys
from pathlib import Path
from typing import Any, List, Optional, Union

__version__ = "0.1.4"

BIN_ENV = "B4N1_AUDIT_BIN"
EXE = ".exe" if sys.platform == "win32" else ""


class AuditError(RuntimeError):
    """Fallo tipado del binario o del entorno (§5: loud, nunca silencioso)."""


def _platform_binary_name() -> Optional[str]:
    """(so, arquitectura) → nombre empaquetado; None si la plataforma es desconocida."""
    so = sys.platform
    mach = platform.machine().lower()
    arch = {
        "x86_64": "amd64", "amd64": "amd64",
        "aarch64": "arm64", "arm64": "arm64",
        "i386": "ia32", "i686": "ia32",
    }.get(mach)
    if arch is None:
        return None
    if so.startswith("linux"):
        return f"b4n1-audit-linux-{arch}{EXE}"
    if so == "darwin":
        return f"b4n1-audit-macos-{'arm64' if arch == 'arm64' else 'x64'}"
    if sys.platform == "win32":
        return f"b4n1-audit-windows-{arch}.exe"
    return None


def binary_path() -> str:
    """Resuelve el binario. Orden: B4N1_AUDIT_BIN > empaquetado > PATH > error."""
    searched: List[str] = []

    env_bin = os.environ.get(BIN_ENV, "").strip()
    if env_bin:
        if Path(env_bin).is_file():
            return env_bin
        searched.append(f"{BIN_ENV}={env_bin} (no existe)")

    name = _platform_binary_name()
    if name:
        bundled = Path(__file__).parent / "bin" / name
        searched.append(str(bundled))
        if bundled.is_file():
            return str(bundled)

    on_path = shutil.which("b4n1-audit")
    if on_path:
        return on_path
    searched.append("PATH: b4n1-audit")

    raise AuditError(
        "b4n1-audit binario no resuelto — probado: " + " | ".join(searched)
    )


def run_raw(*args: str, timeout: Optional[int] = None) -> str:
    """Invoca el binario con *args* y devuelve stdout crudo. Exit ≠ 0 → AuditError."""
    cmd: List[str] = [binary_path(), *args]
    try:
        proc = subprocess.run(
            cmd, capture_output=True, text=True, timeout=timeout, check=False
        )
    except FileNotFoundError as e:
        raise AuditError(f"no se pudo ejecutar {cmd[0]}: {e}") from e
    except subprocess.TimeoutExpired as e:
        raise AuditError(f"timeout tras {timeout}s: {' '.join(cmd)}") from e
    if proc.returncode != 0:
        raise AuditError(
            f"b4n1-audit exit={proc.returncode}: {' '.join(args)}\n"
            f"stderr: {proc.stderr[:2000]}"
        )
    return proc.stdout


def run(*args: str, timeout: Optional[int] = None) -> Union[dict, list, str]:
    """Como ``run_raw`` pero parsea el stdout como JSON si lo es (dict/list)."""
    out = run_raw(*args, timeout=timeout)
    try:
        parsed: Any = json.loads(out)
    except (json.JSONDecodeError, ValueError):
        return out  # salidas no-JSON (texto humano) se entregan como str
    if isinstance(parsed, (dict, list)):
        return parsed
    return out


__all__ = ["AuditError", "binary_path", "run", "run_raw", "__version__"]
