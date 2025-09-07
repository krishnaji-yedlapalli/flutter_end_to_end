#!/bin/bash

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