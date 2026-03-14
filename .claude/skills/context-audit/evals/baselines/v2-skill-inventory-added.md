# Context Audit — WFID Manuscript V2 (v2)

**Date:** 2026-03-14
**Project:** `/Users/dewittn/Programing/dewittn/Pensives/wfid-manuscript-v2`
**Status:** Audit complete. No changes recommended.

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
| 1 | Opening paragraph | Keep | Brief orientation needed by all sessions |
| 2 | CRITICAL: Start Here (4 read directives) | Keep | `working-with-nelson.md` and `key-insights-wfid.md` apply universally; story context and MOC apply to the vast majority of sessions in a manuscript pensieve |
| 3 | Purpose & Goals | Keep | Short, orients all sessions to current phase |
| 4 | Document Authority Notes | Keep | Conflict resolution rules — non-discoverable, prevents wrong-source errors |
| 5 | Updating This Pensieve | Keep | Process rule applicable to all sessions |
| 6 | Agent Behavior Guidelines (quick ref) | Keep | Three brief behavioral constraints for all agents |
| 7 | WFID-Specific Guidelines (6 bullets) | Keep | "Don't rewrite prose" is a safety rule (severe consequence); "Don't read Chats/" is an operational rule for all agents; remaining four are brief and broadly relevant |

### Hook Candidates

| Rule | Current Location | Suggested Hook Type |
|------|-----------------|-------------------|
| Don't read `Chats/` files for session context | WFID-Specific Guidelines | Low priority — could warn on Read/Grep targeting `Chats/`, but nuanced (user may explicitly ask for it) |

### Verdict

All sections kept. CLAUDE.md is already lean at 694 tokens. **Clean bill of health.**

---

## Skill Mode — SKILL.md Audit

**Target:** Project skills (`.claude/skills/`)

### Token Estimate (all project skills)

| Skill | Words | ~Tokens | Triage |
|-------|-------|---------|--------|
| inbox-triage | 131 | 170 | Lean — skip |
| note-that | 297 | 386 | Lean — skip |
| bootstrap | 471 | 612 | Medium — quick review |
| mfa-professor | 2250 | 2925 | Verbose — deep audit |
| **Total** | **3149** | **4093** | |

---

### bootstrap (612 tokens) — Quick Review

Clean. Step-by-step procedure with bash commands, all necessary. The "What Gets Created" table provides non-discoverable information (gitignored status). No commentary, no file discovery noise, no redundancy, no dead weight. No action needed.

---

### mfa-professor (2925 tokens) — Deep Audit

**Note:** Persona/creative exception applies. Voice, character traits, atmospheric details, and teaching philosophy are all signal.

| # | Section | Category | Rationale |
|---|---------|----------|-----------|
| 1 | Opening line "An MFA creative writing professor..." | Commentary (minor) | Restates frontmatter description. One line — not worth removing. |
| 2 | The Project Binder | Persona exception | Atmospheric detail that grounds the professor's behavior in character. Includes the key behavioral instruction to consult files rather than work from memory. |
| 3 | Session Notes (33 lines) | Keep | Procedural instructions for cross-session continuity. Must be immediately available on trigger — moving to references/ would add latency to every session. |
| 4 | The Novel (6 lines) | Persona exception | Tailored professor-perspective summary. Brief enough to keep inline even though the condensed story context exists separately. |
| 5 | Characters — NR + Ghost (28 lines) | Persona exception | Character context essential for informed feedback quality. |
| 6 | Character — the professor (56 lines) | Persona exception | Persona traits, teaching philosophy, craft knowledge, office atmosphere — all directly affect output quality. |
| 7 | Magical Realism Definition + Craft Techniques (24 lines) | Potential redundancy | May overlap with `key-insights-wfid.md`. However, framed as "what the professor teaches" (persona knowledge), not a system rule. Divergence risk low. |
| 8 | Stage Directions | Keep | Behavioral constraint with examples — directly shapes output format. |
| 9 | Writing Prompts | Keep | Behavioral constraint — prevents unwanted output. |
| 10 | Boundaries | Keep | Do/Don't rules constraining professor behavior. |

### Verdict

No changes recommended. The persona/creative exception protects the bulk of the content, and the procedural sections (session notes, search instructions) are essential for cross-session continuity.

---

## Overall Summary

**CLAUDE.md:** Already lean at 694 tokens. No changes needed.

**Skills:** All four skills are appropriately sized for their function. The mfa-professor is the largest at 2,925 tokens, but persona content is signal, not noise.

**Compared to v1 audit:** The v1 audit proposed moderate changes (~125 token savings) to mfa-professor. This v2 audit reconsidered those proposals and found the persona exception applies more broadly — the character descriptions and novel summary serve the professor's perspective, not just information delivery. The savings don't justify the tradeoff.
