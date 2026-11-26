# Examples — b4n1-audit

Every example runs offline against the binary that ships with the SDK.

## 1. Scan a project

```bash
b4n1-audit scan ./src
```

## 2. Machine-readable output

```bash
b4n1-audit json ./src > audit.json
```

## 3. Full multi-scanner pass

```bash
b4n1-audit full-json ./src > audit-full.json
```

## 4. From a wrapper

```python
from b4n1audit import Audit

report = Audit().scan("./src")          # same engine as the CLI
print(len(report["findings"]))
```
