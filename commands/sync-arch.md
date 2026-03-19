# /sync-arch — Update Architecture Documentation

Focused update of `ARCHITECTURE.md` in the target repo. Use after making structural changes (new components, config changes, dependency updates).

## Target Repo
`$ARGUMENTS` (default: `~/docs`)

## Steps
1. Read existing `ARCHITECTURE.md`
2. Scan conversation and codebase for architectural changes:
   - New/removed components
   - Changed data flows
   - Config changes (read actual config files, not from memory)
   - Dependency version changes
3. Update ARCHITECTURE.md (merge, preserve existing valid content)
4. Git commit: `docs: architecture update [YYYY-MM-DD HH:MM]`
5. Summary of architectural changes captured
