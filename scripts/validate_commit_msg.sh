#!/bin/bash

# Get the commit message from the file passed as the first argument
COMMIT_MSG_FILE=$1
COMMIT_MSG=$(cat "$COMMIT_MSG_FILE")

# Define the regex for Conventional Commits
# Basic pattern: type(scope?)?!: subject
# Types: feat, fix, docs, style, refactor, test, chore, perf, build, ci, revert
# Subject: 1 to 50 characters
REGEX="^(feat|fix|docs|style|refactor|test|chore|perf|build|ci|revert)(\([^)]+\))?!?: .{1,50}"

if [[ ! "$COMMIT_MSG" =~ $REGEX ]]; then
  echo "Error: Invalid commit message format."
  echo "Please follow the Conventional Commits specification."
  echo "Example: feat(scope): add new feature"
  echo "Example: feat!: remove legacy API"
  echo "Example: fix: resolve bug in login"
  echo "Valid types: feat, fix, docs, style, refactor, test, chore, perf, build, ci, revert"
  exit 1
fi

exit 0
