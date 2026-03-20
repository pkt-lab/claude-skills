# claude-context-keeper

Keep track of what Claude did — so the next session doesn't start from scratch.

## Problem

When Claude's context gets compacted, the session ends, or you start a fresh agent, all the work context is gone — architecture decisions, environment details, debugging history, current status. These skills automatically persist that knowledge to structured markdown files in your project's `docs/` directory. Any future Claude session can read them and pick up exactly where the last one left off.

## Skills

### `/sync-docs [path] [--push] [--project name] [--docs-repo path] [--save-config]`
Full sync of all documentation: STATUS, ARCHITECTURE, ENVIRONMENT, TROUBLESHOOTING. Run after major changes or at task boundaries.

### `/sync-status [path] [--push] [--project name] [--docs-repo path] [--save-config]`
Quick update of STATUS.md only. Lightweight, run frequently — before compaction, switching tasks, or ending a session.

### `/sync-arch [path] [--push] [--project name] [--docs-repo path] [--save-config]`
Update ARCHITECTURE.md only. Run after adding/removing components, changing configs, or updating dependencies.

### Options

| Flag | Description |
|------|-------------|
| `--push` | Auto `git push` after commit |
| `--project <name>` | Scope docs under `docs/<name>/` subdirectory |
| `--docs-repo <path>` | Write docs to a separate repo (auto-derives project from working repo basename) |
| `--save-config` | Persist `--docs-repo` mapping for this working repo in `~/.config/claude-skills/config.json` |

## Installation

### Via plugin marketplace (recommended)

```bash
# Add as a marketplace source
/plugin marketplace add pkt-lab/claude-context-keeper

# Then install
/plugin install context-keeper@pkt-lab-claude-context-keeper
```

After installing as a plugin, skills are namespaced: `/context-keeper:sync-docs`, `/context-keeper:sync-status`, `/context-keeper:sync-arch`.

### Via git clone + symlink

```bash
git clone https://github.com/pkt-lab/claude-context-keeper.git ~/claude-context-keeper
cd ~/claude-context-keeper && ./install.sh
```

This creates symlinks in `~/.claude/skills/` so skills appear as `/sync-docs`, `/sync-status`, `/sync-arch`.

### Manual

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

## Private Docs Repo

For public/open-source repos where environment details, hardware specs, or debugging history shouldn't be committed publicly, write docs to a **separate private repo**.

### Setup

```bash
# One-time: save the mapping so future runs auto-resolve
/sync-docs --docs-repo ~/private-docs --save-config

# From now on, bare commands auto-resolve via config
/sync-docs          # → ~/private-docs/docs/my-public-app/
/sync-status        # → ~/private-docs/docs/my-public-app/STATUS.md
/sync-arch          # → ~/private-docs/docs/my-public-app/ARCHITECTURE.md

# One-off without saving
/sync-docs --docs-repo ~/private-docs
```

### How It Works

- Config is stored in `~/.config/claude-skills/config.json` (invisible to public repos)
- Project name is auto-derived from the working repo's directory basename
- Source context (git log, code, services) is always gathered from the **working repo**
- Writes, commits, and pushes happen in the **docs repo**
- Commit messages include `Source: <working-repo-path>` for traceability

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

# With --docs-repo ~/private-docs (from working repo "my-public-app"):
~/private-docs/
└── docs/
    └── my-public-app/
        ├── STATUS.md
        ├── ARCHITECTURE.md
        ├── ENVIRONMENT.md
        └── TROUBLESHOOTING.md
```

Decisions are recorded in **git commit messages** — `git log` is the decision history.

## Repo Structure

```
claude-context-keeper/
├── .claude-plugin/
│   └── plugin.json            # plugin manifest for marketplace install
├── skills/
│   ├── sync-docs/SKILL.md     # full context sync
│   ├── sync-status/SKILL.md   # quick status update
│   └── sync-arch/SKILL.md     # architecture update
├── install.sh                 # symlink installer (alternative to plugin)
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
