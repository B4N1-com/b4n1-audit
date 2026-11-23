[English](../README.md) · [Español](README.es.md) · [Deutsch](README.de.md) · [Français](README.fr.md) · [Italiano](README.it.md) · [Português (BR)](README.pt-BR.md) · [Русский](README.ru.md) · [العربية](README.ar.md) · [हिन्दी](README.hi.md) · [日本語](README.ja.md) · [한국어](README.ko.md) · [中文](README.zh-CN.md)

<p align="center">
  <img src="b4n1_audit_presentation.png" alt="B4N1 Audit — security and code-quality scanner" width="100%" />
</p>

# b4n1-audit

Escáner de seguridad y calidad del código: un núcleo nativo, contenedores delgados para Python, JavaScript, Java y C#.

[![PyPI](https://img.shields.io/pypi/v/b4n1-audit.svg)](https://pypi.org/project/b4n1-audit/)
[![Python](https://img.shields.io/pypi/pyversions/b4n1-audit.svg)](https://pypi.org/project/b4n1-audit/)
[![Downloads](https://img.shields.io/pepy/dt/b4n1-audit.svg)](https://pypi.org/project/b4n1-audit/)
[![License](https://img.shields.io/badge/license-BUSL--1.1-blue.svg)](LICENSE)

Envoltorio de Python para el `b4n1-audit` motor: seguridad y calidad del código
escáner que se envía como un único binario precompilado. El binario está empaquetado por
plataforma dentro de la rueda; no hay nada que compilar ni tiempo de ejecución externo.

## Instalar

```bash
pip install b4n1-audit
```

Requiere Python ≥ 3.8. Binario precompilado incluido (Linux x64/arm64, Windows x64).

## Inicio rápido

```python
from b4n1audit import run, binary_path, AuditError

print(binary_path())          # resolved binary path (fails loud if none)
report = run("json", ".")     # dict/list parsed from JSON output
sarif  = run("sarif", ".")    # SARIF document as text
```

`run()` eleva `AuditError` (con el stderr del binario) cuando el proceso sale
distinto de cero. Orden de resolución binaria: `B4N1_AUDIT_BIN` → binario incluido → `PATH`.

## lo que escanea

El SDK expone la superficie completa del motor, por ejemplo:

| Verbo | Objetivo |
|------|---------|
| `scan` / `json` | Escaneo de directorio, informe JSON |
| `sarif` | Salida SARIF para la integración de CI |
| `cve-check` | Verificación de dependencia CVE con una base de datos integrada |
| `secrets` | Claves API/tokens en archivos e historial |
| `scan-ai` | Controles rápidos de inyección, MCP y envenenamiento por repo |
| `memory` | Problemas de seguridad de la memoria (fugas, UB, desbordamientos) |
| `semgrep` | Motor de reglas de ruta rápida |
| `report` | Informe HTML autónomo |

```bash
# via the bundled binary directly
python -c "from b4n1audit import binary_path; import sys; print(binary_path())"
$(python -c "from b4n1audit import binary_path; print(binary_path())") scan .
```

## Licencia

Distribuido bajo la licencia Business Source 1.1 (BUSL-1.1) más un EULA para
el binario incluido. El código fuente es propietario.
