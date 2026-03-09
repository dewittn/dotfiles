# Context Gathering

## Initial Context Sources (Stage 0)

Read before starting section review:

- **Style guide**: `~/Programing/dewittn/agentic-docs/coding/style-guide.md`
- **Project plan**: `~/Programing/dewittn/agentic-docs/projects/<name>/` for conventions
- **Domain docs**: `~/Programing/dewittn/agentic-docs/` based on project type
- **Project CLAUDE.md**: project-specific conventions
- **Planning guides**: `~/Programing/dewittn/agentic-docs/planning/` — read relevant guides based on project type

Derive `<name>` from the current working directory's folder name.

**Exclude**: `~/Programing/dewittn/agentic-docs/projects/<name>/scenarios/`

## Per-Section Agents

Run all three in parallel for each section. Each returns a focused summary, not raw file contents.

**History search** (via history-search agent):
- Recent modification history and churn on affected files
- Reverts or bug fixes (code may be that way for a reason)
- Files commonly co-modified (hidden dependencies)

**Codebase exploration** (via Explore agents):
- How similar features are currently implemented
- Naming conventions and patterns in the affected area
- Configuration patterns (data-driven vs hardcoded)

**Sibling feature scanning**:
- Run `scripts/list-feature-metadata.sh` on the features directory to get all feature metadata
- Match the current section's concerns against `systems` tags from sibling docs
- Read the Architecture sections from matching siblings with `[reviewed]` status
- Use sibling decisions as context (not constraints) — they inform, they don't bind
