# b4n1-audit — Java SDK

Wrapper Java del binario `b4n1-audit` (patrón one-binary-N-wrappers).
Binario empaquetado en `native/`, o resuelto con `B4N1_AUDIT_BIN` / `PATH`.

```java
import com.b4n1.audit.B4n1Audit;

String report = B4n1Audit.run("json", ".");   // salida cruda (JSON como texto)
```

- `runRaw` lanza `AuditException` con stderr si el binario sale con exit ≠ 0.
- Requires Java 11+. The precompiled binary is bundled inside the JAR.
