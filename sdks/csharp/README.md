# b4n1-audit — C# SDK

Wrapper .NET del binario `b4n1-audit` (patrón one-binary-N-wrappers).
Binario empaquetado en `src/native/`, o resuelto con `B4N1_AUDIT_BIN` / `PATH`.

```csharp
using B4n1Audit;

var report = B4n1Audit.Run("json", ".");   // JsonElement (JSON) o string
```

- `RunRaw` lanza `AuditException` con stderr si el binario sale con exit ≠ 0.
- Requires .NET Standard 2.0+. The precompiled binary is bundled in the package.
