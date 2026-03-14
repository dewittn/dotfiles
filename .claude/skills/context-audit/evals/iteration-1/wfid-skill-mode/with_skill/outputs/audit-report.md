# Context Audit Report — mode: skill

**Target:** `.claude/skills/context-audit/evals/fixtures/wfid/mfa-professor-SKILL.md`
**Date:** 2026-03-14

## Token Estimate

| Metric | Words | ~Tokens |
|--------|-------|---------|
| Before | 2250 | 2925 |
| After  | ~2115 | ~2750 |
| Saved  | ~135 | ~175 |

## Triage

- **Lines:** 226
- **Category:** Verbose (150+) — deep audit

## Persona Exception Applied

This is a persona/creative skill (MFA professor roleplay). Per the rubric, persona traits, atmospheric details, voice characteristics, character context, and teaching philosophy are **signal, not noise**. The following sections are protected by this exception:

- The Project Binder (persona framing for file access)
- The Novel (project synopsis)
- Characters (protagonist, ghost)
- Character (professor persona, literary positions)
- Magical Realism Definition and Craft Techniques (professor's domain expertise)
- Teaching Philosophy and On Interpreting Feedback (behavioral persona)
- Craft Knowledge (reference framework)
- The Office (atmospheric detail)
- Stage Directions (output format tied to persona)
- Writing Prompts (behavioral constraint)

## Findings

| # | Section / Lines | Classification | Rationale |
|---|----------------|---------------|-----------|
| 1 | `# Professor Claude` heading + description (L7-8) | Commentary | "An MFA creative writing professor for feedback sessions on 'Waking From Innocent Dreams'" restates the frontmatter description almost verbatim. The description already triggered the skill. |
| 2 | `## Invocation` trigger phrases (L10-12) | Commentary / Redundancy | "Trigger phrases: 'I'd like to work with Professor Claude on...' or 'Professor Claude...'" repeats trigger phrases already present in the frontmatter `description` field word-for-word. |
| 3 | `## Invocation` extension prompt example (L14-18) | Keep | The extension prompt concept and example are procedural — they tell the skill how to handle the scene setup that follows the trigger. This is signal. |
| 4 | `## The Project Binder` (L20-42) | Keep | Persona-framed file access procedure. The binder metaphor maps to real project structure (tabs = directories). Behavioral instructions ("flip to the tab, read what's there") are actionable. The "Skip docs/ and audit-log/" constraint is a real guard rail. |
| 5 | `## Session Notes` (L44-76) | Keep | Procedural instructions for session continuity using `.session-memory/` snapshots, `search_professor_feedback`, `search_notes`, and `search_sessions`. Concrete tool usage wrapped in persona framing. All actionable. |
| 6 | `## The Novel` (L78-84) | Keep | Essential project context for informed feedback. Genre definition, historical context. Persona exception applies. |
| 7 | `## Characters` — Protagonist + Ghost (L86-112) | Keep | Detailed character portraits directly inform feedback quality. The professor needs to know NR's psychology and the ghost's symbolic role to give meaningful craft feedback. Persona exception applies. |
| 8 | `## Character` — Professor persona (L114-165) | Keep | Professor's identity, literary positions, magical realism definition, craft techniques, teaching philosophy, feedback interpretation approach, craft knowledge references. All persona signal — this defines how the professor behaves. |
| 9 | `### The Office` (L167-173) | Keep | Atmospheric detail that grounds the roleplay. Persona exception applies. |
| 10 | `## Stage Directions` (L175-194) | Keep | Output format instructions with good/bad examples. Directly shapes response style. |
| 11 | `## Writing Prompts` (L196-207) | Keep | Behavioral constraint on when prompts are appropriate. Actionable. |
| 12 | `## Boundaries` (L209-226) | Redundancy | This section recaps constraints already established in earlier sections. Specific overlaps: "Provide direct, constructive feedback" and "Point out what's working" restate Teaching Philosophy. "Use stage directions sparingly" restates Stage Directions. "Rewrite the student's text" / "Generate prose" restates Teaching Philosophy + frontmatter ("Does NOT rewrite student text"). "Provide only praise without actionable feedback" restates Teaching Philosophy. "Include writing prompts unless stuck" restates Writing Prompts section. Only two items are unique: "Ask clarifying questions about intent" and "Break character to explain the roleplay." |

## Proposed Changes

### Delete

- [ ] **Lines 7-8:** Remove the one-line description under the `# Professor Claude` heading. The frontmatter description covers this. The heading alone is sufficient.
- [ ] **Lines 10-12:** Remove the `## Invocation` heading and trigger phrase line. These duplicate the frontmatter. Keep only the extension prompt material (lines 14-18), retitled or folded into the heading section.

### Consolidate

- [ ] **Lines 209-226 (`## Boundaries`):** Delete the section. Absorb the two unique constraints into existing sections:
  - "Ask clarifying questions about intent" — add to Teaching Philosophy
  - "Break character to explain the roleplay" — add to Stage Directions as a "don't"

### Keep (no action)

- [ ] The Project Binder (L20-42) — persona-framed file access, all actionable
- [ ] Session Notes (L44-76) — procedural tool usage for continuity
- [ ] The Novel (L78-84) — essential project context
- [ ] Characters (L86-112) — character knowledge for feedback quality
- [ ] Character / Professor persona (L114-165) — persona definition, teaching philosophy, craft expertise
- [ ] The Office (L167-173) — atmospheric grounding
- [ ] Stage Directions (L175-194) — output format instructions
- [ ] Writing Prompts (L196-207) — behavioral constraint
- [ ] Extension prompt example (L14-18) — procedural signal

## Savings Summary

Estimated context reduction: ~175 tokens (6% of original)

**Assessment:** This is a well-constructed persona skill. The vast majority of its content is signal -- character details, teaching philosophy, craft knowledge, and procedural instructions all directly shape output quality. The noise is limited to three areas: a restated description line, duplicated trigger phrases, and a summary Boundaries section that recaps constraints already established in dedicated sections earlier in the file. The savings are modest because the skill is already well-organized with minimal fat.
