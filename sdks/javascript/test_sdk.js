'use strict';

// Smoke test del wrapper JS de b4n1-audit: resuelve el binario, `--help` lista
// subcomandos y un verbo inexistente falla loud con AuditError (§5).
const assert = require('node:assert');
const { runRaw, binaryPath, AuditError } = require('./src/index.js');

assert.ok(binaryPath(), 'binaryPath debe resolver el binario');

const help = runRaw('--help');
assert.match(help, /usage/i, '--help debe explicar el uso');
assert.match(help, /scan|json|sarif/i, '--help debe listar verbos');

assert.throws(
  () => runRaw('verb-that-does-not-exist'),
  (e) => e instanceof AuditError,
  'un verbo inexistente debe lanzar AuditError'
);

console.log('ok help + fallo tipado');
