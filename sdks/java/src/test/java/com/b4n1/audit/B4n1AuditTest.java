package com.b4n1.audit;

/** Smoke test del wrapper Java: usage con verbos y fallo loud ante verbo desconocido. */
public final class B4n1AuditTest {

    public static void main(String[] args) {
        String help = B4n1Audit.runRaw("--help");
        String lower = help.toLowerCase();

        if (!lower.contains("usage")) {
            throw new AssertionError("--help sin usage: " + help);
        }
        if (!(lower.contains("scan") || lower.contains("json") || lower.contains("sarif"))) {
            throw new AssertionError("--help no lista verbos: " + help);
        }

        try {
            B4n1Audit.runRaw("verb-that-does-not-exist");
            throw new AssertionError("un verbo inexistente debe lanzar AuditException");
        } catch (B4n1Audit.AuditException expected) {
            // contrato §5: el fallo es loud y tipado
        }

        System.out.println("ok help + fallo tipado");
    }
}
