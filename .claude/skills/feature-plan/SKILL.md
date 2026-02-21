---
name: feature-plan
description: >
  Turn loose ideas into well-defined feature documents through guided conversation.
  Use when discussing adding complex functionality, planning a new feature, brainstorming
  system changes that touch multiple components, or when the user has an idea they want
  to think through before building. Also trigger when the user describes something they
  want to build but hasn't defined the scope, boundaries, or constraints yet.
  Produces a feature doc (WHAT and WHY) that feeds into /pre-plan (HOW).
  Can also be invoked explicitly with /feature-plan.
---

# Feature Planning

A conversational skill for turning loose ideas into well-defined feature documents.

**You are not building a spec. You are helping the operator discover what they actually want.**

The deliverable is a **feature doc** that answers WHAT and WHY, not HOW. The feature doc becomes the input artifact for `/pre-plan`, which handles implementation planning.

## Timer Scripts

Use the bundled scripts for tracking planning duration. Do not generate date/duration logic manually.

**Start timer** (run at the very beginning, before any conversation):
```bash
~/.claude/skills/feature-plan/scripts/start-timer.sh <docs-dir> <NNN> <feature-slug>
# Example: ~/.claude/skills/feature-plan/scripts/start-timer.sh ~/.claude/docs/projects/my-tool/features 001 hybrid-memory-search
```

**Log duration and clean up** (run when operator signals completion):
```bash
# Print duration only:
~/.claude/skills/feature-plan/scripts/log-duration.sh <docs-dir> <NNN> <feature-slug>

# Print duration AND append to planning log:
~/.claude/skills/feature-plan/scripts/log-duration.sh <docs-dir> <NNN> <feature-slug> --log <project-name>
```

**Project name**: Derive `<name>` from the current working directory's folder name (same convention as `/project-plan`).

**Feature numbering**: Check `~/.claude/docs/projects/<name>/features/` for existing docs (files matching `NNN-*.md`). Use the next sequential number.

**Project context**: Read the project plan README at `~/.claude/docs/projects/<name>/README.md` when it exists. If no project plan exists, proceed without project context — feature planning is not gated on project planning.

## Workflow

### Phase 0: Check the Inbox

Before starting a fresh conversation, check `~/.claude/docs/projects/inbox/` for pending items.

- **If inbox items exist**: List them. For each item, read project README summaries from `~/.claude/docs/projects/*/README.md` to suggest which project it belongs to. Always ask the operator before filing — no silent auto-sorting.
- **If an item matches the current project**: Offer to use it as the seed for this feature planning session.
- **If items don't match any project**: Surface them cleanly. They may need a project plan first.
- **After a feature doc is written from an inbox item**: Delete the inbox item.
- **If no inbox items exist or operator wants to start fresh**: Continue to Phase 1.

### Phase 1: Capture the Raw Idea

1. Run `start-timer.sh` immediately
2. Absorb the operator's description — listen for core intent, identify separate features vs. parts of one, note confidence vs. hand-waving
3. Summarize back as distinct features/concerns
4. Ask: **"Is this everything, or is there more rattling around?"**

Match depth to complexity. Not every feature needs four rounds of clarification.

### Phase 2: Clarifying Questions

Ask 2-3 questions at a time, not all at once. Focus on:

- **Placement**: Where does this sit in the existing system? What triggers it? What does it produce?
- **Boundaries**: What is IN scope vs. explicitly OUT?
- **Inputs/outputs**: What data flows in and out? What format?
- **Constraints**: Architectural decisions, technology choices, patterns to follow
- **Edge cases**: What should degrade gracefully vs. fail loudly?
- **Ambiguity test**: Could a competent developer read this and build the wrong thing? If yes, ask the clarifying question.

### Phase 3: Iterative Refinement

Draft the feature doc using the template at [references/feature-plan-template.md](references/feature-plan-template.md). Share it. Incorporate operator feedback. Each "wait, actually..." is a design decision being surfaced — slow down and explore it.

Feature docs live at: `~/.claude/docs/projects/<name>/features/NNN-feature-name.md`

### Phase 4: Dependency Mapping

Identify which features depend on others, which are independent, and suggest implementation order with rationale.

### Phase 5: Log the Time

When operator signals completion:
1. Run `log-duration.sh` (with `--log` flag if operator wants it logged)
2. Report the duration

## Guiding Principles

- **Ask, don't assume.** Surface the operator's defaults, don't substitute your own.
- **Follow the tweaks.** "Oh, and also..." signals discovery. Explore it.
- **Keep implementation out (mostly).** Capture constraints as decisions, not solutions.
- **Name the open questions.** Explicitly marking "open" beats pretending it's decided.
- **Respect the operator's energy.** Match their pace. Capture thinking while it's fresh.
