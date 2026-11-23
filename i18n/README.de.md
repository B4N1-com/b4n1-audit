[English](../README.md) · [Español](README.es.md) · [Deutsch](README.de.md) · [Français](README.fr.md) · [Italiano](README.it.md) · [Português (BR)](README.pt-BR.md) · [Русский](README.ru.md) · [العربية](README.ar.md) · [हिन्दी](README.hi.md) · [日本語](README.ja.md) · [한국어](README.ko.md) · [中文](README.zh-CN.md)

<p align="center">
  <img src="b4n1_audit_presentation.png" alt="B4N1 Audit — security and code-quality scanner" width="100%" />
</p>

# b4n1-audit

Sicherheits- und Codequalitätsscanner – ein nativer Kern, Thin Wrapper für Python, JavaScript, Java und C#.

[![PyPI](https://img.shields.io/pypi/v/b4n1-audit.svg)](https://pypi.org/project/b4n1-audit/)
[![Python](https://img.shields.io/pypi/pyversions/b4n1-audit.svg)](https://pypi.org/project/b4n1-audit/)
[![Downloads](https://img.shields.io/pepy/dt/b4n1-audit.svg)](https://pypi.org/project/b4n1-audit/)
[![License](https://img.shields.io/badge/license-BUSL--1.1-blue.svg)](LICENSE)

Python-Wrapper für die `b4n1-audit` Engine – eine Sicherheit und Codequalität
Scanner, der als einzelne vorkompilierte Binärdatei geliefert wird. Die Binärdatei wird pro gebündelt
Plattform im Rad; Es gibt nichts zu kompilieren und keine externe Laufzeit.

## Installieren

```bash
pip install b4n1-audit
```

Erfordert Python ≥ 3.8. Vorkompilierte Binärdatei enthalten (Linux x64/arm64, Windows x64).

## Schnellstart

```python
from b4n1audit import run, binary_path, AuditError

print(binary_path())          # resolved binary path (fails loud if none)
report = run("json", ".")     # dict/list parsed from JSON output
sarif  = run("sarif", ".")    # SARIF document as text
```

`run()` erhöht `AuditError` (mit dem stderr der Binärdatei), wenn der Prozess beendet wird
ungleich Null. Binäre Auflösungsreihenfolge: `B4N1_AUDIT_BIN` → gebündelte Binärdatei → `PATH`.

## Was es scannt

Das SDK stellt die gesamte Engine-Oberfläche zur Verfügung, zum Beispiel:

| Verb | Zweck |
|------|---------|
| `scan` / `json` | Verzeichnisscan, JSON-Bericht |
| `sarif` | SARIF-Ausgabe für CI-Integration |
| `cve-check` | Abhängigkeits-CVE-Prüfung anhand einer eingebetteten Datenbank |
| `secrets` | API-Schlüssel/Tokens in Dateien und Verlauf |
| `scan-ai` | Sofortige Injektions-, MCP- und Repo-Vergiftungskontrollen |
| `memory` | Probleme mit der Speichersicherheit (Lecks, UB, Überläufe) |
| `semgrep` | Fast-Path-Regel-Engine |
| `report` | Eigenständiger HTML-Bericht |

```bash
# via the bundled binary directly
python -c "from b4n1audit import binary_path; import sys; print(binary_path())"
$(python -c "from b4n1audit import binary_path; print(binary_path())") scan .
```

## Lizenz

Verteilt unter der Business Source License 1.1 (BUSL-1.1) plus einer EULA für
die gebündelte Binärdatei. Der Quellcode ist proprietär.
