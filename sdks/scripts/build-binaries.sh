#!/bin/bash
# build-binaries.sh — cross-compile del binario pionero a 7 plataformas
# y copia a bin/ de cada wrapper (patrón one-binary-N-wrappers, task 682b6b04).
#
# Reusa la infra existente: `bash cli.sh zig zigbuild <crate> <target>`
# (zig + cargo-zigbuild, sin GitHub Actions — ver bash/cli-zig.sh).
# macOS requiere el SDK (bash cli.sh zig sdk-ensure); si no está, esos
# targets fallan loud y el resto se compila igual (§5, sin silencios).
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
CRATE="b4n1-audit"
SDK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BIN_DIR_SRC="$ROOT_DIR/private-repos/$CRATE/target"

# plataforma -> target zig/rust (orden de la tabla del README)
TARGETS=(
    "linux-amd64:x86_64-unknown-linux-musl"
    "linux-arm64:aarch64-unknown-linux-musl"
    "linux-ia32:i686-unknown-linux-musl"
    "windows-amd64:x86_64-pc-windows-gnu"
    "windows-ia32:i686-pc-windows-gnu"
    "macos-x64:x86_64-apple-darwin"
    "macos-arm64:aarch64-apple-darwin"
)

# Destinos de los 4 wrappers. Se declara AQUI (fuera del bucle) para que el
# autochequeo final pueda recorrerlos incluso si ningun target se re-compila.
# Cada wrapper tiene su PROPIO convenio de ruta — los 4 NO usan "bin/":
#   python  -> b4n1audit/bin/     js -> bin/
#   csharp  -> src/native/        java -> native/
WRAPPERS=(
    "python/b4n1audit/bin"
    "javascript/bin"
    "csharp/src/native"
    "java/native"
)

WIN_TARGETS="windows-amd64 windows-ia32"
BUILD_OK=0
BUILD_FAIL=0
FAILED=""

for entry in "${TARGETS[@]}"; do
    plat="${entry%%:*}"
    target="${entry##*:}"
    echo "== zigbuild $CRATE → $plat ($target)"
    if bash "$ROOT_DIR/cli.sh" zig zigbuild "$CRATE" "$target"; then
        # nombre del artefacto de salida
        out_name="$CRATE"
        case " $WIN_TARGETS " in
            *" $plat "*) out_name="$CRATE.exe" ;;
        esac
        src="$BIN_DIR_SRC/$target/release/$out_name"
        if [ ! -f "$src" ]; then
            echo "❌ artefacto esperado ausente: $src" >&2
            BUILD_FAIL=$((BUILD_FAIL + 1))
            FAILED="$FAILED $plat(no-artifact)"
            continue
        fi
        # copia el mismo binario a los 4 wrappers.
        # IMPORTANTE: cada destino es una entrada separada del array. Cada
        # wrapper tiene su propio convenio de ruta (los 4 NO usan "bin/"):
        #   python  -> b4n1audit/bin/        (importlib resources)
        #   js      -> bin/                  (new URL(...))
        #   csharp  -> src/native/           (AppContext.BaseDirectory + "native")
        #   java    -> native/               (pom <directory>native</directory>)
        # Un espacio perdido entre dos rutas las une en una sola y mkdir -p
        # crea una anidada ficticia: los wrappers afectados quedan sin binario
        # en silencio. Gates: autochequeo final de ESTE script + verify-local.sh.
        for w in "${WRAPPERS[@]}"; do
            dest_dir="$SDK_DIR/$w"
            mkdir -p "$dest_dir"
            if [[ " $WIN_TARGETS " == *" $plat "* ]]; then
                cp "$src" "$dest_dir/$CRATE-$plat.exe"
            else
                cp "$src" "$dest_dir/$CRATE-$plat"
            fi
        done
        echo "✅ $plat → los ${#WRAPPERS[@]} wrappers"
        BUILD_OK=$((BUILD_OK + 1))
    else
        # Un target puede fallar (macOS sin SDK): no aborta el resto,
        # pero se reporta y el exit final es distinto de 0 (§5).
        echo "⚠️  zigbuild falló para $plat ($target)" >&2
        BUILD_FAIL=$((BUILD_FAIL + 1))
        FAILED="$FAILED $plat"
    fi
done

echo
echo "== resumen: $BUILD_OK ok / $BUILD_FAIL fallidos${FAILED:+ →$FAILED}"

# AUTOCHEQUEO DE DISTRIBUCION — el que reparte verifica su reparto (§2a, estado 3).
# Un target puede "compilar OK" y aun asi quedar sin copiarse a un wrapper: fue
# exactamente el bug encontrado (la lista de destinos perdia un espacio, iteraba
# 3 rutas en vez de 4 y dejaba a C#/Java sin binario mientras se imprimia
# "los 4 wrappers"). Se cuenta POR WRAPPER contra TARGETS, no se lee un mensaje,
# asi que un resumen optimista no lo tapa.
DIST_FAIL=0
for w in "${WRAPPERS[@]}"; do
    missing=""
    for entry in "${TARGETS[@]}"; do
        plat="${entry%%:*}"
        f="$SDK_DIR/$w/$CRATE-$plat"
        [ -f "$f" ] || f="$SDK_DIR/$w/$CRATE-$plat.exe"
        [ -f "$f" ] || missing="$missing $plat"
    done
    if [ -z "$missing" ]; then
        echo "  ✅ $w: ${#TARGETS[@]}/${#TARGETS[@]} binarios"
    else
        echo "  ❌ $w: faltan$missing → los wrappers no estan simetricos" >&2
        DIST_FAIL=1
    fi
done
[ "$DIST_FAIL" -eq 0 ] || { echo "❌ distribucion incompleta: aborto" >&2; exit 1; }

[ "$BUILD_FAIL" -eq 0 ] || exit 1
