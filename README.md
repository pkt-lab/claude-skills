# claude-skills

Claude Code slash commands and skills for persistent work context management.

## Problem

After compaction, context window reset, or long work sessions, Claude loses critical details — architecture decisions, environment specifics, debugging history, and work status. This repo provides slash commands that persist this knowledge to structured markdown files in a git repo, surviving any context loss.

## Commands

### `/sync-docs <target-repo>`
Full sync of all documentation files: STATUS, ARCHITECTURE, ENVIRONMENT, DECISIONS, TROUBLESHOOTING. Run after major changes or daily.

### `/sync-status <target-repo>`
Quick update of STATUS.md only. Lightweight, run frequently (before compaction, at task boundaries).

### `/sync-arch <target-repo>`
Update ARCHITECTURE.md only. Run after structural changes (new components, config changes, dependency updates).

## Installation

### Option 1: Symlink (recommended for single machine)

```bash
# Clone
git clone https://github.com/pkt-lab/claude-skills.git ~/claude-skills

# Symlink commands into Claude Code
ln -sf ~/claude-skills/commands/sync-docs.md ~/.claude/commands/sync-docs.md
ln -sf ~/claude-skills/commands/sync-status.md ~/.claude/commands/sync-status.md
ln -sf ~/claude-skills/commands/sync-arch.md ~/.claude/commands/sync-arch.md
```

### Option 2: Copy

```bash
git clone https://github.com/pkt-lab/claude-skills.git /tmp/claude-skills
cp /tmp/claude-skills/commands/*.md ~/.claude/commands/
```

## Usage

```bash
# In Claude Code:
/sync-docs ~/docs              # Full sync to ~/docs repo
/sync-status ~/docs            # Quick status update
/sync-arch ~/docs              # Architecture doc update
```

## Output Structure

The target repo will contain:

```
~/docs/
  STATUS.md           # Active workstreams, recent changes, blockers
  ARCHITECTURE.md     # System components, data flow, config, dependencies
  ENVIRONMENT.md      # Hardware, software, services, network
  DECISIONS.md        # Append-only decision log with context and rationale
  TROUBLESHOOTING.md  # Known issues, root causes, fixes, prevention
```

## Design Principles

- **Merge, don't overwrite** — new info is merged with existing content
- **Append-only decisions** — decision log never deletes entries
- **Be specific** — exact versions, ports, paths, config values
- **Record "why"** — every decision includes rationale
- **Auto-commit** — changes are git committed automatically

## License

MIT
