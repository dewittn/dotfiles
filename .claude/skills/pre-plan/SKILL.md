---
name: pre-plan
description: "MANDATORY when entering plan mode or creating any implementation plan. This skill MUST be used before writing a plan — it front-loads context gathering through parallel agents and enforces operator alignment before implementation begins. Triggers: entering plan mode, discussing how to implement a feature, user describes work requiring multiple files or architectural decisions. Also suggest /feature-plan first if the user has a loose idea without a feature doc."
---

# Pre-Plan

**This skill is NOT optional.** Every implementation plan MUST go through this process. Do not write a plan, create commit checkpoints, or begin implementation without completing all stages below. Skipping this skill leads to plans that miss hidden dependencies, ignore project conventions, and waste operator time on rework.

Front-load context gathering and design decisions so implementation can run uninterrupted.

**Read first:** `~/.claude/docs/coding/style-guide.md`

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

### Codebase Exploration

Launch **Explore agents** in parallel (via the Task tool) to investigate the codebase. Keep exploration in separate contexts to avoid bloating the planning window.

Target different agents at different concerns:

- How similar features are currently implemented
- Naming conventions and architectural patterns in the affected area
- Configuration patterns (data-driven vs hardcoded)
- Test patterns if tests exist

Each agent should return a focused summary of findings, not raw file contents. Run these alongside the history-search agents.

## Stage 2: Build the Plan

Structure the plan with these required sections. If any section is missing, add it before proceeding.

### Commit Checkpoints

Identify logical commit points — not just "commit when done." Each major step or feature boundary is a commit. State:

- What gets committed at each checkpoint
- A short commit message for each
- Which checkpoints are safe rollback points

The final checkpoint should include running `/review-code` before the last commit. This is the quality gate.

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

This skill handles HOW. The feature doc (from `/feature-plan`) defines WHAT and WHY. If a feature doc exists, use its constraints and decisions — don't re-ask questions it already answers. Respect its implementation order when defining commit checkpoints.

Works with: `/feature-plan` command, `/review-code` command, history-search agent, Explore agents, code-styling skill, style guide (`~/.claude/docs/coding/style-guide.md`), domain docs (`~/.claude/docs/`).

See `~/.claude/docs/planning/README.md` for the full workflow overview.

## Notes

- History findings are advisory, not blocking. Red flags mean "understand before proceeding," not "don't proceed."
- Co-modified files are hidden dependencies — if A always changes with B, the plan should probably touch both.
