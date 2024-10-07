// Copyright 2023 Sherry Yin <yinx0004@gmail.com>. All rights reserved.
// Use of this source code is governed by a MIT style
// license that can be found in the LICENSE file.

// Package homedir returns the home directory of Linux and macOS system.
package homedir

import (
	"fmt"
	"os"
	"runtime"
)

// HomeDir returns the home directory for the current user on Linux and macOS.
// It returns an error on Windows.
func HomeDir() (string, error) {
	// Check if the OS is Windows
	if runtime.GOOS == "windows" {
		return "", fmt.Errorf("unsupported OS: %s", runtime.GOOS)
	}

	// For Linux and macOS, return the HOME environment variable
	if homeDir, ok := os.LookupEnv("HOME"); ok {
		return homeDir, nil
	}

	return "", fmt.Errorf("HOME environment variable is not set")
}
