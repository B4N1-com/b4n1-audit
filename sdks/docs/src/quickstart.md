# Quickstart

The SDK ships the engine for each supported platform inside the package; there
is nothing else to install.

## 1. Scan a tree

```bash
b4n1-audit scan ./src
```

The human report goes to stdout and the exit code is the gate: `0` clean,
non-zero when a finding reaches the configured severity.

## 2. Export for a pipeline

```bash
b4n1-audit json ./src     > audit.json
b4n1-audit sarif ./src    > audit.sarif
b4n1-audit full-json ./src > audit-full.json
```

## 3. From a wrapper

```python
from b4n1audit import Audit

report = Audit().scan("./src")
print(f"{len(report['findings'])} findings")
```

## 4. What the scan covers

Security patterns, dependency declarations, secrets in tracked files and
code-quality rules. Each finding carries a rule id, a file, a line and a
severity — enough for a gate to be a comparison rather than an opinion.
