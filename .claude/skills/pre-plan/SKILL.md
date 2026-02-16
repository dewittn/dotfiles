---
name: pre-plan
description: Front-load planning decisions before implementation. Use when entering plan mode, discussing how to implement a feature, or when the user describes work that will require multiple files or architectural decisions. Fires BEFORE writing a plan, not after. Also suggest running /feature-plan first if the user is describing a loose idea without a feature doc.
---

# Pre-Plan

Front-load context gathering and design decisions so implementation can run uninterrupted.

**Read first:** `~/.claude/docs/coding/style-guide.md`

## When to Invoke

- Entering plan mode or discussing implementation strategy
- User describes a feature, refactor, or multi-file change
- Any task where you would normally jump straight to planning

Do NOT invoke for single-file fixes, typos, or tasks with explicit step-by-step instructions from the user.

## Stage 0: Check for Feature Doc

Before gathering context, check the project's `docs/` directory for a feature doc (files matching `feature-plan-001-*.md`) that covers the work being planned.

- **If a feature doc exists**: Read it. Use its constraints, inputs/outputs, and implementation order to guide the plan. Skip questions the feature doc already answers.
- **If no feature doc exists**: Assess whether one would help. If the user is describing a loose or multi-part idea rather than a well-defined task, suggest: **"This sounds like it could benefit from `/feature-plan` first to nail down what we're building. Want to do that before we plan the implementation?"** This is not a hard gate — if the user wants to proceed directly, continue to Stage 1.

## Stage 1: Gather Context (Silent)

Before writing any plan, gather information in parallel. Do not output results yet.

### History Search

Run the **history-search** agent on files likely to be affected:

- Recent modification history and churn
- Reverts or bug fixes (code may be that way for a reason)
- Files commonly co-modified (hidden dependencies)
- Warning signs in commit messages

Run history-search on multiple files in parallel using the Task tool.

### Domain Context

Based on the project type, read relevant docs from `~/.claude/docs/`:

- **Infrastructure work** — Read infrastructure docs (docker-contexts, volume-safety, swarm-stacks, healthchecks, cicd-pipelines)
- **Platform work** — Read platform docs (ghost-themes, hugo-development, playwright-automation)
- **Code changes** — Read coding/style-guide.md

Read the project's CLAUDE.md for project-specific conventions.

If domain-specific planning guides exist at `~/.claude/docs/planning/`, read those too. Multiple guides may apply to the same project.

### Codebase Patterns

Identify existing patterns relevant to the planned work:

- How similar features are currently implemented
- Naming conventions in the affected area
- Configuration patterns (data-driven vs hardcoded)
- Test patterns if tests exist

## Stage 2: Build the Plan

Structure the plan with these required sections. If any section is missing, add it before proceeding.

### Commit Checkpoints

Identify logical commit points — not just "commit when done." Each major step or feature boundary is a commit. State:

- What gets committed at each checkpoint
- A short commit message for each
- Which checkpoints are safe rollback points

### Documentation Deliverables

Specify which documentation will be created or updated:

- README updates if the interface or setup changes
- Architecture docs if the structure is new or significantly changed
- Inline comments only where intent isn't obvious from the code

Documentation is a deliverable, not an afterthought. If it's not in the plan, it won't get written.

### Human-Touchable Artifacts

List every file the operator might need to read, edit, or inspect between runs. For each one:

- Is it in a human-friendly format (markdown, YAML, env vars — not buried in code)?
- Is it in a predictable, clearly named location?
- Does it follow the style guide's "externalize user-facing content" pattern?

If the operator will touch it, optimize it for the operator, not the code.

### Principle Propagation

If the plan establishes a new pattern or convention, list **every** place in the codebase that pattern applies — not just the first instance. Either:

- Apply the pattern exhaustively in this plan, or
- Flag remaining locations as follow-up work with specific file paths

Do not apply principles locally and hope they spread. Be explicit about scope.

### History Findings

Surface anything from Stage 1 that affects the plan:

- Files with high churn or recent reverts (extra scrutiny needed)
- Co-modified files not yet in the plan (hidden dependencies)
- Past decisions that the plan should respect or explicitly override

## Stage 3: Operator Alignment Gate

**This is a hard stop. Do not proceed to implementation until the operator confirms.**

Before clearing context or beginning execution, describe the plan from the **operator's perspective**:

- What will the operator see when they run this?
- What can they configure without touching code?
- Where will they look when something breaks?
- What files will they need to read or edit?

Diagrams, pseudocode, and rough sketches are encouraged at this step. The goal is shared understanding, not polished documentation.

Ask the operator: **"Does this match what you're picturing?"**

If the operator asks for more detail on any point, provide it. Do not proceed until they confirm alignment.

## Integration

This skill replaces the former `/review-plan` command by moving its history-search work earlier in the process.

### Workflow Chain

```
/feature-plan → Feature Doc → pre-plan → Implementation Plan → Build
```

The feature doc (from `/feature-plan`) defines WHAT and WHY. This skill handles HOW. If a feature doc exists, use its constraints and decisions — don't re-ask questions it already answers. If a feature doc has an implementation order, respect it when defining commit checkpoints.

### Works With

- **`/feature-plan` command** — Produces the feature doc that feeds Stage 0
- **history-search agent** — Used in Stage 1 for git archaeology
- **code-styling skill** — Referenced for pattern consistency
- **Style guide** (`~/.claude/docs/coding/style-guide.md`) — Source of truth for code patterns
- **Domain docs** (`~/.claude/docs/`) — Project-specific conventions

## Notes

- History findings are advisory, not blocking. Red flags mean "understand before proceeding," not "don't proceed."
- If a file has been reverted multiple times, there's likely a reason the code is the way it is.
- High churn files deserve extra scrutiny — they're often more complex than they appear.
- Co-modified files are hidden dependencies — if A always changes with B, your plan should probably touch both.
