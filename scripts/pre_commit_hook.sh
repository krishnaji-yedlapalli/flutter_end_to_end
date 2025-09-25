#!/bin/bash

# Find the Git repository root dynamically
GIT_ROOT=$(git rev-parse --show-toplevel)
if [ -z "$GIT_ROOT" ]; then
  echo "Error: Not a Git repository or git not found."
  exit 1
fi

# Change to the Git root directory
cd "$GIT_ROOT" || exit 1

echo "Running pre-commit checks for daily_tracker..."

# Run Dart analyzer
echo "Running Dart analyzer..."
dart analyze lib/features/daily_tracker
if [ $? -ne 0 ]; then
  echo "Dart analyzer found issues. Please fix them before committing."
  exit 1
fi

# Check Dart formatting
echo "Checking Dart formatting..."
dart format --output=none --set-exit-if-changed lib/features/daily_tracker
if [ $? -ne 0 ]; then
  echo "Dart formatting issues found. Please run 'dart format lib/features/daily_tracker' to fix them."
  exit 1
fi

echo "Pre-commit checks passed."
exit 0