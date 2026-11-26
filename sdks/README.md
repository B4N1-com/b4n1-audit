# b4n1-audit SDK — plantilla pionera `one-binary-N-wrappers`

> Tarea `682b6b04` del proyecto **B4N1 Frameworks SDKs**. Patrón: UN binario
> Rust precompilado (`b4n1-audit`) empaquetado dentro de CUATRO wrappers de
> lenguaje. Cada wrapper localiza el binario de su plataforma y lo invoca
> como subproceso; nunca reimplementa lógica de escaneo.

**Status: published.** SDKs on PyPI / npm / NuGet / Maven (BUSL-1.1 + EULA).
See task `952f7022` (release infra) and `e4e20e97` (launch manual).

## Estructura

```
sdks/b4n1-audit/
├── README.md                  ← este fichero (contrato del patrón)
├── VERSION                    ← versión del SDK (independiente de la del crate)
├── scripts/
│   ├── build-binaries.sh      ← cross-compile 7 plataformas (cli.sh zig zigbuild)
│   └── verify-local.sh        ← smoke: wrappers contra el binario local (read-only)
├── python/                    ← PyPI (b4n1-audit)
├── javascript/                ← npm   (b4n1-audit)
├── csharp/                    ← NuGet (B4n1Audit)
└── java/                      ← Maven (groupId com.b4n1, artifactId b4n1-audit)
```

## Plataformas (7, misma convención que b4n1-web)

| Plataforma        | Target zig/rust                     | Binario empaquetado              |
|-------------------|-------------------------------------|----------------------------------|
| linux-amd64       | `x86_64-unknown-linux-musl`         | `b4n1-audit-linux-amd64`         |
| linux-arm64       | `aarch64-unknown-linux-musl`        | `b4n1-audit-linux-arm64`         |
| linux-ia32        | `i686-unknown-linux-musl`           | `b4n1-audit-linux-ia32`          |
| windows-amd64     | `x86_64-pc-windows-gnu`             | `b4n1-audit-windows-amd64.exe`   |
| windows-ia32      | `i686-pc-windows-gnu`               | `b4n1-audit-windows-ia32.exe`    |
| macos-x64         | `x86_64-apple-darwin`               | `b4n1-audit-macos-x64`           |
| macos-arm64       | `aarch64-apple-darwin`              | `b4n1-audit-macos-arm64`         |

Linux usa **musl** (estático): sin dependencia de glibc del host (§9: binario
portable, cero runtime). macOS necesita el SDK en `~/.b4n1/sdks/MacOSX.sdk`
(`bash cli.sh zig sdk-ensure`).

## Orden de resolución del binario (idéntico en los 4 wrappers)

1. `B4N1_AUDIT_BIN` (env) — override explícito.
2. Binario empaquetado propio de la plataforma (dentro del paquete).
3. `b4n1-audit` en el `PATH` (máquinas de desarrollo con el binario instalado).
4. **Fail loud**: error que lista todo lo buscado (§5, sin fallbacks silenciosos).

## Uso rápido

```bash
bash scripts/build-binaries.sh        # 7 plataformas → bin/ de cada wrapper
bash scripts/verify-local.sh          # smoke read-only contra binario local
```

```python
from b4n1audit import run
report = run("json", "--path", ".")   # dict (stdout parseado) o error tipado
```

```javascript
const { run } = require("b4n1-audit");
const report = run("json", "--path", ".");
```

## Reglas del patrón (reutilización para los SDKs restantes — task `747579db`)

- El wrapper NO contiene lógica de negocio: resuelve binario + invoca + parsea.
- Todo JSON que sale del binario se entrega tipado; error de exit ≠ 0 →
  excepción con stderr (§5).
- La versión del SDK (`VERSION`) es independiente de la versión del crate.
- **Zero-Rust (§10h):** antes de cualquier publicación, ningún `.rs`,
  `Cargo.toml` interno ni token puede entrar en el paquete publicado.
