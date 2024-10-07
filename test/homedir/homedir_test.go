package homedir_test

import (
	"os"
	"runtime"
	"testing"

	"github.com/yinx0004/common-util/pkg/util/homedir"
)

// TestHomeDir tests the HomeDir function in different scenarios.
func TestHomeDir(t *testing.T) {
	// Backup original HOME environment variable
	originalHome := os.Getenv("HOME")
	defer func() {
		// Restore the original HOME after the test
		_ = os.Setenv("HOME", originalHome)
	}()

	t.Run("should return home directory on Linux/Mac when HOME is set", func(t *testing.T) {
		// Set a mock HOME environment variable
		mockHome := "/mock/home"
		_ = os.Setenv("HOME", mockHome)

		// Call HomeDir and check the result
		homeDir, err := homedir.HomeDir()
		if err != nil {
			t.Errorf("expected no error, but got %v", err)
		}
		if homeDir != mockHome {
			t.Errorf("expected home directory %s, but got %s", mockHome, homeDir)
		}
	})

	t.Run("should return error when HOME is not set on Linux/Mac", func(t *testing.T) {
		// Unset the HOME environment variable
		_ = os.Unsetenv("HOME")

		// Call HomeDir and expect an error
		_, err := homedir.HomeDir()
		if err == nil {
			t.Errorf("expected an error, but got none")
		}
	})

	t.Run("should return error on Windows", func(t *testing.T) {
		if runtime.GOOS == "windows" {
			// Simulate Windows behavior
			_, err := homedir.HomeDir()
			if err == nil {
				t.Errorf("expected an error on Windows, but got none")
			}
		}
	})
}
