# Context Audit — WFID Manuscript V2 (v2 revised)

**Date:** 2026-03-14
**Project:** `/Users/dewittn/Programing/dewittn/Pensives/wfid-manuscript-v2`
**Status:** Revised after operator challenge questions. Changes not yet applied.

---

## Challenge Questions & Corrections

### Q1: "When I open a session to work on infrastructure, do I need the condensed story context loaded? Do I need to know the ghost is central?"

No. My reasoning was "most sessions involve manuscript work" — but the rubric asks "does *every* session need this?" not "do most?" An MCP config fix doesn't need the condensed story context loaded. It doesn't need to know the ghost is central.

### Q2: "Why didn't any CLAUDE.md content get classified as 'move to professor skill' when 5 of the 7 sections are specifically about how to interact with the manuscript?"

I defaulted to "keep" instead of starting with "move to skill." The rubric explicitly warns against this: *"Without [the skill inventory step], the audit defaults to 'keep' for content that looks important but only matters when a specific skill is active."* That's exactly what I did. Looking again at the WFID-Specific Guidelines:

- "Don't rewrite Nelson's prose" — manuscript work only
- "Use the document inventory" — manuscript work only
- "Reference the beat sheet" — manuscript work only
- "Respect the magical realism framework" — manuscript work only
- "The ghost is central" — manuscript work only
- "Don't read Chats/ files" — operational, all agents

5 of 6 bullets belong in the professor skill (or a manuscript-work context), not in always-loaded CLAUDE.md.

### Q3: "The rubric says to start with 'move to skill' — what was your reasoning for keeping the 'read story context first' directive in CLAUDE.md rather than in the professor skill?"

The professor skill already has its own startup sequence (read the snapshot, consult the binder). The story context read directive could live there. For non-professor manuscript questions, the agent can discover the story context through `MOC WFID.md`, which would stay in CLAUDE.md as a navigation aid.

Similarly, `key-insights-wfid.md` is domain-specific — it matters for manuscript work, not for debugging the audit system.

---

## Revised Classification

| # | Section | Original | Revised | Rationale |
|---|---------|----------|---------|-----------|
| 1 | Opening paragraph | Keep | **Keep** | — |
| 2 | Read `working-with-nelson.md` | Keep | **Keep** | Universal communication guidance |
| 3 | Read `key-insights-wfid.md` | Keep | **Move to professor** | Domain-specific, not needed for infra |
| 4 | Read `WFID Story Context` | Keep | **Move to professor** | Only manuscript sessions need this |
| 5 | Read `MOC WFID.md` | Keep | **Keep** | Navigation aid for all sessions |
| 6 | Purpose & Goals | Keep | **Keep** | — |
| 7 | Document Authority Notes | Keep | **Keep** | — |
| 8 | Updating This Pensieve | Keep | **Keep** | — |
| 9 | Agent Behavior (quick ref) | Keep | **Keep** | — |
| 10 | WFID Guidelines (5 of 6) | Keep | **Move to professor** | Manuscript-specific behavioral rules |
| 11 | "Don't read Chats/" | Keep | **Keep** | Operational rule for all agents |
