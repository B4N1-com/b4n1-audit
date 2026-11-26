<?php
// Smoke test del wrapper PHP de b4n1-audit: help con verbos y fallo loud.
require __DIR__ . "/../src/AuditClient.php";

$client = new B4N1\Audit\AuditClient();
$help = strtolower($client->help());

if (!str_contains($help, "usage")) {
    fwrite(STDERR, "--help sin usage\n");
    exit(1);
}
if (!preg_match('/scan|json|sarif/', $help)) {
    fwrite(STDERR, "--help no lista verbos\n");
    exit(1);
}

try {
    $client->runRaw(["verb-that-does-not-exist"]);
    fwrite(STDERR, "un verbo inexistente debe fallar loud\n");
    exit(1);
} catch (RuntimeException $expected) {
    // contrato §5: el fallo es loud
}

echo "ok help + fallo tipado\n";
