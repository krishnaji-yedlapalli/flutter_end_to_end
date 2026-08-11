#!/bin/bash
# =============================================================================
# bump_version.sh
# =============================================================================
# Updates the version in pubspec.yaml based on conventional commit messages.
#
# Bump rules:
#   feat!: / BREAKING CHANGE  →  major (1.0.0 → 2.0.0)
#   feat:                     →  minor (1.0.0 → 1.1.0)
#   fix:, chore:, etc.        →  patch (1.0.0 → 1.0.1)
#
# Usage:
#   ./scripts/bump_version.sh           # auto-detect bump type from commits
#   ./scripts/bump_version.sh major     # force a major bump
#   ./scripts/bump_version.sh minor     # force a minor bump
#   ./scripts/bump_version.sh patch     # force a patch bump
#
# Options:
#   --dry-run    Print what would change without modifying pubspec.yaml
#   --no-commit  Update pubspec.yaml but do not commit or push
#
# Examples:
#   ./scripts/bump_version.sh
#   ./scripts/bump_version.sh --dry-run
#   ./scripts/bump_version.sh minor --no-commit
# =============================================================================

set -e

# ── Argument parsing ──────────────────────────────────────────────────────────
FORCE_BUMP=""
DRY_RUN=false
NO_COMMIT=false

for arg in "$@"; do
  case "$arg" in
    major|minor|patch) FORCE_BUMP="$arg" ;;
    --dry-run)         DRY_RUN=true ;;
    --no-commit)       NO_COMMIT=true ;;
    *)
      echo "Unknown argument: $arg"
      echo "Usage: $0 [major|minor|patch] [--dry-run] [--no-commit]"
      exit 1
      ;;
  esac
done

# ── Resolve repo root ─────────────────────────────────────────────────────────
GIT_ROOT=$(git rev-parse --show-toplevel 2>/dev/null)
if [ -z "$GIT_ROOT" ]; then
  echo "Error: Not inside a Git repository."
  exit 1
fi
cd "$GIT_ROOT"

PUBSPEC="pubspec.yaml"
if [ ! -f "$PUBSPEC" ]; then
  echo "Error: $PUBSPEC not found at repo root ($GIT_ROOT)."
  exit 1
fi

# ── Determine bump type from conventional commits ─────────────────────────────
if [ -n "$FORCE_BUMP" ]; then
  BUMP="$FORCE_BUMP"
  echo "Bump type: $BUMP (forced)"
else
  # Only analyze commits on the current branch that are not on develop
  BASE_BRANCH="develop"
  echo "Analyzing commits ahead of '$BASE_BRANCH'..."
  COMMITS=$(git log "${BASE_BRANCH}..HEAD" --pretty=format:"%s")

  if [ -z "$COMMITS" ]; then
    echo "No new commits ahead of '$BASE_BRANCH'. Nothing to do."
    exit 0
  fi

  echo ""
  echo "Commits being analyzed:"
  echo "$COMMITS"
  echo ""

  BUMP="patch"  # default

  while IFS= read -r msg; do
    # Breaking change: type! or "BREAKING CHANGE" anywhere in message
    if echo "$msg" | grep -qE "^(feat|fix|refactor|perf|chore|docs|style|test|build|ci)(\(.+\))?!:" || \
       echo "$msg" | grep -qi "BREAKING CHANGE"; then
      BUMP="major"
      break
    fi
    # New feature → minor (only escalate, never downgrade)
    if echo "$msg" | grep -qE "^feat(\(.+\))?:" && [ "$BUMP" != "major" ]; then
      BUMP="minor"
    fi
  done <<< "$COMMITS"

  echo "Bump type determined: $BUMP"
fi

# ── Read current version from pubspec.yaml ────────────────────────────────────
VERSION_LINE=$(grep "^version:" "$PUBSPEC")
FULL_VERSION=$(echo "$VERSION_LINE" | sed 's/version: //' | tr -d '[:space:]')

# Validate format: must be semver+build e.g. 1.2.3+45
if ! echo "$FULL_VERSION" | grep -qE "^[0-9]+\.[0-9]+\.[0-9]+\+[0-9]+$"; then
  echo "Error: version in pubspec.yaml ('$FULL_VERSION') is not in expected format (e.g. 1.2.3+45)."
  exit 1
fi

SEMVER=$(echo "$FULL_VERSION" | cut -d'+' -f1)
BUILD=$(echo "$FULL_VERSION" | cut -d'+' -f2)
MAJOR=$(echo "$SEMVER" | cut -d'.' -f1)
MINOR=$(echo "$SEMVER" | cut -d'.' -f2)
PATCH=$(echo "$SEMVER" | cut -d'.' -f3)

echo "Current version: $SEMVER+$BUILD"

# ── Calculate new version ─────────────────────────────────────────────────────
case "$BUMP" in
  major)
    MAJOR=$((MAJOR + 1))
    MINOR=0
    PATCH=0
    ;;
  minor)
    MINOR=$((MINOR + 1))
    PATCH=0
    ;;
  patch)
    PATCH=$((PATCH + 1))
    ;;
esac

NEW_BUILD=$((BUILD + 1))
NEW_SEMVER="${MAJOR}.${MINOR}.${PATCH}"
NEW_FULL="${NEW_SEMVER}+${NEW_BUILD}"

echo "New version:     $NEW_FULL  ($BUMP bump)"

# ── Dry run: stop here ────────────────────────────────────────────────────────
if [ "$DRY_RUN" = true ]; then
  echo ""
  echo "[dry-run] pubspec.yaml would be updated: $FULL_VERSION → $NEW_FULL"
  echo "[dry-run] No files were changed."
  exit 0
fi

# ── Update pubspec.yaml ───────────────────────────────────────────────────────
# Use a temp file for compatibility with both macOS (BSD sed) and Linux (GNU sed)
TEMP_FILE=$(mktemp)
sed "s/^version: ${FULL_VERSION}/version: ${NEW_FULL}/" "$PUBSPEC" > "$TEMP_FILE"
mv "$TEMP_FILE" "$PUBSPEC"

echo ""
echo "Updated pubspec.yaml:"
grep "^version:" "$PUBSPEC"

# ── Commit and push ───────────────────────────────────────────────────────────
if [ "$NO_COMMIT" = true ]; then
  echo ""
  echo "pubspec.yaml updated. Skipping commit (--no-commit)."
  exit 0
fi

git add "$PUBSPEC"

# Nothing staged means the file didn't change (shouldn't happen, but guard it)
if git diff --cached --quiet; then
  echo "Nothing to commit — pubspec.yaml was already at $NEW_FULL."
  exit 0
fi

git commit -m "chore(release): bump version to $NEW_FULL"
git push

echo ""
echo "Version bumped to $NEW_FULL and pushed."
