package config

import (
	"testing"
	"time"
)

func TestLoad(t *testing.T) {
	// Set required environment variables
	t.Setenv("DATABASE_URL", "postgres://test:test@localhost:5432/test")
	t.Setenv("JWT_SECRET", "this-is-a-very-long-secret-key-for-testing-purposes")
	t.Setenv("S3_BUCKET", "test-bucket")

	cfg, err := Load()
	if err != nil {
		t.Fatalf("expected no error, got %v", err)
	}

	if cfg.Database.URL != "postgres://test:test@localhost:5432/test" {
		t.Errorf("expected database URL to be set, got %s", cfg.Database.URL)
	}

	if cfg.JWT.Secret != "this-is-a-very-long-secret-key-for-testing-purposes" {
		t.Errorf("expected JWT secret to be set")
	}

	if cfg.S3.Bucket != "test-bucket" {
		t.Errorf("expected S3 bucket to be set, got %s", cfg.S3.Bucket)
	}
}

func TestLoadMissingRequired(t *testing.T) {
	// Clear required environment variables to test missing validation
	// t.Setenv will restore the original values after the test
	t.Setenv("DATABASE_URL", "")
	t.Setenv("JWT_SECRET", "")
	t.Setenv("S3_BUCKET", "")

	_, err := Load()
	if err == nil {
		t.Fatal("expected error for missing DATABASE_URL")
	}
}

func TestValidateJWTSecretLength(t *testing.T) {
	t.Setenv("DATABASE_URL", "postgres://test:test@localhost:5432/test")
	t.Setenv("JWT_SECRET", "short") // Too short
	t.Setenv("S3_BUCKET", "test-bucket")

	_, err := Load()
	if err == nil {
		t.Fatal("expected error for short JWT secret")
	}
}

func TestGetEnvDefaults(t *testing.T) {
	if got := getEnv("TEST_VAR_NONEXISTENT", "default"); got != "default" {
		t.Errorf("expected default, got %s", got)
	}
}

func TestGetIntEnv(t *testing.T) {
	t.Setenv("TEST_INT", "42")

	if got := getIntEnv("TEST_INT", 0); got != 42 {
		t.Errorf("expected 42, got %d", got)
	}
}

func TestGetBoolEnv(t *testing.T) {
	t.Setenv("TEST_BOOL", "true")

	if got := getBoolEnv("TEST_BOOL", false); !got {
		t.Error("expected true")
	}
}

func TestGetDurationEnv(t *testing.T) {
	t.Setenv("TEST_DURATION", "30s")

	if got := getDurationEnv("TEST_DURATION", time.Second); got != 30*time.Second {
		t.Errorf("expected 30s, got %v", got)
	}
}

func TestDefaultValues(t *testing.T) {
	t.Setenv("DATABASE_URL", "postgres://test:test@localhost:5432/test")
	t.Setenv("JWT_SECRET", "this-is-a-very-long-secret-key-for-testing-purposes")
	t.Setenv("S3_BUCKET", "test-bucket")

	cfg, err := Load()
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}

	// Check defaults
	if cfg.Server.Port != "8080" {
		t.Errorf("expected default port 8080, got %s", cfg.Server.Port)
	}

	if cfg.Server.ReadTimeout != 15*time.Second {
		t.Errorf("expected default read timeout 15s, got %v", cfg.Server.ReadTimeout)
	}

	if cfg.JWT.AccessTokenTTL != 15*time.Minute {
		t.Errorf("expected default access token TTL 15m, got %v", cfg.JWT.AccessTokenTTL)
	}

	if cfg.JWT.RefreshTokenTTL != 7*24*time.Hour {
		t.Errorf("expected default refresh token TTL 7d, got %v", cfg.JWT.RefreshTokenTTL)
	}

	if cfg.S3.Region != "us-east-1" {
		t.Errorf("expected default region us-east-1, got %s", cfg.S3.Region)
	}
}
