# Context Audit Report — mode: init

**Target:** `CLAUDE.md` (WFID Pensieve)
**Date:** 2026-03-14

## Token Estimate

| Metric | Words | ~Tokens |
|--------|-------|---------|
| Before | 534 | ~694 |
| After  | (pending) | (pending) |
| Saved  | (pending) | (pending) |

## Skill Inventory

| Skill | Domain |
|-------|--------|
| bootstrap | Fresh machine setup, rebuild derived data |
| inbox-triage | Triage inbox/ files, categorization, MOC updates |
| mfa-professor | MFA craft feedback, magical realism, roleplay persona |
| note-that | Save professor feedback as a note |

## Findings

| # | Section | Classification | Rationale |
|---|---------|---------------|-----------|
| 1 | Title / Intro | Move to skill | Describes what a "Pensieve" is and names the project. A no-skill session (e.g., fixing a script, updating config) doesn't need this framing. Any skill that needs it can state it in its own SKILL.md. No concrete error results from its absence in a generic session. |
| 2 | CRITICAL: Start Here (all 4 directives) | Move to skill | All four "read first" files (`working-with-nelson.md`, `key-insights-wfid.md`, `WFID Story Context (Condensed).md`, `MOC WFID.md`) are only needed when doing craft/story work — which maps to the `mfa-professor` skill. A session fixing bootstrap scripts or triaging inbox files does not need story context loaded. The rubric explicitly says: "'Read X first' directives stay in CLAUDE.md only if the file is needed by ALL sessions." These files are not needed by all sessions. Target skill: **mfa-professor**. |
| 3 | Purpose & Goals | Move to skill | Describes the novel's premise, current phase ("Manuscript V2"), and goals (craft feedback, audit trail, cross-session knowledge). This is project vision that orients a creative/craft session. A session running `bootstrap` or `inbox-triage` doesn't need to know the novel's logline or that the current phase is "Manuscript V2." No error results from its absence in a non-craft session. Target skill: **mfa-professor** (or a shared project preamble if multiple skills need it). |
| 4 | Document Authority Notes | Keep | This section establishes which document is authoritative when sources conflict (Story Summary > Beat Sheet, MOC reflects actual files, inbox items may contain freshest thinking). This is a non-discoverable hierarchy that affects ANY session that touches content files — including `inbox-triage` (which moves files and updates the MOC) and `mfa-professor` (which references story structure). **Error if absent:** an agent triaging inbox items or reorganizing files could overwrite the canonical Story Summary with stale content from another document, or fail to update the MOC, or ignore inbox items that contain the latest thinking. This affects multiple workflows, not just one skill. |
| 5 | Updating This Pensieve (when to update key-insights) | Move to skill | Rules for when to add entries to `key-insights-wfid.md` are specific to craft/discovery sessions. A bootstrap or inbox-triage session doesn't need to know when to propose insight updates. Target skill: **mfa-professor**. |
| 6 | Agent Behavior Guidelines (quick reference) | Move to skill | "Be direct, evidence-based," "Update insights proactively," "Use Nelson's frameworks" — these are behavioral guidelines for the professor persona. The `mfa-professor` skill already defines this persona. A non-professor session doesn't need these behavioral norms. Target skill: **mfa-professor**. |
| 7 | WFID-Specific Guidelines | Move to skill | Every bullet maps to the `mfa-professor` skill domain: don't rewrite prose, use the document inventory, reference the beat sheet, respect magical realism rules, the ghost is central, don't read `Chats/` files. A session running `bootstrap` or `inbox-triage` has no use for magical realism rules or prose rewriting prohibitions. Target skill: **mfa-professor**. |

## Hook Candidates

No hook candidates identified. The rules in this file are domain-knowledge guidelines, not enforceable "don't use X / always use Y" patterns suitable for pre-commit hooks or linters.

## Proposed Changes

### Delete
- (none)

### Move

- [ ] **Section 1 (Title / Intro):** Move to `mfa-professor` SKILL.md as project context preamble. The CLAUDE.md title line can be replaced with a single-line project identifier if desired.
- [ ] **Section 2 (CRITICAL: Start Here):** Move all four "read first" directives to `mfa-professor` SKILL.md. These files are only needed for craft/story sessions. The `inbox-triage` skill can independently reference `MOC WFID.md` if it needs the document index.
- [ ] **Section 3 (Purpose & Goals):** Move to `mfa-professor` SKILL.md. Novel premise, current phase, and craft goals belong in the skill that does craft work.
- [ ] **Section 5 (Updating This Pensieve):** Move to `mfa-professor` SKILL.md. Insight update rules are part of the professor's workflow.
- [ ] **Section 6 (Agent Behavior Guidelines):** Move to `mfa-professor` SKILL.md. Behavioral norms for craft sessions.
- [ ] **Section 7 (WFID-Specific Guidelines):** Move to `mfa-professor` SKILL.md. All bullets are craft-session rules.

### Keep (no action)

- [x] **Section 4 (Document Authority Notes):** Stays in CLAUDE.md. Establishes which document is canonical when sources conflict. Needed by multiple workflows (inbox-triage, mfa-professor, any file reorganization). Error if absent: agent could overwrite authoritative Story Summary with stale content, fail to maintain MOC, or skip inbox triage.

## Savings Summary

Estimated context reduction: ~580 tokens (~84% of original)

Sections moved to skill account for approximately 440 of 534 words. The remaining ~94 words (Document Authority Notes plus a minimal project identifier header) would stay in CLAUDE.md.

- Before: 534 words / ~694 tokens
- After (estimated): ~94 words / ~122 tokens
- Saved (estimated): ~440 words / ~572 tokens
