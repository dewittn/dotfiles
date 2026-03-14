---
name: context-audit
description: >
  Audit project context files for signal-to-noise ratio. Two modes: init (audit
  CLAUDE.md — classify content as delete, hook candidate, move to skill, or keep)
  and skill (audit SKILL.md files — flag commentary, file discovery, inline bloat,
  redundancy, dead weight). Invoke via /context-audit init, /context-audit skill,
  or /context-audit all. Does not touch global ~/.claude/CLAUDE.md.
argument-hint: "[init|skill|all]"
---

# Context Audit

**Guiding principle:** Context control — all signal, less noise. Content belongs at the right level of a four-level hierarchy: CLAUDE.md (always loaded) → skills (on trigger) → references (on demand) → discoverable (never stored). Every token in always-loaded files has a cost.

## Mode Dispatch

Parse argument from `$ARGUMENTS`:

| Argument | Action |
|----------|--------|
| `init` | Audit the project's CLAUDE.md only |
| `skill` | Audit SKILL.md files only |
| `all` | Run init, then skill sequentially |
| *(empty)* | Ask: "Which mode? init, skill, or all?" |

**Scope guard:** Never modify `~/.claude/CLAUDE.md` (global config). Only audit CLAUDE.md files within the current project.

## Init Mode — CLAUDE.md Audit

Read `references/init-rubric.md` for the four-bucket classification rubric.

Workflow:
1. **Skill inventory first** — read `.claude/skills/*/SKILL.md` frontmatter to understand what skills exist and what domains they cover
2. Read the project's CLAUDE.md
3. Run `scripts/estimate-tokens.sh` on the file
4. Classify each section using the four-bucket rubric — **start with "move to skill"**, then delete, hook candidate, keep
5. For "move to skill" — match content against the skill inventory. Ask: "Does an infrastructure session need this?"
6. Present report per `references/report-template.md`
7. Wait for operator confirmation before applying changes
8. Apply changes, re-run token estimate, report savings

## Skill Mode — SKILL.md Audit

Read `references/skill-rubric.md` for the five-category noise checklist.

Workflow:
1. Run `scripts/estimate-tokens.sh` on all skills (or a specific skill if specified)
2. Triage by size: skip lean (<50 lines), quick-review medium, deep-audit verbose (150+)
3. For each skill meeting threshold, classify content through five noise categories
4. Respect the persona/creative skill exception — don't flag voice/character details
5. Present report per `references/report-template.md`
6. Wait for operator confirmation before applying changes
7. Apply changes (move to references/, delete, consolidate), re-run token estimate, report savings

## Shared Rules

- Always run `scripts/estimate-tokens.sh` before and after to quantify impact
- Always present the report and wait for operator confirmation before modifying files
- Group changes by action type (delete, move, keep) in the report
- One report per target file — don't combine multiple skills into a single report
