---
name: feature-plan
description: >
  Walk through a feature doc section by section for operator alignment, producing an enriched
  feature doc that a fresh /feature-build session can execute from. Runs BEFORE /feature-build, not during it.
  Every feature MUST go through this process before building — no exceptions.
  Triggers: auto-trigger when discussing implementing a feature that has a feature doc,
  explicit /feature-plan invocation, or when the user describes work requiring multiple files
  or architectural decisions. Also suggest /feature-define first if the user has a loose idea
  without a feature doc.
---

# Feature Plan

Walk through the feature doc section by section, producing an enriched feature doc that a fresh `/feature-build` session can execute from. Do not begin implementation without completing all stages.

## Stage 0: Locate Feature Doc

Check `~/Programing/dewittn/agentic-docs/projects/<name>/features/` for a feature doc (`NNN-*.md`), where `<name>` is derived from the current working directory's folder name.

- **If a feature doc exists**: Read it. Check frontmatter `status` — see [references/status-workflow.md](references/status-workflow.md) for the state machine, resumption logic, and heading tag format.
- **If no feature doc exists**: If the user has a loose or multi-part idea, suggest `/feature-define` first. Not a hard gate — proceed directly if the user prefers.

Read context sources listed in [references/context-gathering.md](references/context-gathering.md) (project plan, domain docs, CLAUDE.md, style guide).

## Stage 1: Section-by-Section Review

For each section in the doc:

1. **Read the section** — absorb what the feature spec asks for
2. **Gather targeted context** — run agents in parallel per [references/context-gathering.md](references/context-gathering.md). Targeted investigation, not whole-codebase sweeps.
3. **Present interpretation** — "Given this feature spec and this codebase, here's what I'd build." Use tables and visuals per [references/table-and-visual-formats.md](references/table-and-visual-formats.md). Reserve narrative for rationale, tradeoffs, and open questions.
4. **Pause for operator review** — confirm or redirect. Do not proceed until the operator confirms.
5. **Update the feature doc** — After operator confirms:
   - Mark heading `[reviewed]` (replace `[pending]` or `[in-review]`)
   - Enrich with two parts:
     1. **Codebase findings** (factual): affected files, existing patterns, current state, sibling feature context
     2. **Decision record** (rationale, optional): what was chosen, why, what was ruled out. Include prior sibling decisions when relevant.
   - Update `last-updated` in frontmatter (via `date +%Y-%m-%d`)
   - Mark next section `[in-review]`

### Rules

- Section review is mandatory. No skipping, no batching multiple sections.
- The pause between sections is mandatory. Each section gets confirmed before moving on.
- History findings are advisory, not blocking. Red flags mean "understand before proceeding."
- Co-modified files are hidden dependencies — if A always changes with B, touch both.

## Final Review

Triggers after all sections reach `[reviewed]`, before Completion. Single pass — not iterative.

1. Read the complete enriched doc (codebase findings, decision records, sibling context)
2. Surface anything the section-by-section view may have missed:
   - Simpler paths the overall picture reveals
   - Cross-cutting concerns spanning multiple sections
   - Patterns from sibling features that suggest a different approach
3. Present findings to the operator. "Nothing to add" is explicitly valid.
4. Operator decides whether to act. Do not loop back to section review.

## Completion

When all sections are reviewed and Final Review is complete:

1. Update frontmatter: `status: planned`, `last-updated` via `date +%Y-%m-%d`
2. Create feature branch: `feature/NNNN-name` (base: `dev` if it exists, `main` otherwise)
3. Push branch: `git push -u origin feature/NNNN-name`

The enriched feature doc is the handoff artifact. A fresh session runs `/feature-build` to implement.

## Integration

This skill handles HOW. The feature doc (from `/feature-define`) defines WHAT and WHY. Use its constraints — don't re-ask answered questions. Respect its implementation order.

Works with: `/feature-define`, `/feature-build`, `/review-code`, tdd, history-search agent, Explore agents, code-styling, style guide, domain docs. See `~/Programing/dewittn/agentic-docs/planning/README.md` for the full workflow.
