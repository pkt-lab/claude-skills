# claude-context-keeper

Keep track of what Claude did — so the next session doesn't start from scratch.

## Problem

When Claude's context gets compacted, the session ends, or you start a fresh agent, all the work context is gone — architecture decisions, environment details, debugging history, current status. These skills automatically persist that knowledge to structured markdown files in your project's `docs/` directory. Any future Claude session can read them and pick up exactly where the last one left off.

## Skills

### `/sync-docs [path] [--push] [--project name]`
Full sync of all documentation: STATUS, ARCHITECTURE, ENVIRONMENT, TROUBLESHOOTING. Run after major changes or at task boundaries.

### `/sync-status [path] [--push] [--project name]`
Quick update of STATUS.md only. Lightweight, run frequently — before compaction, switching tasks, or ending a session.

### `/sync-arch [path] [--push] [--project name]`
Update ARCHITECTURE.md only. Run after adding/removing components, changing configs, or updating dependencies.

### Options

| Flag | Description |
|------|-------------|
| `--push` | Auto `git push` after commit |
| `--project <name>` | Scope docs under `docs/<name>/` subdirectory |

## Installation

```bash
git clone https://github.com/pkt-lab/claude-context-keeper.git ~/claude-context-keeper
cd ~/claude-context-keeper && ./install.sh
```

This creates symlinks in `~/.claude/skills/` pointing to the repo. Restart Claude Code to see the `/sync-*` commands in autocomplete.

Or manually:
```bash
mkdir -p ~/.claude/skills
ln -sfn ~/claude-context-keeper/skills/sync-docs ~/.claude/skills/sync-docs
ln -sfn ~/claude-context-keeper/skills/sync-status ~/.claude/skills/sync-status
ln -sfn ~/claude-context-keeper/skills/sync-arch ~/.claude/skills/sync-arch
```

## Usage

```bash
# Default: writes to <git-root>/docs/ in current project
/sync-docs
/sync-status
/sync-arch

# With auto-push
/sync-docs --push

# Target a different repo
/sync-docs ~/other-repo
/sync-status ~/other-repo --push

# Multi-project repo
/sync-docs ~/infra-docs --project myapp --push
/sync-status ~/infra-docs --project backend --push
```

## Output Structure

```
<project-root>/
├── src/
├── docs/                 # created by sync skills
│   ├── STATUS.md         # workstreams, recent changes, blockers
│   ├── ARCHITECTURE.md   # components, data flow, config, deps
│   ├── ENVIRONMENT.md    # hardware, software, services, network
│   └── TROUBLESHOOTING.md # known issues, root causes, fixes
├── CLAUDE.md
└── ...

# With --project myapp:
<target>/
└── docs/
    └── myapp/
        ├── STATUS.md
        └── ...
```

Decisions are recorded in **git commit messages** — `git log` is the decision history.

## Repo Structure

```
claude-context-keeper/
├── skills/
│   ├── sync-docs/SKILL.md     # full context sync
│   ├── sync-status/SKILL.md   # quick status update
│   └── sync-arch/SKILL.md     # architecture update
├── install.sh
├── LICENSE
└── README.md
```

## Design Principles

- **Merge, don't overwrite** — new info is merged with existing content
- **Selective update** — only touch files with meaningful changes
- **Decisions in commits** — rich commit messages with context/rationale
- **Be specific** — exact versions, ports, paths, config values
- **Record "why"** — every change includes rationale
- **No secrets** — never write API keys, tokens, or passwords

## License

MIT
