# Init Mode Rubric — CLAUDE.md Audit

## The Context Hierarchy Test

For each section, ask: **"What goes wrong if this content only loads when a skill triggers?"**

If you can't name a specific error or bad behavior that would result from the content being absent in a no-skill session, it belongs in a skill — not in CLAUDE.md.

Content belongs at the right level of a four-level hierarchy:

| Level | Loaded | Purpose |
|-------|--------|---------|
| CLAUDE.md | Always | Non-discoverable rules needed every session |
| Skills | On trigger | Domain workflows, only when relevant |
| References | On demand | Detailed material loaded by skills |
| Discoverable | Never stored | Exists in code, configs, file structure |

**The default classification is "move to skill", not "keep."** Every section starts as a candidate for relocation. You must justify why it stays in CLAUDE.md — not why it leaves.

**Common failure:** classifying content as "keep" because it seems important. Important ≠ needed every session. A professor's craft knowledge is important — but a session fixing MCP config doesn't need it.

## Pre-Classification: Skill Inventory

Before classifying any CLAUDE.md content, inventory the project's skills:

1. Read `.claude/skills/*/SKILL.md` frontmatter (name + description)
2. For each skill, note what domain/workflow it covers
3. During classification, use this inventory to identify CLAUDE.md content that belongs to a specific skill

This step is critical. Without it, the audit defaults to "keep" for content that looks important but only matters when a specific skill is active.

## Four-Bucket Classification

Walk each section of CLAUDE.md through these buckets. **Start with "Move to skill" — it catches the most misplaced content.**

### 1. Move to Skill — Conditional Context

Content only relevant when a specific skill or workflow is active. This is the most common misplacement — CLAUDE.md accumulates content that should live in the skill it supports.

For each section, ask: **"What goes wrong if this content only loads when [skill] triggers?"** If you can't name a concrete consequence, it belongs in the skill.

Patterns to catch:
- Persona details, character descriptions, behavioral rules specific to a roleplay or creative skill
- "Read X first" directives where the file is only useful for a specific skill's workflow (e.g., story context only matters for a writing professor skill, not for infrastructure work)
- Domain-specific guidelines that map to a single skill (magical realism rules → professor skill, Docker safety → docker skill)
- Goals or purpose statements that describe what a skill does, not what the project is

**"Read X first" refinement:** Priority directives stay in CLAUDE.md only if the file is needed by ALL sessions. If the file is only useful when a specific skill is active, the directive moves to that skill.

### 2. Delete — Discoverable from Code

Content that Claude can find by reading the codebase. Remove it.

Heuristics:
- Package.json scripts, Makefile targets, CLI help output
- Tech stack (detectable from dependencies, imports, file extensions)
- File structure and directory layout (glob/grep finds these)
- Architecture patterns (visible from code organization)
- Build commands documented in standard config files

**Discoverability rule:** If it exists as a file in the project, it doesn't belong in CLAUDE.md.

### 3. Hook Candidate — Enforceable Rules

"Don't use X" / "Always use Y instead" rules that could be enforced deterministically by a pre-commit hook, linter, or shell alias.

Action: **Flag but leave in place.** Note in the report as a candidate for future hook conversion. Removing these before a hook exists creates a gap.

### 4. Keep — Essential Non-Discoverable

Truly non-discoverable content needed by EVERY session — infrastructure, coding, and skill-driven alike.

Heuristics:
- Project conventions not captured in config files that affect all work
- Document authority hierarchy (which file is authoritative when sources conflict)
- Safety rules where the consequence of violation is severe and irreversible
- Team decisions that override common defaults

**Test:** What goes wrong if this content is absent and no skills fire? Name the specific error. If you can't, it doesn't belong here.

## Audit Workflow

1. **Skill inventory:** Read `.claude/skills/*/SKILL.md` frontmatter to understand what skills exist
2. **Baseline:** Run `estimate-tokens.sh` on CLAUDE.md
3. **Classify each section** through the four buckets (start with "Move to skill"):
   - For "Move to skill": identify the target skill from the inventory
   - For "Delete": probe the codebase (glob, grep) to confirm discoverability
   - For "Hook candidate": check if a hook/linter already enforces this
   - For "Keep": verify it's needed by ALL sessions, not just skill-driven ones
4. Present the audit report per `references/report-template.md`
5. Wait for operator confirmation before applying any changes
6. Apply confirmed changes (delete sections, move content to skills)
7. Run `estimate-tokens.sh` again and report savings
