#!/usr/bin/env bash
set -euo pipefail

# One-command bootstrapper for GC Core Skills.
# Usage (run from inside the project you want the skills in):
#   curl -fsSL https://raw.githubusercontent.com/beingsj/gc-developer-skill/main/get.sh | bash
#   curl -fsSL https://raw.githubusercontent.com/beingsj/gc-developer-skill/main/get.sh | bash -s -- --global
#
# Fetches (or updates) a cached copy of the repo, then delegates to its
# install.sh to symlink skills/ into whichever folder was current when
# this command was run.

REPO_URL="https://github.com/beingsj/gc-developer-skill.git"
TARBALL_URL="https://github.com/beingsj/gc-developer-skill/archive/refs/heads/main.tar.gz"
CACHE_DIR="$HOME/.gc-core-skills"

echo "GC Core Skills installer"

if command -v git >/dev/null 2>&1; then
  if [ -d "$CACHE_DIR/.git" ]; then
    echo "Updating cached copy at $CACHE_DIR ..."
    if ! git -C "$CACHE_DIR" pull --ff-only --quiet; then
      echo "Update failed, re-cloning fresh ..."
      rm -rf "$CACHE_DIR"
      git clone --depth 1 --quiet "$REPO_URL" "$CACHE_DIR"
    fi
  else
    echo "Cloning into $CACHE_DIR ..."
    rm -rf "$CACHE_DIR"
    git clone --depth 1 --quiet "$REPO_URL" "$CACHE_DIR"
  fi
else
  echo "git not found — downloading a tarball instead ..."
  rm -rf "$CACHE_DIR"
  mkdir -p "$CACHE_DIR"
  curl -fsSL "$TARBALL_URL" | tar -xz --strip-components=1 -C "$CACHE_DIR"
fi

bash "$CACHE_DIR/install.sh" "$@"
