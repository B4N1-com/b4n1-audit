[English](../README.md) · [Español](README.es.md) · [Deutsch](README.de.md) · [Français](README.fr.md) · [Italiano](README.it.md) · [Português (BR)](README.pt-BR.md) · [Русский](README.ru.md) · [العربية](README.ar.md) · [हिन्दी](README.hi.md) · [日本語](README.ja.md) · [한국어](README.ko.md) · [中文](README.zh-CN.md)

<p align="center">
  <img src="b4n1_audit_presentation.png" alt="B4N1 Audit — security and code-quality scanner" width="100%" />
</p>

# b4n1-audit

Scanner de segurança e qualidade de código — um núcleo nativo, thin wrappers para Python, JavaScript, Java e C#.

[![PyPI](https://img.shields.io/pypi/v/b4n1-audit.svg)](https://pypi.org/project/b4n1-audit/)
[![Python](https://img.shields.io/pypi/pyversions/b4n1-audit.svg)](https://pypi.org/project/b4n1-audit/)
[![Downloads](https://img.shields.io/pepy/dt/b4n1-audit.svg)](https://pypi.org/project/b4n1-audit/)
[![License](https://img.shields.io/badge/license-BUSL--1.1-blue.svg)](LICENSE)

Wrapper Python para o `b4n1-audit` mecanismo - uma segurança e qualidade de código
scanner que é fornecido como um único binário pré-compilado. O binário é empacotado por
plataforma dentro da roda; não há nada para compilar e nenhum tempo de execução externo.

## Instalar

```bash
pip install b4n1-audit
```

Requer Python ≥ 3.8. Binário pré-compilado incluído (Linux x64/arm64, Windows x64).

## Início rápido

```python
from b4n1audit import run, binary_path, AuditError

print(binary_path())          # resolved binary path (fails loud if none)
report = run("json", ".")     # dict/list parsed from JSON output
sarif  = run("sarif", ".")    # SARIF document as text
```

`run()` aumenta `AuditError` (com o stderr do binário) quando o processo termina
diferente de zero. Ordem de resolução binária: `B4N1_AUDIT_BIN` → binário empacotado → `PATH`.

## O que verifica

O SDK expõe toda a superfície do mecanismo, por exemplo:

| Verbo | Propósito |
|------|---------|
| `scan` / `json` | Verificação de diretório, relatório JSON |
| `sarif` | Saída SARIF para integração de CI |
| `cve-check` | Verificação de CVE de dependência em um banco de dados incorporado |
| `secrets` | Chaves/tokens de API em arquivos e histórico |
| `scan-ai` | Injeção imediata, verificações de envenenamento por MCP e repo |
| `memory` | Problemas de segurança de memória (vazamentos, UB, estouros) |
| `semgrep` | Mecanismo de regras de caminho rápido |
| `report` | Relatório HTML independente |

```bash
# via the bundled binary directly
python -c "from b4n1audit import binary_path; import sys; print(binary_path())"
$(python -c "from b4n1audit import binary_path; print(binary_path())") scan .
```

## Licença

Distribuído sob a Business Source License 1.1 (BUSL-1.1) mais um EULA para
o binário empacotado. O código-fonte é proprietário.
