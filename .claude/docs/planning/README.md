# Planning Workflow

How features move from idea to implementation.

## The Workflow Chain

```
/feature-plan → Feature Doc → pre-plan → Implementation Plan → Build → /review-code → Commit
                                 ↑
            frontend-prototype → Handoff Doc (for design-heavy work)
```

Each stage has a specific job. Not every project needs every stage — match the process to the scope.

### /feature-plan (Command, Manual)

**What it does:** Conversational skill for turning loose ideas into well-defined feature documents.

**When to use:** You have an idea (or several) that needs thinking through before building. The feature is vague, multi-part, or has hidden assumptions.

**When to skip:** The feature is small, well-defined, and you already know exactly what you want.

**Deliverable:** Feature doc at `docs/feature-plan-NNN-name.md` — defines WHAT and WHY.

**Invoke:** `/feature-plan <description of what you want to build>`

### frontend-prototype (Skill, Auto-triggers)

**What it does:** Mocks significant design changes in static HTML before applying them to the project.

**When to use:** Creating a new visual design, overhauling UI, or making significant design system changes.

**When to skip:** Minor adjustments like font tweaks or color changes within an existing system.

**Deliverable:** Static HTML prototypes in `tmp/prototype/` with a `HANDOFF.md` document capturing approved design decisions. For larger projects, optionally a `design-contract.json` in W3C DTCG format.

**Trigger:** Auto-suggests when significant frontend design work is detected.

### pre-plan (Skill, Auto-triggers)

**What it does:** Front-loads context gathering and design decisions so implementation can run uninterrupted.

**When to use:** Any multi-file change, feature implementation, or refactor.

**When to skip:** Single-file fixes, typos, tasks with explicit step-by-step instructions.

**Deliverable:** Implementation plan with commit checkpoints, documentation deliverables, and operator alignment confirmation.

**Trigger:** Auto-fires when entering plan mode or discussing implementation strategy. Checks for feature docs and handoff documents before planning.

### /review-code (Command, Manual)

**What it does:** Runs five parallel review agents (security, code quality, test coverage, docs compliance, CI/CD) against recent changes.

**When to use:** After implementation is complete and working, before the final commit.

**When to skip:** Trivial changes, documentation-only edits, config tweaks.

**Deliverable:** Consolidated review summary with action items and a READY TO COMMIT / ADDRESS ISSUES FIRST verdict.

**Invoke:** `/review-code`

## Common Paths

### Full workflow (large feature with design)

```
/feature-plan → Feature Doc
frontend-prototype → Handoff Doc
pre-plan → Implementation Plan (reads both docs)
Build
/review-code → Commit
```

### Feature without design work

```
/feature-plan → Feature Doc
pre-plan → Implementation Plan (reads feature doc)
Build
/review-code → Commit
```

### Well-defined task, no feature doc needed

```
pre-plan → Implementation Plan
Build
/review-code → Commit
```

### Simple change

```
Just build it.
```

## Planning Guides

Domain-specific reference docs consulted during planning.

| Guide | When to Read |
|-------|-------------|
| [frontend-design.md](frontend-design.md) | Frontend/UI work, design systems, design contracts |
| [agentic-systems.md](agentic-systems.md) | LLM agents, tool use, AI pipelines, intelligence boundaries |
| [infrastructure.md](infrastructure.md) | Docker, deployment, CI/CD, server config, operational systems |
