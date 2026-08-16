# Scripts

Shell scripts for project automation, versioning, and device configuration.

## Overview

This directory contains utility scripts used for development workflow automation, CI/CD support, and embedded device (Raspberry Pi kiosk) setup.

## Scripts

### Version Management

| Script | Purpose | Usage |
|--------|---------|-------|
| `bump_version.sh` | Bumps the project version in `pubspec.yaml` based on conventional commit messages. Supports major/minor/patch detection from commit history, forced bump types, dry-run mode, and optional auto-commit. | `./scripts/bump_version.sh [major\|minor\|patch] [--dry-run] [--no-commit]` |

#### Bump Rules

- `feat!:` or `BREAKING CHANGE` → major (1.0.0 → 2.0.0)
- `feat:` → minor (1.0.0 → 1.1.0)
- `fix:`, `chore:`, etc. → patch (1.0.0 → 1.0.1)

### Git Hooks

| Script | Purpose | Usage |
|--------|---------|-------|
| `project_pre_commit_hook.sh` | Runs Dart analyzer and code formatting across the main project (`lib/`, `test/`, `features/schools/`). Attempts automatic fixes before failing. | Runs automatically via pre-commit hook |
| `daily_tracker_pre_commit_hook.sh` | Runs Dart analyzer and code formatting specifically for the `daily_tracker_feature` private submodule. Skips gracefully if the submodule is not initialized. | Runs automatically via pre-commit hook |
| `validate_commit_msg.sh` | Validates that commit messages follow the Conventional Commits specification. Enforces allowed types (`feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`, `perf`, `build`, `ci`, `revert`) with optional scope and 1–50 character subject. | Runs automatically via commit-msg hook |

### Kiosk / Embedded Device

| Script | Purpose | Usage |
|--------|---------|-------|
| `setup_kiosk_permissions.sh` | Configures system permissions for the Flutter kiosk app on Raspberry Pi 5 with Touch Display 2. Sets up udev rules for backlight control, RTC wake alarm access, and passwordless shutdown via sudoers. | `sudo ./scripts/setup_kiosk_permissions.sh` |
| `kiosk-app.service` | systemd service unit file that runs the Flutter kiosk application on boot. Configures auto-restart on failure, display environment variables, and runs as the `pi` user. | Copy to `/etc/systemd/system/` and enable via `systemctl` |

#### Kiosk Service Installation

```bash
# Copy service file
sudo cp scripts/kiosk-app.service /etc/systemd/system/kiosk-app.service

# Reload systemd and enable
sudo systemctl daemon-reload
sudo systemctl enable kiosk-app.service
sudo systemctl start kiosk-app.service

# Check status
sudo systemctl status kiosk-app.service

# View logs
journalctl -u kiosk-app.service -f
```

## Prerequisites

- **Bash shell** (macOS or Linux)
- **`chmod +x`** permission on script files before execution
- **Git** (required for `bump_version.sh` and git hook scripts)
- **Dart SDK** (required for `project_pre_commit_hook.sh` and `daily_tracker_pre_commit_hook.sh`)
- **For kiosk scripts:** Raspberry Pi 5 with systemd, Touch Display 2, and root/sudo access

## Setting Up Pre-commit Hooks

The git hook scripts integrate with the [pre-commit](https://pre-commit.com/) framework:

```bash
pip install pre-commit
pre-commit install
```

See `.pre-commit-config.yaml` at the project root for hook configuration.

## Related

- [Root README](../README.md)
