package b4n1audit

import (
	"strings"
	"testing"
)

// El help explica el uso y lista verbos.
func TestHelpListsVerbs(t *testing.T) {
	help, err := NewClient().Help()
	if err != nil {
		t.Fatalf("help: %v", err)
	}
	lower := strings.ToLower(help)
	if !strings.Contains(lower, "usage") {
		t.Fatalf("--help sin usage: %q", help)
	}
	if !strings.Contains(lower, "scan") && !strings.Contains(lower, "json") && !strings.Contains(lower, "sarif") {
		t.Fatalf("--help no lista verbos: %q", help)
	}
}

// Un verbo inexistente falla loud (§5).
func TestUnknownVerbFails(t *testing.T) {
	if _, err := Run("verb-that-does-not-exist"); err == nil {
		t.Fatal("un verbo inexistente debe devolver error")
	}
}
