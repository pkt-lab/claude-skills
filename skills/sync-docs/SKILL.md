---
name: sync-docs
description: "IMPORTANT: Use this skill to persist work context to structured docs that survive compaction and context resets. Trigger whenever the user says 'sync', 'save state', 'update docs', 'persist context', 'write it down', or any variation. Also trigger proactively before compaction, at natural task boundaries, after major debugging sessions, or when significant architectural/environment changes were made. This is the full sync — updates STATUS.md, ARCHITECTURE.md, ENVIRONMENT.md, and TROUBLESHOOTING.md. If the user only needs a quick status update, suggest /sync-status instead."
argument-hint: "[path] [--push] [--project name]"
disable-model-invocation: true
---

# Sync Work Context to Project Docs

Capture the current work state and update structured documentation files in the project's `docs/` directory. These files let future sessions reconstruct full context after compaction or restart.

## Arguments

- No args → write to `<git-root>/docs/` (find root via `git rev-parse --show-toplevel`)
- Path → write to `<path>/docs/`
- `--push` → git push after commit
- `--project <name>` → scope under `docs/<name>/`

```
/sync-docs                                     # <git-root>/docs/
/sync-docs --push                              # same + push
/sync-docs ~/other-repo                        # ~/other-repo/docs/
/sync-docs ~/infra-docs --project myapp --push # ~/infra-docs/docs/myapp/ + push
```

## Files to Update

Only update files where you have meaningful new information. Read existing files first and merge — stale-but-valid content should stay.

### STATUS.md — What's happening now
Active workstreams (with checkboxes), recent changes (dated), pending/blocked items, known issues. This is the file someone reads first to get oriented.

### ARCHITECTURE.md — How the system works
Overview paragraph, component table (name/location/purpose/status), data flow (text or diagram), key configuration files and their critical settings, external dependencies with versions.

### ENVIRONMENT.md — Where it runs
Hardware specs, OS/kernel/package versions, running services with ports, network notes, auth methods (describe what exists, never include actual secrets — credentials in docs defeat the purpose of having docs).

### TROUBLESHOOTING.md — What went wrong and how to fix it
Each entry: symptom, root cause, fix, prevention. This is the most valuable file after a long debugging session — capture the fix while it's fresh.

## How to Write Good Docs

**Be specific.** Future-you after compaction only has what's written here. "Changed the config" is useless. "Changed `contextTokens` from 120000 to 200000 in `~/.openclaw/openclaw.json` because 120k caused timeout at 300s" is useful.

**Include rationale.** For every config value, architectural choice, or workaround — explain why. This context is exactly what gets lost during compaction and is hardest to reconstruct.

**Merge, don't replace.** Read existing content first. New info gets added or updates stale sections. Don't delete valid content just because it wasn't part of this session.

**Commit messages are the decision log.** Write them with context and rationale:
```
docs: update architecture after adding redis cache

Context: API latency exceeded 500ms p99 under load
Alternatives: considered in-memory LRU (insufficient for multi-process),
  Memcached (less feature-rich), decided on Redis for pub/sub support
```
This means `git log` serves as the decision history — no separate decisions file needed.

## Execution

1. Parse arguments, resolve target to `<root>/docs/` (create if needed)
2. Gather context from conversation, `git log --oneline -20`, running services, config files, environment — skip what's not relevant
3. Read existing docs in target
4. Update changed files only
5. `git add` changed files → commit → push if `--push`
6. Output one-line-per-file summary of what changed
