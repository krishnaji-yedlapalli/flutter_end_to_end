#!/bin/bash

# Determine the directory where the script is located
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)

# Path to the private module file, calculated relative to the script's location
FILE="$SCRIPT_DIR/../../daily_tracker/core/daily_tracker_router_module.dart"

# Path where the entry point file should be written
TARGET_FILE="$SCRIPT_DIR/../daily_tracker_entry_point.dart"

# Check for private implementation and generate the entry point file accordingly
if [ -f "$FILE" ]; then
  echo -e "✅ \033[1;32mPrivate submodule found. Using real router module.\033[0m"
  # The export path needs to be relative to the TARGET_FILE's location
  echo "export '../daily_tracker/core/daily_tracker_router_module.dart';" > "$TARGET_FILE"
else
  echo -e "⚠️ \033[1;33mPrivate submodule NOT found. Using stub router module.\033[0m"
  # The export path needs to be relative to the TARGET_FILE's location
  echo "export './daily_tracker_stub.dart';" > "$TARGET_FILE"
fi
