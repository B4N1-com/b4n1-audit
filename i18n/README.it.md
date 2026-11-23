[English](../README.md) · [Español](README.es.md) · [Deutsch](README.de.md) · [Français](README.fr.md) · [Italiano](README.it.md) · [Português (BR)](README.pt-BR.md) · [Русский](README.ru.md) · [العربية](README.ar.md) · [हिन्दी](README.hi.md) · [日本語](README.ja.md) · [한국어](README.ko.md) · [中文](README.zh-CN.md)

<p align="center">
  <img src="b4n1_audit_presentation.png" alt="B4N1 Audit — security and code-quality scanner" width="100%" />
</p>

# b4n1-audit

Scanner di sicurezza e qualità del codice: un core nativo, wrapper sottili per Python, JavaScript, Java e C#.

[![PyPI](https://img.shields.io/pypi/v/b4n1-audit.svg)](https://pypi.org/project/b4n1-audit/)
[![Python](https://img.shields.io/pypi/pyversions/b4n1-audit.svg)](https://pypi.org/project/b4n1-audit/)
[![Downloads](https://img.shields.io/pepy/dt/b4n1-audit.svg)](https://pypi.org/project/b4n1-audit/)
[![License](https://img.shields.io/badge/license-BUSL--1.1-blue.svg)](LICENSE)

Wrapper Python per il file `b4n1-audit` motore: sicurezza e qualità del codice
scanner fornito come singolo file binario precompilato. Il binario è raggruppato per
piattaforma all'interno della ruota; non c'è niente da compilare e nessun runtime esterno.

## Installare

```bash
pip install b4n1-audit
```

Richiede Python ≥ 3.8. Binario precompilato incluso (Linux x64/arm64, Windows x64).

## Avvio rapido

```python
from b4n1audit import run, binary_path, AuditError

print(binary_path())          # resolved binary path (fails loud if none)
report = run("json", ".")     # dict/list parsed from JSON output
sarif  = run("sarif", ".")    # SARIF document as text
```

`run()` rilanci `AuditError` (con lo stderr del binario) quando il processo termina
diverso da zero. Ordine di risoluzione binaria: `B4N1_AUDIT_BIN` → binario in bundle → `PATH`.

## Cosa scansiona

L'SDK espone l'intera superficie del motore, ad esempio:

| Verbo | Scopo |
|------|---------|
| `scan` / `json` | Scansione della directory, rapporto JSON |
| `sarif` | Uscita SARIF per l'integrazione CI |
| `cve-check` | Controllo CVE delle dipendenze rispetto a un database incorporato |
| `secrets` | Chiavi/token API nei file e nella cronologia |
| `scan-ai` | Controlli tempestivi su iniezione, MCP e repo-avvelenamento |
| `memory` | Problemi di sicurezza della memoria (perdite, UB, overflow) |
| `semgrep` | Motore di regole del percorso rapido |
| `report` | Report HTML autonomo |

```bash
# via the bundled binary directly
python -c "from b4n1audit import binary_path; import sys; print(binary_path())"
$(python -c "from b4n1audit import binary_path; print(binary_path())") scan .
```

## Licenza

Distribuito con licenza Business Source 1.1 (BUSL-1.1) più un EULA per
il binario in bundle. Il codice sorgente è proprietario.
