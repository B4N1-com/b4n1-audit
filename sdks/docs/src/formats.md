# Output formats

Every format comes from the same scan, so a finding present in the human report
is present in the export — the batch suite pins that.

## Human report

`b4n1-audit scan <dir>` prints one line per finding with rule id, severity,
file and line.

## JSON

```bash
b4n1-audit json <dir>
```

A single object with the scan metadata and a `findings` array. This is the shape
the wrappers return.

## SARIF

```bash
b4n1-audit sarif <dir>
```

SARIF 2.1.0, for code-scanning dashboards that already ingest it.

## Full multi-scanner pass

```bash
b4n1-audit full-json <dir>
```

Runs every scanner the engine carries and returns one combined document, for
when a single rule family is not enough.
