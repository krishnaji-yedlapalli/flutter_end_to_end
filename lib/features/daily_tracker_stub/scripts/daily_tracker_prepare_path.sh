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

MODE="${1:-disabled}"

update_pubspec() {
  local action="$1"
  python3 - "$PUBSPEC" "$action" <<'PY'
import sys
from pathlib import Path

pubspec_path = Path(sys.argv[1])
action = sys.argv[2]
content = pubspec_path.read_text()
lines = content.splitlines(keepends=True)

workspace_block = [
    "  # BEGIN daily_tracker_workspace\n",
    "  - features/daily_tracker_feature\n",
    "  # END daily_tracker_workspace\n",
]
dependency_block = [
    "  # BEGIN daily_tracker_dependency\n",
    "  daily_tracker_feature:\n",
    "    path: features/daily_tracker_feature\n",
    "  # END daily_tracker_dependency\n",
]

def remove_block(text_lines, begin_marker, end_marker):
    result = []
    skipping = False
    for line in text_lines:
        if begin_marker in line:
            skipping = True
            continue
        if end_marker in line:
            skipping = False
            continue
        if not skipping:
            result.append(line)
    return result

def has_block(text_lines, begin_marker):
    return any(begin_marker in line for line in text_lines)

def insert_after(lines, needle, block):
    for index, line in enumerate(lines):
        if needle in line:
            return lines[: index + 1] + block + lines[index + 1 :]
    raise RuntimeError(f"Could not find insertion point: {needle}")

if action == "enable":
    if not has_block(lines, "# BEGIN daily_tracker_workspace"):
        lines = insert_after(
            lines,
            "- features/smart_control_mqtt",
            workspace_block,
        )
    if not has_block(lines, "# BEGIN daily_tracker_dependency"):
        lines = insert_after(
            lines,
            "path: features/smart_control_mqtt",
            dependency_block,
        )
elif action == "disable":
    lines = remove_block(lines, "# BEGIN daily_tracker_workspace", "# END daily_tracker_workspace")
    lines = remove_block(lines, "# BEGIN daily_tracker_dependency", "# END daily_tracker_dependency")
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

exclude_block = [
    "    # BEGIN daily_tracker_exclude\n",
    "    - features/daily_tracker_feature/**\n",
    "    # END daily_tracker_exclude\n",
]

def remove_block(text_lines, begin_marker, end_marker):
    result = []
    skipping = False
    for line in text_lines:
        if begin_marker in line:
            skipping = True
            continue
        if end_marker in line:
            skipping = False
            continue
        if not skipping:
            result.append(line)
    return result

def has_block(text_lines, begin_marker):
    return any(begin_marker in line for line in text_lines)

def insert_after(lines, needle, block):
    for index, line in enumerate(lines):
        if needle in line:
            return lines[: index + 1] + block + lines[index + 1 :]
    raise RuntimeError(f"Could not find insertion point: {needle}")

if action == "enable":
    lines = remove_block(lines, "# BEGIN daily_tracker_exclude", "# END daily_tracker_exclude")
elif action == "disable":
    if not has_block(lines, "# BEGIN daily_tracker_exclude"):
        if not any("exclude:" in line for line in lines):
            lines = insert_after(lines, "analyzer:\n", ["  exclude:\n"])
        lines = insert_after(lines, "  exclude:\n", exclude_block)
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
