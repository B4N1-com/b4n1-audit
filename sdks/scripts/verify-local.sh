#!/bin/bash
# verify-local.sh — smoke read-only de los wrappers contra el binario local.
# NO compila nada ni toca fuentes: usa el b4n1-audit del PATH o
# B4N1_AUDIT_BIN. Ejecutable con la otra IA editando el crate.
set -euo pipefail

SDK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BIN="${B4N1_AUDIT_BIN:-$(command -v b4n1-audit || true)}"
if [ -z "$BIN" ]; then
    echo "❌ b4n1-audit no está en PATH ni B4N1_AUDIT_BIN — nada que verificar" >&2
    exit 1
fi
echo "== binario bajo prueba: $BIN"

PASS=0; FAIL=0
ok()  { echo "  ✅ $1"; PASS=$((PASS+1)); }
bad() { echo "  ❌ $1"; FAIL=$((FAIL+1)); }

# 1) --help existe y sale 0 (estado 1: existe & correcto)
if "$BIN" --help >/dev/null 2>&1; then ok "b4n1-audit --help → exit 0"; else bad "--help falló"; fi

# 2) subcomando json sobre un directorio pequeño y estable (read-only)
tmp="$(mktemp -d)"
printf 'def f():\n    return 1\n' > "$tmp/mod.py"
if "$BIN" json "$tmp" >/tmp/audit-sdk-smoke.json 2>/tmp/audit-sdk-smoke.err; then
    if python3 -c "import json,sys; json.load(open('/tmp/audit-sdk-smoke.json'))" 2>/dev/null; then
        ok "json <dir> → exit 0 + JSON parseable"
    else
        bad "json OK pero salida no es JSON"
    fi
else
    bad "json <dir> falló: $(head -c 200 /tmp/audit-sdk-smoke.err)"
fi
rm -rf "$tmp"

# 3) subcomando desconocido → exit ≠ 0, sin 500-equivalente (estado 4)
if "$BIN" no-such-subcommand >/dev/null 2>&1; then
    bad "subcomando desconocido debió fallar (estado 4 de la matriz)"
else
    ok "subcomando desconocido falla loud (exit ≠ 0)"
fi

# 4) wrapper Python: resolución de binario + run() contra el mismo binario
if (cd "$SDK_DIR/python" && B4N1_AUDIT_BIN="$BIN" python3 - <<'PY'
import sys; sys.path.insert(0, ".")
import tempfile
from b4n1audit import binary_path, run
assert binary_path(), "binary_path devolvió vacío"
out = run("json", tempfile.mkdtemp())   # dir vacío: scan sin hallazgos
assert isinstance(out, (dict, list)), f"run() devolvió {type(out)}"
print("wrapper-python OK")
PY
) >/tmp/audit-sdk-py.log 2>&1; then
    ok "wrapper python: resolución + run() tipado ($(tail -1 /tmp/audit-sdk-py.log))"
else
    bad "wrapper python: $(tail -3 /tmp/audit-sdk-py.log | head -c 300)"
fi

# 5) Inventario de artefactos: 4 wrappers x 7 plataformas.
# Estado 3 de la matriz §2a ("debe existir y falta" => FAIL), no el happy path.
#
# El bug que caza (encontrado al verificar la cross-compile): la lista de wrappers
# en build-binaries.sh decia 'csharp/src/native java/native' con el espacio
# reemplazado por '/', asi que bash itero 3 rutas en vez de 4, mkdir -p creo la
# anidada 'csharp/src/native/java/native', y C#/Java NUNCA recibieron binario
# mientras el script imprimia "los 4 wrappers". Contar por wrapper lo hace visible
# sin depender del mensaje.
WRAPPER_DIRS=(
    "python/b4n1audit/bin"   # wrapper Python
    "javascript/bin"         # wrapper JS
    "csharp/src/native"      # C#: AppContext.BaseDirectory + "native"
    "java/native"            # Java: pom.xml <directory>native</directory>
)
PLATFORMS=(
    linux-amd64 linux-arm64 linux-ia32
    windows-amd64 windows-ia32
    macos-x64 macos-arm64
)
for w in "${WRAPPER_DIRS[@]}"; do
    missing=""
    for p in "${PLATFORMS[@]}"; do
        f="$SDK_DIR/$w/b4n1-audit-$p"
        [ -f "$f" ] || f="$SDK_DIR/$w/b4n1-audit-$p.exe"
        [ -f "$f" ] || missing="$missing $p"
    done
    if [ -z "$missing" ]; then
        ok "wrapper $w: 7/7 binarios empaquetados"
    else
        bad "wrapper $w: faltan$missing → ejecuta scripts/build-binaries.sh"
    fi
done

echo "== verify-local: $PASS ok / $FAIL fallos"
[ "$FAIL" -eq 0 ] || exit 1
