[English](../README.md) · [Español](README.es.md) · [Deutsch](README.de.md) · [Français](README.fr.md) · [Italiano](README.it.md) · [Português (BR)](README.pt-BR.md) · [Русский](README.ru.md) · [العربية](README.ar.md) · [हिन्दी](README.hi.md) · [日本語](README.ja.md) · [한국어](README.ko.md) · [中文](README.zh-CN.md)

<p align="center">
  <img src="b4n1_audit_presentation.png" alt="B4N1 Audit — security and code-quality scanner" width="100%" />
</p>

# b4n1-audit

Сканер безопасности и качества кода — одно встроенное ядро, тонкие оболочки для Python, JavaScript, Java и C#.

[![PyPI](https://img.shields.io/pypi/v/b4n1-audit.svg)](https://pypi.org/project/b4n1-audit/)
[![Python](https://img.shields.io/pypi/pyversions/b4n1-audit.svg)](https://pypi.org/project/b4n1-audit/)
[![Downloads](https://img.shields.io/pepy/dt/b4n1-audit.svg)](https://pypi.org/project/b4n1-audit/)
[![License](https://img.shields.io/badge/license-BUSL--1.1-blue.svg)](LICENSE)

Обертка Python для `b4n1-audit` движок — безопасность и качество кода
сканер, который поставляется в виде одного предварительно скомпилированного двоичного файла. Бинарный файл поставляется в комплекте
платформа внутри колеса; здесь нечего компилировать и нет внешней среды выполнения.

## Установить

```bash
pip install b4n1-audit
```

Требуется Python ≥ 3.8. Включен предварительно скомпилированный двоичный файл (Linux x64/arm64, Windows x64).

## Быстрый старт

```python
from b4n1audit import run, binary_path, AuditError

print(binary_path())          # resolved binary path (fails loud if none)
report = run("json", ".")     # dict/list parsed from JSON output
sarif  = run("sarif", ".")    # SARIF document as text
```

`run()` поднимает `AuditError` (с помощью stderr двоичного файла), когда процесс завершается
ненулевой. Порядок двоичного разрешения: `B4N1_AUDIT_BIN` → связанный двоичный файл → `PATH`.

## Что он сканирует

SDK раскрывает всю поверхность движка, например:

| Глагол | Цель |
|------|---------|
| `scan` / `json` | Сканирование каталога, отчет JSON |
| `sarif` | Вывод SARIF для интеграции CI |
| `cve-check` | Проверка зависимостей CVE по встроенной базе данных |
| `secrets` | Ключи/токены API в файлах и истории |
| `scan-ai` | Оперативная инъекция, проверка MCP и репо-отравления |
| `memory` | Проблемы с безопасностью памяти (утечки, UB, переполнения) |
| `semgrep` | Механизм правил быстрого пути |
| `report` | Автономный HTML-отчет |

```bash
# via the bundled binary directly
python -c "from b4n1audit import binary_path; import sys; print(binary_path())"
$(python -c "from b4n1audit import binary_path; print(binary_path())") scan .
```

## Лицензия

Распространяется по лицензии Business Source License 1.1 (BUSL-1.1) плюс лицензионному соглашению для
связанный двоичный файл. Исходный код является собственностью.
