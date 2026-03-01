# Plan Structure Requirements

Required sections when building an implementation plan from an enriched feature doc.

## Commit Checkpoints

Identify logical commit points — not just "commit when done." Each major step or feature boundary is a commit. State:

- What gets committed at each checkpoint
- A short commit message for each
- Which checkpoints are safe rollback points

The final checkpoint should include running `/review-code` before the last commit.

## Verification Gates

Assign a gate to every task using the TDD skill's gate definitions:

| Task produces... | Gate |
|------------------|------|
| Testable behavior (functions, APIs, logic) | Red-Green-Refactor |
| Config/infrastructure with a validator | Command & Confirm |
| Docs, planning, non-executable | Usage |

For Command & Confirm: include the specific command and expected output in the plan.
Tag each step heading: `## Step 1a: Create Tables [Red-Green-Refactor]`

Include a summary table of all tasks with gate assignments for quick scanning.

## Documentation Deliverables

Present as a table: **File / Change / Reason**.

Specify which documentation will be created or updated:

- README updates if the interface or setup changes
- Architecture docs if the structure is new or significantly changed
- Inline comments only where intent isn't obvious from the code

Documentation is a deliverable, not an afterthought. If it's not in the plan, it won't get written.

## Human-Touchable Artifacts

Present as a table: **File / Location / Purpose**.

List every file the operator might need to read, edit, or inspect between runs. For each one:

- Is it in a human-friendly format (markdown, YAML, env vars — not buried in code)?
- Is it in a predictable, clearly named location?
- Does it follow the style guide's "externalize user-facing content" pattern?

If the operator will touch it, optimize it for the operator, not the code.

## Principle Propagation

If the plan establishes a new pattern or convention, list **every** place in the codebase that pattern applies — not just the first instance. Either:

- Apply the pattern exhaustively in this plan, or
- Flag remaining locations as follow-up work with specific file paths

## History Findings

Present as a table: **File / Finding / Impact**.

Surface anything from the pre-plan section reviews that affects the plan:

- Files with high churn or recent reverts (extra scrutiny needed)
- Co-modified files not yet in the plan (hidden dependencies)
- Past decisions that the plan should respect or explicitly override

## Operator Alignment Gate

**This is a hard stop. Do not proceed to implementation until the operator confirms.**

Before beginning execution, describe the plan from the **operator's perspective**:

- What will the operator see when they run this?
- What can they configure without touching code?
- Where will they look when something breaks?
- What files will they need to read or edit?
- Are the gate assignments correct? (Show the summary table for review)

Diagrams, pseudocode, and rough sketches are encouraged. The goal is shared understanding, not polished documentation.

Ask the operator: **"Does this match what you're picturing?"**

Do not proceed until they confirm alignment.
