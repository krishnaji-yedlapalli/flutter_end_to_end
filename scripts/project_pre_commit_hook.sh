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

# Run Dart analyzer to catch any remaining issues
echo "Re-running Dart analyzer..."
dart analyze lib test # Analyze lib and test folders
if [ $? -ne 0 ]; then
  echo "Dart analyzer found issues. Attempting to apply fixes..."
  dart fix --apply lib test # Apply fixes to lib and test folders
  
  echo "Re-running Dart analyzer after applying fixes..."
  dart analyze lib test # Analyze again after fixes
  if [ $? -ne 0 ]; then
    echo "Dart analyzer still found issues after applying fixes. Please fix them before committing."
    exit 1
  else
    echo "Dart analyzer found issues, but all were fixed automatically."
  fi
else
  echo "No analyzer issues found."
fi

# Format Dart code
# Format Dart code
echo "Formatting Dart code..."
FORMAT_OUTPUT=$(find lib test integration_test -name "*.dart" ! -name "*.g.dart" | xargs dart format 2>&1)
FORMAT_EXIT_CODE=$?

echo "$FORMAT_OUTPUT"

# Check if dart format reported a parsing error
if echo "$FORMAT_OUTPUT" | grep -q "Could not format because the source could not be parsed:"; then
  echo "Dart formatting command failed due to a parsing error."
  exit 1
fi

# If dart format exited with an exception (exit code > 1)
if [ "$FORMAT_EXIT_CODE" -gt 1 ]; then
  echo "Dart formatting command failed with an unexpected exception."
  exit 1
fi

echo "Pre-commit checks passed."
exit 0
