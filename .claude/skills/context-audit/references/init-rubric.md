# Init Mode Rubric — CLAUDE.md Audit

## The Context Hierarchy Test

Ask of every line: **"Does every session in this project need this?"**

Content belongs at the right level of a four-level hierarchy:

| Level | Loaded | Purpose |
|-------|--------|---------|
| CLAUDE.md | Always | Non-discoverable rules needed every session |
| Skills | On trigger | Domain workflows, only when relevant |
| References | On demand | Detailed material loaded by skills |
| Discoverable | Never stored | Exists in code, configs, file structure |

## Four-Bucket Classification

Walk each section of CLAUDE.md through these buckets:

### 1. Delete — Discoverable from Code

Content that Claude can find by reading the codebase. Remove it.

Heuristics:
- Package.json scripts, Makefile targets, CLI help output
- Tech stack (detectable from dependencies, imports, file extensions)
- File structure and directory layout (glob/grep finds these)
- Architecture patterns (visible from code organization)
- Build commands documented in standard config files

**Discoverability rule:** If it exists as a file, it doesn't belong in CLAUDE.md.

**Exception:** "Read X before proceeding" directives encode *priority*, not existence — these stay.

### 2. Hook Candidate — Enforceable Rules

"Don't use X" / "Always use Y instead" rules that could be enforced deterministically by a pre-commit hook, linter, or shell alias.

Action: **Flag but leave in place.** Note in the report as a candidate for future hook conversion. Removing these before a hook exists creates a gap.

Examples:
- "Never use `var`, always use `const`/`let`" → ESLint rule
- "Run prettier before committing" → pre-commit hook
- "Use snake_case for database columns" → linter or naming convention check

### 3. Move to Skill — Conditional Context

Content only relevant when a specific skill or workflow is active. Move it to the appropriate skill's references/ or SKILL.md.

Heuristics:
- Docker-specific instructions → docker skill
- Deployment procedures → deploy skill
- Testing patterns → tdd skill references
- Content that starts with "When doing X..." where X maps to a skill

### 4. Keep — Essential Non-Discoverable

Truly non-discoverable content needed every session that can't be enforced deterministically.

Heuristics:
- Project conventions not captured in config files
- Team decisions that override common defaults
- Integration points between tools that aren't documented elsewhere
- Safety rules where the consequence of violation is severe and irreversible

## Audit Workflow

1. Read the project's CLAUDE.md
2. Run `estimate-tokens.sh` on CLAUDE.md to get baseline token count
3. Walk each section through the four-bucket classification:
   - For "Delete" candidates: probe the codebase (glob, grep, read configs) to confirm discoverability
   - For "Hook candidate" items: check if a hook/linter already enforces this
   - For "Move to skill" items: identify the target skill
   - For "Keep" items: verify non-discoverability
4. Present the audit report per `references/report-template.md`
5. Wait for operator confirmation before applying any changes
6. Apply confirmed changes (delete sections, move content to skills)
7. Run `estimate-tokens.sh` again and report savings
