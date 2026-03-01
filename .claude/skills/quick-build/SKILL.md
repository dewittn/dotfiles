---
name: quick-build
description: >
  Chain the full planning pipeline (feature-plan → pre-plan → build → review-code)
  into a single continuous flow for small features. Use when a feature is simple
  enough to plan and build in one session. Invoked explicitly with /quick-build.
  If feature planning takes >10 minutes, bails out and tells the operator to run
  stages separately. Do NOT auto-trigger — operator explicitly invokes /quick-build.
---

# Quick Build

Chain the full planning pipeline into a single continuous flow for small features. Each phase delegates to its own skill — debug at the individual skill level, not here.

## Phase 1: Feature Plan

Read and execute `.claude/skills/feature-plan/SKILL.md` — run all 5 phases (inbox check, capture, clarify, refine, log duration). The skill has a `references/` directory with the feature doc template; follow its instructions for loading it.

Pass the operator's freeform description as the seed idea. The conversational flow is identical to invoking `/feature-plan` directly.

## Transition: Duration Check

After feature planning completes and `log-duration.sh` prints its output, check the reported duration.

Parse the `MINUTES` value from the script output (`Duration: ~X min`). If the feature planning took **more than 10 minutes**, stop and tell the operator:

> Feature planning took ~X minutes — this feature is complex enough to benefit from running the stages separately. Your feature doc is saved. Next steps:
> 1. `/pre-plan` to enrich the feature doc
> 2. `/build` to implement

Do not proceed to Phase 2.

If **10 minutes or less**, continue immediately.

## Phase 2: Pre-Plan

Read and execute `.claude/skills/pre-plan/SKILL.md` — run all stages (locate feature doc, section-by-section review, completion with branch creation). The skill has a `references/` directory with visual format examples; follow its instructions for loading them.

The feature doc just created in Phase 1 is the input. Pre-plan's section-by-section review still pauses for operator confirmation at each section — quick-build does not skip these checkpoints.

## Phase 3: Build

Read and execute `.claude/skills/build/SKILL.md` in **`main` mode** (single agent, sequential execution). The skill has a `references/` directory with plan structure and mode details; follow its instructions for loading them.

Hardcode mode to `main` — do not offer mode selection. The feature number is known from Phase 1.

Build's Step 6 runs `/review-code` as the final quality gate. Build's Step 7 handles completion (status update, feature doc move, commit, PR creation). No additional wiring needed.

## What the Operator Sees

1. Feature planning starts — same conversational flow as `/feature-plan`
2. Duration check — if >10 min, stops with bail-out message (feature doc preserved)
3. Pre-plan starts — same section-by-section review with confirmation pauses
4. Build starts — plan mode, operator alignment, sequential execution
5. Review + PR — build handles `/review-code` and PR creation

## Configuration

Edit this file to change the 10-minute threshold or adjust transition behavior. Each phase uses its own skill — the orchestration is just sequencing.
