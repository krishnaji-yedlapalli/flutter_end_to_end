#!/bin/bash
set -euo pipefail

# Pushes the local workspace package layout to the private daily-tracker repo.
# Run from the monorepo root after restructuring features/daily_tracker_feature.

GIT_ROOT=$(git rev-parse --show-toplevel)
PACKAGE_DIR="$GIT_ROOT/features/daily_tracker_feature"
PRIVATE_REMOTE="${1:-https://github.com/krishnaji-yedlapalli/daily-tracker.git}"

if [ ! -f "$PACKAGE_DIR/pubspec.yaml" ]; then
  echo "Error: $PACKAGE_DIR/pubspec.yaml not found." >&2
  exit 1
fi

cd "$PACKAGE_DIR"

if [ ! -d .git ]; then
  git init
fi

if git remote | grep -q '^origin$'; then
  git remote set-url origin "$PRIVATE_REMOTE"
else
  git remote add origin "$PRIVATE_REMOTE"
fi

git add .
git status --short

echo
echo "Review the staged changes above, then push to the private repo:"
echo "  cd $PACKAGE_DIR"
echo "  git commit -m \"refactor: adopt daily_tracker_feature workspace package layout\""
echo "  git push -u origin HEAD:main"
echo
echo "After pushing, register the submodule in the monorepo:"
echo "  cd $GIT_ROOT"
echo "  git submodule add $PRIVATE_REMOTE features/daily_tracker_feature"
