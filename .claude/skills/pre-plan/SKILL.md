---
name: pre-plan
description: >
  Walk through a feature doc section by section for operator alignment, then enter plan mode
  for implementation planning. Runs BEFORE plan mode, not during it.
  Triggers: auto-trigger when discussing implementing a feature that has a feature doc,
  explicit /pre-plan invocation, or when the user describes work requiring multiple files
  or architectural decisions. Also suggest /feature-plan first if the user has a loose idea
  without a feature doc.
---

# Pre-Plan

**This skill is NOT optional.** Every implementation plan MUST go through this process. Do not write a plan, create commit checkpoints, or begin implementation without completing all stages below. Skipping this skill leads to plans that miss hidden dependencies, ignore project conventions, and waste operator time on rework.

Walk through the feature doc section by section for operator alignment, then enter plan mode for implementation planning.

**Read first:** `~/.claude/docs/coding/style-guide.md`

## Stage 0: Locate Feature Doc

Check `~/.claude/docs/projects/<name>/features/` for a feature doc (files matching `NNN-*.md`) that covers the work being planned, where `<name>` is derived from the current working directory's folder name.

- **If a feature doc exists**: Read it. Use it to guide the section-by-section review in Stage 1.
- **If no feature doc exists**: Assess whether one would help. If the user is describing a loose or multi-part idea rather than a well-defined task, suggest: **"This sounds like it could benefit from `/feature-plan` first to nail down what we're building. Want to do that before we plan the implementation?"** This is not a hard gate — if the user wants to proceed directly, skip Stage 1 and go to Stage 2 with whatever context is available.

Also read:
- Project plan from `~/.claude/docs/projects/<name>/` for conventions
- Domain docs from `~/.claude/docs/` based on project type
- The project's CLAUDE.md for project-specific conventions

Explicitly exclude `~/.claude/docs/projects/<name>/scenarios/` from context gathering.

## Stage 1: Section-by-Section Review

For each feature section in the doc, walk through this cycle:

1. **Read the section** — absorb what the feature spec asks for
2. **Gather targeted context** — run history-search agents and Explore agents (via the Task tool) scoped to that section's concerns. Not whole-codebase sweeps — targeted investigation of the files and patterns relevant to this specific feature.
3. **Present interpretation** — "Given this feature spec and this codebase, here's what I'd build." Explain how the spec maps to code changes, what existing patterns apply, and any gaps or ambiguities found.
4. **Pause for operator review** — confirm or redirect. Do not proceed to the next section until the operator confirms this section's interpretation.

### Context Gathering Per Section

For each section, gather only what's relevant:

**History search** (via history-search agent):
- Recent modification history and churn on affected files
- Reverts or bug fixes (code may be that way for a reason)
- Files commonly co-modified (hidden dependencies)

**Codebase exploration** (via Explore agents):
- How similar features are currently implemented
- Naming conventions and patterns in the affected area
- Configuration patterns (data-driven vs hardcoded)

Run history-search and Explore agents in parallel for each section. Each agent returns a focused summary, not raw file contents.

### Rules

- Section review is mandatory. No skipping, no batching multiple sections.
- The pause between sections is mandatory. Each section gets confirmed before moving on.
- Domain docs from `~/.claude/docs/planning/` may apply — read relevant guides based on project type.

## Stage 2: Enter Plan Mode

After all sections are reviewed and confirmed, enter plan mode for implementation planning.

Build the plan with these required sections:

### Commit Checkpoints

Identify logical commit points — not just "commit when done." Each major step or feature boundary is a commit. State:

- What gets committed at each checkpoint
- A short commit message for each
- Which checkpoints are safe rollback points

The final checkpoint should include running `/review-code` before the last commit.

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

### History Findings

Surface anything from the section reviews that affects the plan:

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
- The section-by-section review is feedback on spec quality — did the feature plan generate enough context? Over time, this feedback loop improves spec writing.
