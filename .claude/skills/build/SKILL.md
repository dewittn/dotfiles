---
name: build
description: >
  Execute implementation from an enriched feature doc. Invoked via /build <number> [mode].
  Reads a feature doc with status "planned", enters plan mode to create an implementation plan,
  then executes the plan. Three modes: main (single agent, default), sub (subagent dispatch),
  team (agent team via TeamCreate). Creates a PR on completion.
  Use when a feature doc has been pre-planned and is ready for implementation.
  Do NOT auto-trigger — operator explicitly invokes /build.
argument-hint: "[feature-number] [mode]"
disable-model-invocation: true
---

# Build

Execute implementation from an enriched feature doc. The feature doc (produced by pre-plan) contains all codebase findings, gate assignments, and architectural decisions needed to build.

**Read first:** `~/.claude/docs/coding/style-guide.md`

## Step 1: Locate Feature Doc

Parse arguments: `$0` = feature number, `$1` = mode (default: `main`).

Find the feature doc matching `$0` in `~/.claude/docs/projects/<name>/features/` (where `<name>` is derived from the current working directory's folder name). Look for files matching `NNN-*.md` where NNN matches the feature number.

Guard on status:

| Status | Action |
|--------|--------|
| `planned` | Proceed |
| `draft` | Stop. "This feature doc is still in draft. Run `/feature-plan` to complete it." |
| `feature-planned` | Stop. "This feature doc needs pre-planning. Run `/pre-plan $0` first." |
| `pre-planning` | Stop. "Pre-planning is in progress. Complete `/pre-plan $0` first." |
| `implementing` | Ask: "This feature is already being implemented. Resume building, or start fresh?" |
| `complete` | Stop. "This feature is already complete." |

Run `date +%Y-%m-%d` for today's date. Update frontmatter: set `status: implementing`, set `last-updated` to today's date.

## Step 2: Checkout Branch

Checkout the feature branch created by pre-plan: `feature/NNNN-name`. Skip this step if already on the correct branch (e.g., when running inside a worktree).

If the branch doesn't exist locally, fetch and track it from the remote.

## Step 3: Read Feature Doc

Read the enriched feature doc. Absorb:

- All feature sections with their codebase findings and architecture decisions
- Gate assignments per section (Red-Green-Refactor, Command & Confirm, Usage)
- Implementation order and dependencies
- Out of Scope boundaries, when present — respect these during plan creation
- Open questions and constraints

Also read:
- Project plan from `~/.claude/docs/projects/<name>/` for conventions
- The project's CLAUDE.md for project-specific conventions
- Domain docs from `~/.claude/docs/` based on project type

## Step 4: Enter Plan Mode

Enter plan mode. Build the implementation plan following the structure in `references/plan-structure.md`:

- **Commit Checkpoints** — logical commit points with messages and rollback markers
- **Verification Gates** — gate assignment for every task (summary table required)
- **Documentation Deliverables** — what docs get created or updated
- **Human-Touchable Artifacts** — files the operator will read or edit
- **Principle Propagation** — new patterns applied exhaustively or flagged as follow-up
- **History Findings** — pre-plan findings that affect the plan

### Operator Alignment Gate

Before implementation begins, describe the plan from the **operator's perspective**:

- What will the operator see when they run this?
- What can they configure without touching code?
- Where will they look when something breaks?
- What files will they need to read or edit?
- Are the gate assignments correct?

Ask: **"Does this match what you're picturing?"**

Do not proceed until the operator confirms.

## Step 5: Execute Plan

Execute the approved plan using the selected mode. See `references/modes.md` for mode details.

| Mode | Delegation |
|------|------------|
| `main` | Single agent, sequential execution |
| `sub` | Task tool dispatch, `general-purpose` subagent type |
| `team` | TeamCreate with shared TaskList, peer messaging |

Common across all modes:

- Use Claude Code's TaskList for task management
- Each task carries its gate assignment — TDD skill auto-triggers on code-producing tasks
- 3-cycle review limit per task, then escalate to operator
- Commit at each checkpoint identified in the plan

## Step 6: Final Quality Gate

After all tasks are complete, run `/review-code` before the final commit. This is the last quality gate before the PR.

## Step 7: Completion

1. Update feature doc frontmatter: set `status: complete`, `last-updated` via `date +%Y-%m-%d`
2. Move feature doc from `features/NNN-name.md` to `features/complete/NNN-name.md` (create `complete/` directory if needed)
3. Commit and push via the commit skill (which handles branch-aware push and PR creation)

The commit skill's branch behavior creates the PR automatically when pushing a non-main branch.

## Integration

This skill handles BUILD. Pre-plan (enrichment) defines the inputs. The feature doc is the contract between pre-plan and build — all codebase findings, gate assignments, and decisions must be in the doc, not in a shared context window.

Works with: `pre-plan` skill, `/review-code` command, `tdd` skill, `commit` skill, style guide (`~/.claude/docs/coding/style-guide.md`), domain docs (`~/.claude/docs/`).

See `~/.claude/docs/planning/README.md` for the full workflow overview.

## Notes

- Build failures leave status at `implementing` so the operator can re-run `/build` in a new session.
- Worktree is external — the operator creates a worktree before invoking `/build`. This skill works with whatever branch/checkout it finds.
- The `sub` and `team` modes are experimental. Start with `main` until the others prove their value.
