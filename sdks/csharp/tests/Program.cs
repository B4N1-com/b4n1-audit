using System;
using B4n1Audit;

internal static class Program
{
    private static int Main()
    {
        var help = B4n1Audit.B4n1Audit.RunRaw("--help");
        var lower = help.ToLowerInvariant();

        if (!lower.Contains("usage"))
        {
            Console.Error.WriteLine($"--help sin usage: {help}");
            return 1;
        }
        if (!(lower.Contains("scan") || lower.Contains("json") || lower.Contains("sarif")))
        {
            Console.Error.WriteLine($"--help no lista verbos: {help}");
            return 1;
        }

        try
        {
            B4n1Audit.B4n1Audit.RunRaw("verb-that-does-not-exist");
            Console.Error.WriteLine("un verbo inexistente debe lanzar AuditException");
            return 1;
        }
        catch (B4n1Audit.B4n1Audit.AuditException)
        {
            // contrato §5: el fallo es loud y tipado
        }

        Console.WriteLine("ok help + fallo tipado");
        return 0;
    }
}
