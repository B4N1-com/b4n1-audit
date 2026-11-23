[English](../README.md) · [Español](README.es.md) · [Deutsch](README.de.md) · [Français](README.fr.md) · [Italiano](README.it.md) · [Português (BR)](README.pt-BR.md) · [Русский](README.ru.md) · [العربية](README.ar.md) · [हिन्दी](README.hi.md) · [日本語](README.ja.md) · [한국어](README.ko.md) · [中文](README.zh-CN.md)

<p align="center">
  <img src="b4n1_audit_presentation.png" alt="B4N1 Audit — security and code-quality scanner" width="100%" />
</p>

# b4n1-audit

أداة فحص للأمان وجودة التعليمات البرمجية - نواة أصلية واحدة، وأغلفة رفيعة لـ Python وJavaScript وJava وC#.

[![PyPI](https://img.shields.io/pypi/v/b4n1-audit.svg)](https://pypi.org/project/b4n1-audit/)
[![Python](https://img.shields.io/pypi/pyversions/b4n1-audit.svg)](https://pypi.org/project/b4n1-audit/)
[![Downloads](https://img.shields.io/pepy/dt/b4n1-audit.svg)](https://pypi.org/project/b4n1-audit/)
[![License](https://img.shields.io/badge/license-BUSL--1.1-blue.svg)](LICENSE)

غلاف بايثون لـ `b4n1-audit` المحرك - أمان وجودة التعليمات البرمجية
الماسح الضوئي الذي يأتي كملف ثنائي واحد مترجم مسبقًا. يتم تجميع الثنائي لكل
منصة داخل العجلة؛ لا يوجد شيء لتجميعه ولا يوجد وقت تشغيل خارجي.

## ثَبَّتَ

```bash
pip install b4n1-audit
```

يتطلب بايثون ≥ 3.8. تم تضمين البرنامج الثنائي المترجم مسبقًا (Linux x64/arm64 وWindows x64).

## بداية سريعة

```python
from b4n1audit import run, binary_path, AuditError

print(binary_path())          # resolved binary path (fails loud if none)
report = run("json", ".")     # dict/list parsed from JSON output
sarif  = run("sarif", ".")    # SARIF document as text
```

`run()` يثير `AuditError` (مع stderr الثنائي) عند خروج العملية
غير الصفر. ترتيب القرار الثنائي: `B4N1_AUDIT_BIN` → المجمعة الثنائية → `PATH`.

## ما يمسح

يعرض SDK سطح المحرك بالكامل، على سبيل المثال:

| فعل | غاية |
|------|---------|
| `scan` / `json` | مسح الدليل، تقرير JSON |
| `sarif` | إخراج SARIF لتكامل CI |
| `cve-check` | التحقق من التبعية CVE مقابل قاعدة بيانات مضمنة |
| `secrets` | مفاتيح API/الرموز المميزة في الملفات والتاريخ |
| `scan-ai` | الحقن الفوري، MCP وفحوصات التسمم الريبو |
| `memory` | مشكلات تتعلق بسلامة الذاكرة (التسريبات، UB، الفيضانات) |
| `semgrep` | محرك قاعدة المسار السريع |
| `report` | تقرير HTML قائم بذاته |

```bash
# via the bundled binary directly
python -c "from b4n1audit import binary_path; import sys; print(binary_path())"
$(python -c "from b4n1audit import binary_path; print(binary_path())") scan .
```

## رخصة

يتم توزيعه بموجب ترخيص مصدر الأعمال 1.1 (BUSL-1.1) بالإضافة إلى اتفاقية ترخيص المستخدم النهائي (EULA) لـ
الثنائي المجمعة. كود المصدر هو الملكية.
