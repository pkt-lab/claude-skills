# /sync-status — Quick Status Update Only

Lightweight version of /sync-docs. Only updates `STATUS.md` in the target repo with current workstream status, recent changes, and blockers. Fast, minimal, designed to be run frequently (e.g., before compaction or at task boundaries).

## Target Repo
`$ARGUMENTS` (default: `~/docs`)

## Steps
1. Read existing `STATUS.md` in target repo
2. Scan conversation for current work state
3. Update STATUS.md (merge, don't overwrite)
4. Git commit: `docs: status update [YYYY-MM-DD HH:MM]`
5. One-line summary of what changed
