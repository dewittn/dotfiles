# Context Audit — WFID Manuscript V2

**Date:** 2026-03-14
**Project:** `/Users/dewittn/Programing/dewittn/Pensives/wfid-manuscript-v2`
**Status:** Audit complete, no changes applied. Saved here because the `context-audit` skill needs further development.

---

## Init Mode — CLAUDE.md Audit

**Target:** `CLAUDE.md`

### Token Estimate

| Metric | Words | ~Tokens |
|--------|-------|---------|
| Before | 534 | 694 |
| After  | 534 | 694 |
| Saved  | 0 | 0 |

### Findings

| # | Section | Classification | Rationale |
|---|---------|---------------|-----------|
| 1 | Header + intro (L1-3) | **Keep** | Project identity. Not discoverable from code. |
| 2 | CRITICAL: Start Here (L5-13) | **Keep** | Priority directives — rubric exemption for "Read X first" patterns. |
| 3 | Purpose & Goals (L15-28) | **Keep** | Current phase + goals are non-discoverable project intent. Novel premise (L19) overlaps with condensed context but is 1 sentence providing immediate framing. |
| 4 | Document Authority Notes (L29-34) | **Keep** | Authority hierarchy is a non-discoverable convention. Critical for resolving conflicts between docs. |
| 5 | Updating This Pensieve (L36-46) | **Keep** | Workflow convention for when to update insights. Not captured elsewhere. |
| 6 | Agent Behavior quick ref (L49-55) | **Minor redundancy** | 3 bullet points summarize working-with-nelson.md, which is mandated in "Start Here" and will always be loaded. ~30 tokens. |
| 7 | WFID-Specific Guidelines (L57-64) | **Keep** | Non-discoverable behavioral rules specific to this project. The `Chats/` avoidance rule (L64) is particularly important. |

### Hook Candidates

None. All rules are behavioral guidance for an AI agent, not enforceable by linters or hooks.

### Verdict

All sections kept. CLAUDE.md is already lean at 694 tokens. The 3-item quick reference (L51-55) has minor redundancy with working-with-nelson.md, but at ~30 tokens the savings don't justify the churn. **Clean bill of health.**

---

## Skill Mode — SKILL.md Audit

**Target:** Project skills (`.claude/skills/`)

### Token Estimate (all project skills)

| Skill | Words | ~Tokens | Triage |
|-------|-------|---------|--------|
| inbox-triage | 131 | 170 | Lean — skip |
| note-that | 297 | 386 | Lean — quick review |
| bootstrap | 471 | 612 | Medium — quick review |
| mfa-professor | 2250 | 2925 | Verbose — deep audit |
| **Total** | **3149** | **4093** | |

---

### note-that (386 tokens) — Quick Review

Clean. Examples in L17-21 are useful reference, not bloat. Rules section is concise. No action needed.

### bootstrap (612 tokens) — Quick Review

| # | Section | Category | Rationale |
|---|---------|----------|-----------|
| 1 | "Set up all derived data..." (L7-12) | Commentary | Restates description, but adds specificity ("when to run" bullets). Borderline. |
| 2 | "What Gets Created" table (L96-108) | File discovery | Directory structure in table form. BUT for a bootstrap script, knowing what gets created IS the point. |
| 3 | "After Bootstrap" (L110-112) | Dead weight | Discoverable from `.mcp.json`. ~20 tokens. |

**Verdict:** Minor trim opportunity in "After Bootstrap." Not worth acting on at 612 tokens.

---

### mfa-professor (2925 tokens) — Deep Audit

**Note:** Persona/creative exception applies. Voice, character traits, atmospheric details, and teaching philosophy are all signal.

| # | Section | Category | Rationale |
|---|---------|----------|-----------|
| 1 | L8 "An MFA creative writing professor..." | **Commentary** | Restates frontmatter description. ~15 tokens. |
| 2 | L10-12 Invocation trigger phrases | **Redundancy** | Trigger phrases already in frontmatter description. Extension prompt example (L14-17) IS signal. ~20 tokens. |
| 3 | L20-42 The Project Binder | **Keep (creative exception)** | Directory mapping dressed in persona metaphor. The behavioral instructions (L37-42) are signal. The persona framing tells Claude HOW to use these files. |
| 4 | L44-65 Session Notes | **Keep** | Non-discoverable workflow for session continuity. All signal. |
| 5 | L67-76 Consulting development notes | **Keep** | Procedural instructions for `search_notes` usage. |
| 6 | L78-84 The Novel | **Redundancy** | Duplicates condensed story context, which is loaded at startup per CLAUDE.md "Start Here." When professor fires, this is already in context. ~80 tokens. |
| 7 | L86-99 The Protagonist (NR) | **Potential redundancy** | Detailed character description — similar content exists in Characters/ files and condensed story context. NOT professor persona, so creative exception doesn't directly apply. BUT the craft-focused framing ("liminal space," "not passive in his displacement") adds professor perspective. ~120 tokens. |
| 8 | L100-112 The Ghost | **Potential redundancy** | Same as above. Ghost description overlaps with `Characters/Description of My Ghost.md` and condensed context. The behavioral/thematic reading (conscience, fear of abandonment) adds professor perspective. ~100 tokens. |
| 9 | L114-165 Professor Character | **Keep (creative exception)** | Pure persona signal — literary positions, MR definition, craft techniques, teaching philosophy, feedback interpretation. Every line affects behavior. |
| 10 | L166-172 The Office | **Keep (creative exception)** | Atmospheric grounding for the roleplay. |
| 11 | L174-194 Stage Directions | **Keep** | Non-discoverable behavioral rules with good/bad examples. |
| 12 | L196-206 Writing Prompts | **Keep** | Boundary rule. |
| 13 | L210-226 Boundaries | **Partial redundancy** | "Don't rewrite student text" appears in L148 AND L221-222. "Don't include writing prompts" appears in L198 AND L224. ~30 tokens internal duplication. |

### Proposed Changes (not applied)

**Delete:**
- L8 — Commentary line restating frontmatter. ~15 tokens.
- L10-12 — Trigger phrases duplicated from frontmatter. Keep extension prompt example at L14. ~20 tokens.

**Move / Replace:**
- L78-84 "The Novel" — Replace with pointer to condensed story context (already loaded at startup). ~60 tokens saved.
- L86-112 Character descriptions — Optional: move to `references/characters.md`. Largest savings (~220 tokens) but adds a file-read step. Recommend discussing with operator.

**Consolidate:**
- L210-226 Boundaries — Remove 3 items that duplicate earlier rules (rewrite, prompts, break character). ~30 tokens.

### Savings Scenarios (mfa-professor)

| Scenario | Tokens Saved | % of Original |
|----------|-------------|---------------|
| Conservative (delete + consolidate only) | ~65 | 2.2% |
| Moderate (+ replace Novel section) | ~125 | 4.3% |
| Aggressive (+ move characters to refs) | ~345 | 11.8% |

---

## Overall Summary

**CLAUDE.md:** Already lean at 694 tokens. No changes needed.

**Skills:** mfa-professor is the only skill with meaningful optimization potential. Conservative and moderate changes are safe wins. Aggressive option (moving character descriptions to references/) is a tradeoff between token savings and inline convenience.

**Recommendation:** Apply moderate changes to mfa-professor when ready.
