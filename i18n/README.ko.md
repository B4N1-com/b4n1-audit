[English](../README.md) · [Español](README.es.md) · [Deutsch](README.de.md) · [Français](README.fr.md) · [Italiano](README.it.md) · [Português (BR)](README.pt-BR.md) · [Русский](README.ru.md) · [العربية](README.ar.md) · [हिन्दी](README.hi.md) · [日本語](README.ja.md) · [한국어](README.ko.md) · [中文](README.zh-CN.md)

<p align="center">
  <img src="b4n1_audit_presentation.png" alt="B4N1 Audit — security and code-quality scanner" width="100%" />
</p>

# b4n1-audit

보안 및 코드 품질 스캐너 — Python, JavaScript, Java 및 C#을 위한 하나의 기본 코어, 씬 래퍼.

[![PyPI](https://img.shields.io/pypi/v/b4n1-audit.svg)](https://pypi.org/project/b4n1-audit/)
[![Python](https://img.shields.io/pypi/pyversions/b4n1-audit.svg)](https://pypi.org/project/b4n1-audit/)
[![Downloads](https://img.shields.io/pepy/dt/b4n1-audit.svg)](https://pypi.org/project/b4n1-audit/)
[![License](https://img.shields.io/badge/license-BUSL--1.1-blue.svg)](LICENSE)

Python 래퍼 `b4n1-audit` 엔진 — 보안 및 코드 품질
단일 사전 컴파일된 바이너리로 제공되는 스캐너입니다. 바이너리는 다음과 같이 번들로 제공됩니다.
바퀴 내부의 플랫폼; 컴파일할 것도 없고 외부 런타임도 없습니다.

## 설치하다

```bash
pip install b4n1-audit
```

Python ≥ 3.8이 필요합니다. 미리 컴파일된 바이너리가 포함되어 있습니다(Linux x64/arm64, Windows x64).

## 빠른 시작

```python
from b4n1audit import run, binary_path, AuditError

print(binary_path())          # resolved binary path (fails loud if none)
report = run("json", ".")     # dict/list parsed from JSON output
sarif  = run("sarif", ".")    # SARIF document as text
```

`run()` 인상 `AuditError` (바이너리의 stderr 사용) 프로세스가 종료될 때
0이 아닙니다. 바이너리 해결 순서: `B4N1_AUDIT_BIN` → 번들 바이너리 → `PATH`.

## 검사 내용

SDK는 다음과 같이 전체 엔진 표면을 노출합니다.

| 동사 | 목적 |
|------|---------|
| `scan` / `json` | 디렉토리 스캔, JSON 보고서 |
| `sarif` | CI 통합을 위한 SARIF 출력 |
| `cve-check` | 내장형 데이터베이스에 대한 종속성 CVE 검사 |
| `secrets` | 파일 및 기록의 API 키/토큰 |
| `scan-ai` | 신속한 주입, MCP 및 repo-poisoning 점검 |
| `memory` | 메모리 안전 문제(누수, UB, 오버플로) |
| `semgrep` | 빠른 경로 규칙 엔진 |
| `report` | 자체 포함된 HTML 보고서 |

```bash
# via the bundled binary directly
python -c "from b4n1audit import binary_path; import sys; print(binary_path())"
$(python -c "from b4n1audit import binary_path; print(binary_path())") scan .
```

## 특허

Business Source License 1.1(BUSL-1.1)과 EULA에 따라 배포됩니다.
번들 바이너리. 소스 코드는 독점적입니다.
