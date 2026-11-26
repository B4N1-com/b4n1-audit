// Package b4n1audit is the Go wrapper of the precompiled b4n1-audit binary
// (one-binary-N-wrappers). Resolution: B4N1_AUDIT_BIN > bundled > PATH > loud.
package b4n1audit

import (
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"runtime"
	"strings"
)

func binaryPath() string {
	if p := os.Getenv("B4N1_AUDIT_BIN"); p != "" {
		return p
	}

	name := "b4n1-audit-linux-amd64"
	switch runtime.GOOS {
	case "darwin":
		if runtime.GOARCH == "arm64" {
			name = "b4n1-audit-macos-arm64"
		} else {
			name = "b4n1-audit-macos-x64"
		}
	case "windows":
		if runtime.GOARCH == "386" {
			name = "b4n1-audit-windows-ia32.exe"
		} else {
			name = "b4n1-audit-windows-amd64.exe"
		}
	case "linux":
		switch runtime.GOARCH {
		case "arm64":
			name = "b4n1-audit-linux-arm64"
		case "386":
			name = "b4n1-audit-linux-ia32"
		}
	}

	bundled := filepath.Join("bin", name)
	if _, err := os.Stat(bundled); err == nil {
		return bundled
	}
	return "b4n1-audit"
}

// Run invokes the binary and returns its stdout. A non-zero exit is an error
// (never a silent empty result).
func Run(args ...string) (string, error) {
	cmd := exec.Command(binaryPath(), args...)
	out, err := cmd.Output()
	if err != nil {
		msg := strings.TrimSpace(string(out))
		return "", fmt.Errorf("b4n1-audit failed: %v: %s", err, msg)
	}
	return string(out), nil
}

// Client is a thin handle over the binary.
type Client struct{}

func NewClient() *Client { return &Client{} }

func (c *Client) Help() (string, error)         { return Run("--help") }
func (c *Client) Scan(path string) (string, error) { return Run("scan", path) }
func (c *Client) JSON(path string) (string, error) { return Run("json", path) }
