#!/usr/bin/env bash
set -euo pipefail

# Removes the symlinks created by install.sh — only removes a link if it
# still points at this repo's skills/ directory, so it never touches
# anything else that happens to live at the same path.
#
# Usage:
#   ./uninstall.sh                # unlink from the current directory
#   ./uninstall.sh /path/to/repo  # unlink from a specific project
#   ./uninstall.sh --global       # unlink this machine's global tool config

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_SKILLS="$SCRIPT_DIR/skills"

GLOBAL=false
TARGET="$(pwd)"

for arg in "$@"; do
  case "$arg" in
    --global) GLOBAL=true ;;
    *) TARGET="$arg" ;;
  esac
done

unlink_if_ours() {
  local dest="$1"
  if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$SOURCE_SKILLS" ]; then
    rm "$dest"
    echo "Removed $dest"
  fi
}

if [ "$GLOBAL" = true ]; then
  unlink_if_ours "$HOME/.claude/skills"
  unlink_if_ours "$HOME/.gemini/config/skills"
  unlink_if_ours "$HOME/.codex/skills"
  unlink_if_ours "$HOME/.config/opencode/skills"
else
  unlink_if_ours "$TARGET/.claude/skills"
  unlink_if_ours "$TARGET/.agents/skills"
  unlink_if_ours "$TARGET/.codex/skills"
fi
