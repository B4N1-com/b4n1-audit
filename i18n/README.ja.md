[English](../README.md) · [Español](README.es.md) · [Deutsch](README.de.md) · [Français](README.fr.md) · [Italiano](README.it.md) · [Português (BR)](README.pt-BR.md) · [Русский](README.ru.md) · [العربية](README.ar.md) · [हिन्दी](README.hi.md) · [日本語](README.ja.md) · [한국어](README.ko.md) · [中文](README.zh-CN.md)

<p align="center">
  <img src="b4n1_audit_presentation.png" alt="B4N1 Audit — security and code-quality scanner" width="100%" />
</p>

# b4n1-audit

セキュリティおよびコード品質のスキャナー - 1 つのネイティブ コア、Python、JavaScript、Java、および C# 用のシン ラッパー。

[![PyPI](https://img.shields.io/pypi/v/b4n1-audit.svg)](https://pypi.org/project/b4n1-audit/)
[![Python](https://img.shields.io/pypi/pyversions/b4n1-audit.svg)](https://pypi.org/project/b4n1-audit/)
[![Downloads](https://img.shields.io/pepy/dt/b4n1-audit.svg)](https://pypi.org/project/b4n1-audit/)
[![License](https://img.shields.io/badge/license-BUSL--1.1-blue.svg)](LICENSE)

の Python ラッパー `b4n1-audit` エンジン — セキ​​ュリティとコード品質
単一のプリコンパイル済みバイナリとして出荷されるスキャナ。バイナリは次のようにバンドルされています
ホイール内のプラットフォーム。コンパイルするものや外部ランタイムは何もありません。

## インストール

```bash
pip install b4n1-audit
```

Python 3.8 以上が必要です。プリコンパイル済みバイナリが含まれています (Linux x64/arm64、Windows x64)。

## クイックスタート

```python
from b4n1audit import run, binary_path, AuditError

print(binary_path())          # resolved binary path (fails loud if none)
report = run("json", ".")     # dict/list parsed from JSON output
sarif  = run("sarif", ".")    # SARIF document as text
```

`run()` 上げる `AuditError` (バイナリの標準エラー出力を使用して) プロセスが終了したとき
ゼロではない。バイナリ解決順序: `B4N1_AUDIT_BIN` → バンドルされたバイナリ → `PATH`。

## スキャンするもの

SDK は、エンジンの全表面を公開します。次に例を示します。

| 動詞 | 目的 |
|------|---------|
| `scan` / `json` | ディレクトリスキャン、JSONレポート |
| `sarif` | CI統合用のSARIF出力 |
| `cve-check` | 組み込みデータベースに対する依存関係 CVE チェック |
| `secrets` | ファイルおよび履歴内の API キー/トークン |
| `scan-ai` | 即時注入、MCP、およびレポ中毒チェック |
| `memory` | メモリの安全性の問題 (リーク、UB、オーバーフロー) |
| `semgrep` | ファストパスルールエンジン |
| `report` | 自己完結型の HTML レポート |

```bash
# via the bundled binary directly
python -c "from b4n1audit import binary_path; import sys; print(binary_path())"
$(python -c "from b4n1audit import binary_path; print(binary_path())") scan .
```

## ライセンス

ビジネス ソース ライセンス 1.1 (BUSL-1.1) と EULA に基づいて配布されます。
バンドルされたバイナリ。ソースコードは独自のものです。
