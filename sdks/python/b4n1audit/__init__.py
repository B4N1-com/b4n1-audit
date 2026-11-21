"""b4n1-audit SDK (Python) — wrapper del binario precompilado.

Uso::

    from b4n1audit import run, binary_path, AuditError
    report = run("json", ".")     # dict/list si la salida es JSON, si no str
"""

from .core import AuditError, binary_path, run, run_raw, __version__

__all__ = ["AuditError", "binary_path", "run", "run_raw", "__version__"]
