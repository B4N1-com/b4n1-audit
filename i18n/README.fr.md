[English](../README.md) · [Español](README.es.md) · [Deutsch](README.de.md) · [Français](README.fr.md) · [Italiano](README.it.md) · [Português (BR)](README.pt-BR.md) · [Русский](README.ru.md) · [العربية](README.ar.md) · [हिन्दी](README.hi.md) · [日本語](README.ja.md) · [한국어](README.ko.md) · [中文](README.zh-CN.md)

<p align="center">
  <img src="b4n1_audit_presentation.png" alt="B4N1 Audit — security and code-quality scanner" width="100%" />
</p>

# b4n1-audit

Scanner de sécurité et de qualité du code : un noyau natif, des wrappers fins pour Python, JavaScript, Java et C#.

[![PyPI](https://img.shields.io/pypi/v/b4n1-audit.svg)](https://pypi.org/project/b4n1-audit/)
[![Python](https://img.shields.io/pypi/pyversions/b4n1-audit.svg)](https://pypi.org/project/b4n1-audit/)
[![Downloads](https://img.shields.io/pepy/dt/b4n1-audit.svg)](https://pypi.org/project/b4n1-audit/)
[![License](https://img.shields.io/badge/license-BUSL--1.1-blue.svg)](LICENSE)

Wrapper Python pour le `b4n1-audit` moteur - une sécurité et une qualité de code
scanner livré sous la forme d'un seul binaire précompilé. Le binaire est regroupé par
plate-forme à l'intérieur de la roue ; il n'y a rien à compiler ni aucun runtime externe.

## Installer

```bash
pip install b4n1-audit
```

Nécessite Python ≥ 3.8. Binaire précompilé inclus (Linux x64/arm64, Windows x64).

## Démarrage rapide

```python
from b4n1audit import run, binary_path, AuditError

print(binary_path())          # resolved binary path (fails loud if none)
report = run("json", ".")     # dict/list parsed from JSON output
sarif  = run("sarif", ".")    # SARIF document as text
```

`run()` soulève `AuditError` (avec le stderr du binaire) lorsque le processus se termine
non nul. Ordre de résolution binaire : `B4N1_AUDIT_BIN` → binaire groupé → `PATH`.

## Ce qu'il scanne

Le SDK expose la surface complète du moteur, par exemple :

| Verbe | But |
|------|---------|
| `scan` / `json` | Analyse de répertoire, rapport JSON |
| `sarif` | Sortie SARIF pour l'intégration CI |
| `cve-check` | Vérification CVE des dépendances par rapport à une base de données intégrée |
| `secrets` | Clés/jetons API dans les fichiers et l'historique |
| `scan-ai` | Contrôles d'injection rapide, de MCP et de repo-empoisonnement |
| `memory` | Problèmes de sécurité mémoire (fuites, UB, débordements) |
| `semgrep` | Moteur de règles accélérées |
| `report` | Rapport HTML autonome |

```bash
# via the bundled binary directly
python -c "from b4n1audit import binary_path; import sys; print(binary_path())"
$(python -c "from b4n1audit import binary_path; print(binary_path())") scan .
```

## Licence

Distribué sous la licence Business Source 1.1 (BUSL-1.1) plus un CLUF pour
le binaire fourni. Le code source est propriétaire.
