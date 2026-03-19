---
name: sync-arch
description: "Update ARCHITECTURE.md with current system structure. Use after adding/removing components, changing configs, updating dependencies, modifying data flows, or when the user asks 'how does this work', 'what's the architecture', 'document the design'. Also trigger when creating new projects, onboarding documentation, or after significant refactoring. Read actual config files and code — don't rely on conversation memory alone."
argument-hint: "[path] [--push] [--project name]"
disable-model-invocation: true
---

# Update Architecture Documentation

Update only `docs/ARCHITECTURE.md` with current system structure. Unlike conversation memory, this file persists across sessions and compaction — it's the authoritative source for "how does this system work."

## Arguments

- No args → write to `<git-root>/docs/ARCHITECTURE.md`
- Path → write to `<path>/docs/ARCHITECTURE.md`
- `--push` → git push after commit
- `--project <name>` → scope under `docs/<name>/ARCHITECTURE.md`

## What goes in ARCHITECTURE.md

Architecture docs should let someone unfamiliar with the project understand the system structure in under 5 minutes. Be concrete — file paths, port numbers, config values, version strings.

### Overview
One paragraph describing what the system does and its high-level design.

### Component table
Every major component with its location, purpose, and status:
```markdown
| Component | Location | Purpose | Status |
|-----------|----------|---------|--------|
| RSE Firmware | src/rse/ | Hardware Root of Trust (Cortex-M55) | Built |
| SCP Firmware | src/SCP-firmware/ | Power/clock management (Cortex-M85) | Built |
```

### Data/control flow
How components interact. Describe the flow in text, or better yet, generate an SVG diagram (use `/svg-diagram` if available).

### Key configuration
Critical config files with their important settings and why they matter:
```markdown
**build-scripts/config/tc3.config**: Platform-specific build options
- `SCP_PLATFORM_VARIANT=MPMM` — enables Maximum Power Point Management
- `TC_GPU_VARIANT_ID=tkrx` — selects Mali-G725 (Krake) GPU model
```

### External dependencies
Name, version, and why each is needed. Pin versions — "latest" is meaningless after compaction.

## Execution

1. Resolve target → `<root>/docs/ARCHITECTURE.md`
2. Read existing ARCHITECTURE.md (create from template if missing)
3. Scan for architectural changes:
   - New/removed components (check git log, conversation context)
   - Changed data flows or integrations
   - Config file changes (read the actual files, don't guess)
   - Dependency version changes
4. Update with specifics — component names, file paths, port numbers, config values, version strings
5. Git add → commit with rationale → push if `--push`
6. Summary of what changed architecturally
