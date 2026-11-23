[English](../README.md) · [Español](README.es.md) · [Deutsch](README.de.md) · [Français](README.fr.md) · [Italiano](README.it.md) · [Português (BR)](README.pt-BR.md) · [Русский](README.ru.md) · [العربية](README.ar.md) · [हिन्दी](README.hi.md) · [日本語](README.ja.md) · [한국어](README.ko.md) · [中文](README.zh-CN.md)

<p align="center">
  <img src="b4n1_audit_presentation.png" alt="B4N1 Audit — security and code-quality scanner" width="100%" />
</p>

# b4n1-audit

सुरक्षा और कोड-गुणवत्ता स्कैनर - एक देशी कोर, पायथन, जावास्क्रिप्ट, जावा और सी# के लिए पतले रैपर।

[![PyPI](https://img.shields.io/pypi/v/b4n1-audit.svg)](https://pypi.org/project/b4n1-audit/)
[![Python](https://img.shields.io/pypi/pyversions/b4n1-audit.svg)](https://pypi.org/project/b4n1-audit/)
[![Downloads](https://img.shields.io/pepy/dt/b4n1-audit.svg)](https://pypi.org/project/b4n1-audit/)
[![License](https://img.shields.io/badge/license-BUSL--1.1-blue.svg)](LICENSE)

के लिए पायथन रैपर `b4n1-audit` इंजन - एक सुरक्षा और कोड-गुणवत्ता
स्कैनर जो एकल पूर्व संकलित बाइनरी के रूप में शिप होता है। बाइनरी को प्रति बंडल किया गया है
पहिये के अंदर मंच; संकलित करने के लिए कुछ भी नहीं है और कोई बाहरी रनटाइम नहीं है।

## स्थापित करना

```bash
pip install b4n1-audit
```

पायथन की आवश्यकता है ≥ 3.8. पूर्व संकलित बाइनरी शामिल है (लिनक्स x64/arm64, विंडोज़ x64)।

## त्वरित शुरुआत

```python
from b4n1audit import run, binary_path, AuditError

print(binary_path())          # resolved binary path (fails loud if none)
report = run("json", ".")     # dict/list parsed from JSON output
sarif  = run("sarif", ".")    # SARIF document as text
```

`run()` उठाता `AuditError` (बाइनरी के stderr के साथ) जब प्रक्रिया समाप्त हो जाती है
शून्येतर. बाइनरी रिज़ॉल्यूशन ऑर्डर: `B4N1_AUDIT_BIN` → बंडल बाइनरी → `PATH`.

## यह क्या स्कैन करता है

SDK संपूर्ण इंजन सतह को उजागर करता है, उदाहरण के लिए:

| क्रिया | उद्देश्य |
|------|---------|
| `scan` / `json` | निर्देशिका स्कैन, JSON रिपोर्ट |
| `sarif` | सीआई एकीकरण के लिए SARIF आउटपुट |
| `cve-check` | एम्बेडेड डेटाबेस के विरुद्ध निर्भरता सीवीई जाँच |
| `secrets` | फ़ाइलों और इतिहास में एपीआई कुंजियाँ/टोकन |
| `scan-ai` | शीघ्र इंजेक्शन, एमसीपी और रेपो-पॉइज़निंग जाँच |
| `memory` | मेमोरी-सुरक्षा समस्याएँ (लीक, यूबी, ओवरफ्लो) |
| `semgrep` | फास्ट-पाथ नियम इंजन |
| `report` | स्व-निहित HTML रिपोर्ट |

```bash
# via the bundled binary directly
python -c "from b4n1audit import binary_path; import sys; print(binary_path())"
$(python -c "from b4n1audit import binary_path; print(binary_path())") scan .
```

## लाइसेंस

बिजनेस सोर्स लाइसेंस 1.1 (बीयूएसएल-1.1) प्लस ईयूएलए के तहत वितरित किया गया
बंडल बाइनरी. स्रोत कोड मालिकाना है.
