#!/usr/bin/env bash
set -euo pipefail

# Symlinks this repo's skills/ directory into whatever AI coding tools
# a project (or this machine, with --global) uses, so the same skill
# files work across Claude Code, OpenCode, Codex CLI, and Antigravity.
#
# Usage:
#   ./install.sh                # link into the current directory (a project)
#   ./install.sh /path/to/repo  # link into a specific project
#   ./install.sh --global       # link into this machine's global tool config

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

link_skill_dir() {
  local dest="$1"
  mkdir -p "$(dirname "$dest")"
  if [ -e "$dest" ] && [ ! -L "$dest" ]; then
    echo "Skip: $dest already exists and isn't a symlink — leaving it untouched"
    return
  fi
  ln -sfn "$SOURCE_SKILLS" "$dest"
  echo "Linked $dest -> $SOURCE_SKILLS"
}

if [ "$GLOBAL" = true ]; then
  link_skill_dir "$HOME/.claude/skills"
  link_skill_dir "$HOME/.gemini/config/skills"
  link_skill_dir "$HOME/.codex/skills"
  link_skill_dir "$HOME/.config/opencode/skills"
  echo
  echo "Installed globally for Claude Code, Antigravity, Codex CLI, and OpenCode."
else
  link_skill_dir "$TARGET/.claude/skills"
  link_skill_dir "$TARGET/.agents/skills"
  link_skill_dir "$TARGET/.codex/skills"
  echo
  echo "Installed into $TARGET for Claude Code, Antigravity, and Codex CLI."
  echo "OpenCode automatically reads .claude/skills/ and .agents/skills/, so it's covered too."
fi
