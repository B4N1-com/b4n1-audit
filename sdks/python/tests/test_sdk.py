"""Smoke test del wrapper Python de b4n1-audit.

Contrato real: resuelve el binario, `--help` lista subcomandos y un verbo
inexistente falla loud con AuditError (§5), nunca con un fallback. El motor no
ofrece `--version` (exige subcomando), así que la franja se comprueba por el
usage.
"""

import re

import pytest

from b4n1audit import AuditError, binary_path, run_raw, __version__


def test_sdk_version_is_semver():
    assert re.fullmatch(r"\d+\.\d+\.\d+", __version__)


def test_binary_resolves():
    assert binary_path()


def test_help_lists_usage_and_verbs():
    out = run_raw("--help")
    assert re.search(r"usage", out, re.I), out
    assert re.search(r"scan|json|sarif", out, re.I), out


def test_unknown_verb_fails_loud():
    with pytest.raises(AuditError):
        run_raw("verb-that-does-not-exist")
