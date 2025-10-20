#!/bin/bash

# Find the Git repository root dynamically
GIT_ROOT=$(git rev-parse --show-toplevel)
if [ -z "$GIT_ROOT" ]; then
  echo "Error: Not a Git repository or git not found."
  exit 1
fi

# Change to the Git root directory
cd "$GIT_ROOT" || exit 1

echo "Running pre-commit checks for the entire project..."

# # # Apply automatic fixes for analyzer issues
# echo "Applying automatic fixes for Dart analyzer issues..."
# dart fix --apply lib

# Run Dart analyzer to catch any remaining issues
echo "Re-running Dart analyzer..."
dart analyze lib
if [ $? -ne 0 ]; then
  echo "Dart analyzer found issues that could not be fixed automatically. Please fix them before committing."
  exit 1
else
  echo "No analyzer issues found."
fi

# Format Dart code
echo "Formatting Dart code..."
find lib -name "*.dart" ! -name "*.g.dart" | xargs dart format
if [ $? -ne 0 ]; then
  echo "Dart formatting command failed."
  exit 1
fi

echo "Pre-commit checks passed."
exit 0
