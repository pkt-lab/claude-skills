---
name: sync-status
description: Quick update of STATUS.md in project docs/. Use whenever the user says "update status", "what's the state", or before switching tasks, compaction, or ending a session. Lighter than /sync-docs — only touches STATUS.md.
argument-hint: "[path] [--push] [--project name]"
disable-model-invocation: true
---

# Quick Status Update

Update only `docs/STATUS.md` with current workstreams, recent changes, and blockers. Fast and minimal — run this often.

## Arguments

Same as /sync-docs: no args = `<git-root>/docs/`, path = `<path>/docs/`, `--push`, `--project <name>`.

## Steps

1. Resolve target → `<root>/docs/STATUS.md`
2. Read existing STATUS.md (create from template if missing)
3. From conversation context: update active workstreams, add recent changes with dates, note any new blockers or resolved issues
4. Merge — don't remove valid existing content
5. Git add → commit: `docs: status update [YYYY-MM-DD HH:MM]` → push if `--push`
6. One-line summary
