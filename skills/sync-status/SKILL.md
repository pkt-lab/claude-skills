---
name: sync-status
description: "Quick update of STATUS.md only — the lightweight alternative to /sync-docs. Use this frequently: before compaction, when switching tasks, ending a session, or whenever the user says 'update status', 'save progress', 'what's the state', 'checkpoint'. This only touches STATUS.md so it's fast. If the user needs architecture, environment, or troubleshooting updates too, suggest /sync-docs instead."
argument-hint: "[path] [--push] [--project name] [--docs-repo path] [--save-config]"
disable-model-invocation: true
---

# Quick Status Update

Update only `docs/STATUS.md` with current workstreams, recent changes, and blockers. This is the fast, frequent counterpart to `/sync-docs` — run it often so progress is never lost to compaction.

## Arguments

- No args → write to `<git-root>/docs/STATUS.md`
- Path → write to `<path>/docs/STATUS.md`
- `--push` → git push after commit
- `--project <name>` → scope under `docs/<name>/STATUS.md`
- `--docs-repo <path>` → write to a separate repo (see /sync-docs for full details)
- `--save-config` → persist the `--docs-repo` mapping for this working repo

See /sync-docs for full resolution order and private docs repo details.

## What goes in STATUS.md

STATUS.md is the "where are we right now" file. Someone opening a new session should read this first and immediately understand what's in progress, what just happened, and what's blocked.

### Active workstreams
Use checkboxes. Be specific about what's done and what remains:
```markdown
- [x] Built TC3 firmware stack (RSE, SCP, TF-A, U-Boot, Linux)
- [ ] Android build — blocked on Docker installation
- [ ] Performance benchmarking — not started
```

### Recent changes
Date-stamped, with enough detail to reconstruct context:
```markdown
## Recent Changes
- **2026-03-19**: Built and booted Linux 6.1.75 on FVP_TC3 with buildroot rootfs
- **2026-03-19**: Patched build-linux.sh to bypass Kleaf/Bazel (forced make path)
```

### Blockers and known issues
What's stuck and why. Include workarounds if any exist.

## Execution

1. Resolve target using /sync-docs resolution order → `<target>/STATUS.md`
2. Read existing STATUS.md (create from template if missing)
3. From conversation context: update active workstreams, add recent changes with dates, note any new blockers or resolved issues
4. Merge — don't remove valid existing content
5. Git operations:
   - If target is in a different repo: `git -C <docs-repo>` add → commit: `docs(<project>): status update [YYYY-MM-DD HH:MM]` (body: `Source: <working-repo-path>`) → push if `--push`
   - If target is in working repo: git add → commit: `docs: status update [YYYY-MM-DD HH:MM]` → push if `--push`
6. One-line summary of what changed
