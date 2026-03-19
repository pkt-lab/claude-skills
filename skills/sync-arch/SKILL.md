---
name: sync-arch
description: Update ARCHITECTURE.md in project docs/. Use after adding/removing components, changing configs, updating dependencies, or modifying data flows. Also use when the user asks about system design or "how does this work".
argument-hint: "[path] [--push] [--project name]"
disable-model-invocation: true
---

# Update Architecture Documentation

Update only `docs/ARCHITECTURE.md` with current system structure. Read actual config files and code — don't rely on conversation memory alone.

## Arguments

Same as /sync-docs: no args = `<git-root>/docs/`, path = `<path>/docs/`, `--push`, `--project <name>`.

## Steps

1. Resolve target → `<root>/docs/ARCHITECTURE.md`
2. Read existing ARCHITECTURE.md (create from template if missing)
3. Scan for architectural changes:
   - New/removed components
   - Changed data flows or integrations
   - Config file changes (read the actual files)
   - Dependency version changes
4. Update with specifics — component names, file paths, port numbers, config values, version strings
5. Git add → commit: `docs: architecture update [YYYY-MM-DD HH:MM]` → push if `--push`
6. Summary of what changed architecturally
