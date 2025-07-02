#!/bin/bash

# Path to the private module file
FILE="../../daily_tracker/core/daily_tracker_router_module.dart"

# Path where the entry point file should be written
TARGET_FILE="../daily_tracker_entry_point.dart"
TARGET_DIR=$(dirname "$TARGET_FILE")

# Make sure the target directory exists
mkdir -p "$TARGET_DIR"

# Check for private implementation and generate the entry point file accordingly
if [ -f "$FILE" ]; then
  echo -e "✅ \033[1;32mPrivate submodule found. Using real router module.\033[0m"
  echo "export '../daily_tracker/core/daily_tracker_router_module.dart';" > "$TARGET_FILE"
else
  echo -e "⚠️ \033[1;33mPrivate submodule NOT found. Using stub router module.\033[0m"
  echo "export '../daily_tracker_stub/daily_tracker_stub.dart';" > "$TARGET_FILE"
fi
