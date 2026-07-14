#!/bin/bash
set -euo pipefail

# Determine the directory where the script is located
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
GIT_ROOT=$(git rev-parse --show-toplevel)
TARGET_FILE="$SCRIPT_DIR/../daily_tracker_entry_point.dart"
PUBSPEC="$GIT_ROOT/pubspec.yaml"
ANALYSIS_OPTIONS="$GIT_ROOT/analysis_options.yaml"
PACKAGE_DIR="$GIT_ROOT/features/daily_tracker_feature"
PACKAGE_PUBSPEC="$PACKAGE_DIR/pubspec.yaml"

# Auto-detect mode: enable if submodule is present, otherwise disable
if [ -f "$PACKAGE_PUBSPEC" ]; then
  MODE="${1:-enabled}"
else
  MODE="${1:-disabled}"
fi

update_pubspec() {
  local action="$1"
  python3 - "$PUBSPEC" "$action" <<'PY'
import sys
from pathlib import Path

pubspec_path = Path(sys.argv[1])
action = sys.argv[2]
lines = pubspec_path.read_text().splitlines(keepends=True)

WORKSPACE_ENTRY = "  - features/daily_tracker_feature\n"
ANCHOR = "  - features/smart_control_mqtt\n"

def has_entry(text_lines, entry):
    return any(line == entry for line in text_lines)

def insert_after(lines, needle, entry):
    for index, line in enumerate(lines):
        if line == needle:
            return lines[: index + 1] + [entry] + lines[index + 1 :]
    raise RuntimeError(f"Could not find insertion point: {needle!r}")

if action == "enable":
    if not has_entry(lines, WORKSPACE_ENTRY):
        lines = insert_after(lines, ANCHOR, WORKSPACE_ENTRY)
elif action == "disable":
    lines = [line for line in lines if line != WORKSPACE_ENTRY]
else:
    raise RuntimeError(f"Unknown action: {action}")

pubspec_path.write_text("".join(lines))
PY
}

update_analysis_options() {
  local action="$1"
  python3 - "$ANALYSIS_OPTIONS" "$action" <<'PY'
import sys
from pathlib import Path

analysis_path = Path(sys.argv[1])
action = sys.argv[2]
lines = analysis_path.read_text().splitlines(keepends=True)

EXCLUDE_ENTRY = "    - features/daily_tracker_feature/**\n"

def has_entry(text_lines, entry):
    return any(line == entry for line in text_lines)

def insert_after(lines, needle, entry):
    for index, line in enumerate(lines):
        if needle in line:
            return lines[: index + 1] + [entry] + lines[index + 1 :]
    raise RuntimeError(f"Could not find insertion point: {needle!r}")

if action == "enable":
    lines = [line for line in lines if line != EXCLUDE_ENTRY]
elif action == "disable":
    if not has_entry(lines, EXCLUDE_ENTRY):
        if not any("exclude:" in line for line in lines):
            lines = insert_after(lines, "analyzer:", ["  exclude:\n"])
        lines = insert_after(lines, "  exclude:", EXCLUDE_ENTRY)
else:
    raise RuntimeError(f"Unknown action: {action}")

analysis_path.write_text("".join(lines))
PY
}

case "$MODE" in
  enabled)
    if [ ! -f "$PACKAGE_PUBSPEC" ]; then
      echo "Error: $PACKAGE_PUBSPEC not found." >&2
      echo "Initialize the private submodule first:" >&2
      echo "  git submodule update --init features/daily_tracker_feature" >&2
      exit 1
    fi
    echo "export 'package:daily_tracker_feature/core/daily_tracker_router_module.dart';" > "$TARGET_FILE"
    update_pubspec enable
    update_analysis_options enable
    echo -e "✅ \033[1;32mDaily Tracker enabled.\033[0m"
    ;;
  disabled)
    echo "export './daily_tracker_stub.dart';" > "$TARGET_FILE"
    update_pubspec disable
    update_analysis_options disable
    echo -e "⚠️ \033[1;33mDaily Tracker disabled; using stub routes.\033[0m"
    ;;
  *)
    echo "Usage: $0 [enabled|disabled]" >&2
    exit 1
    ;;
esac
