[English](../README.md) · [Español](README.es.md) · [Deutsch](README.de.md) · [Français](README.fr.md) · [Italiano](README.it.md) · [Português (BR)](README.pt-BR.md) · [Русский](README.ru.md) · [العربية](README.ar.md) · [हिन्दी](README.hi.md) · [日本語](README.ja.md) · [한국어](README.ko.md) · [中文](README.zh-CN.md)

<p align="center">
  <img src="b4n1_audit_presentation.png" alt="B4N1 Audit — security and code-quality scanner" width="100%" />
</p>

# b4n1-audit

安全和代码质量扫描器 - 一个本机核心，适用于 Python、JavaScript、Java 和 C# 的瘦包装器。

[![PyPI](https://img.shields.io/pypi/v/b4n1-audit.svg)](https://pypi.org/project/b4n1-audit/)
[![Python](https://img.shields.io/pypi/pyversions/b4n1-audit.svg)](https://pypi.org/project/b4n1-audit/)
[![Downloads](https://img.shields.io/pepy/dt/b4n1-audit.svg)](https://pypi.org/project/b4n1-audit/)
[![License](https://img.shields.io/badge/license-BUSL--1.1-blue.svg)](LICENSE)

Python 包装器 `b4n1-audit` 引擎——安全性和代码质量
作为单个预编译二进制文件提供的扫描仪。该二进制文件捆绑为
车轮内的平台；无需编译任何内容，也无需外部运行时。

## 安装

```bash
pip install b4n1-audit
```

需要 Python ≥ 3.8。包含预编译的二进制文件（Linux x64/arm64、Windows x64）。

## 快速启动

```python
from b4n1audit import run, binary_path, AuditError

print(binary_path())          # resolved binary path (fails loud if none)
report = run("json", ".")     # dict/list parsed from JSON output
sarif  = run("sarif", ".")    # SARIF document as text
```

`run()` 提高 `AuditError` （使用二进制文件的 stderr）当进程退出时
非零。二进制解析顺序： `B4N1_AUDIT_BIN` → 捆绑二进制文件 → `PATH`。

## 它扫描什么

SDK 公开了完整的引擎表面，例如：

| 动词 | 目的 |
|------|---------|
| `scan` / `json` | 目录扫描，JSON报告 |
| `sarif` | 用于 CI 集成的 SARIF 输出 |
| `cve-check` | 针对嵌入式数据库的依赖性 CVE 检查 |
| `secrets` | 文件和历史记录中的 API 密钥/令牌 |
| `scan-ai` | 及时注射、MCP 和再次中毒检查 |
| `memory` | 内存安全问题（泄漏、UB、溢出） |
| `semgrep` | 快速路径规则引擎 |
| `report` | 独立的 HTML 报告 |

```bash
# via the bundled binary directly
python -c "from b4n1audit import binary_path; import sys; print(binary_path())"
$(python -c "from b4n1audit import binary_path; print(binary_path())") scan .
```

## 执照

根据业务源许可证 1.1 (BUSL-1.1) 以及 EULA 分发
捆绑的二进制文件。源代码是专有的。
