#!/bin/bash
# Install claude-skills commands into Claude Code
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_CMD_DIR="$HOME/.claude/commands"

mkdir -p "$CLAUDE_CMD_DIR"

for cmd in "$SCRIPT_DIR"/commands/*.md; do
    name=$(basename "$cmd")
    ln -sf "$cmd" "$CLAUDE_CMD_DIR/$name"
    echo "Linked: $name"
done

echo "Done. Commands available in Claude Code."
