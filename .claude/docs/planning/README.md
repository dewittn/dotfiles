# Planning Workflow

How features move from idea to implementation.

## The Workflow Chain

```
/project-plan → Project Dir ─┐
                              ├→ /feature-plan → Feature Doc → pre-plan → Plan → Build → /review-code → commit
                              │                                   ↑
                              │      frontend-prototype → Handoff Doc (for design-heavy work)
                              └──────────────────────────────────→┘
```

The refined pipeline adds scenario validation between feature planning and implementation:

```
/feature-plan → /scenario → pre-plan → plan mode → build
```

Each stage has a specific job. Not every project needs every stage — match the process to the scope. See [methodology.md](methodology.md) for how the stages relate (zoom hierarchy, artifact flow, quality gates).

Raw ideas land in the **inbox** (`~/.claude/docs/projects/inbox/`) and get picked up when `/feature-plan` is invoked.

## Tools

| Name | Type | Trigger | Deliverable |
|------|------|---------|-------------|
| /project-plan | Command | Manual | Project dir at `~/.claude/docs/projects/<name>/` with executive summary + technical context |
| /feature-plan | Command | Manual | Feature doc at `~/.claude/docs/projects/<name>/features/NNN-feature-name.md` |
| frontend-prototype | Skill | Auto (design work) | Static HTML in `tmp/prototype/` + `HANDOFF.md` |
| pre-plan | Skill | Auto (discussing implementation) or manual | Section-by-section review, then implementation plan with commit checkpoints |
| /review-code | Command | Manual | Review summary with READY TO COMMIT / ADDRESS ISSUES verdict |
| commit | Skill | Auto (git commit) | Committed + pushed code with safety enforcement |

## Common Paths

### Greenfield project
```
/project-plan → Project Dir
/feature-plan → Feature Doc (in ~/.claude/docs/projects/<name>/features/)
pre-plan → Section Review → Implementation Plan
Build → /review-code → commit
```

### Large feature with design
```
/feature-plan → Feature Doc
frontend-prototype → Handoff Doc
pre-plan → Section Review → Implementation Plan (reads both docs)
Build → /review-code → commit
```

### Feature without design work
```
/feature-plan → Feature Doc
pre-plan → Section Review → Implementation Plan (reads feature doc)
Build → /review-code → commit
```

### Well-defined task, no feature doc needed
```
pre-plan → Implementation Plan
Build → /review-code → commit
```

### Simple change
```
Just build it → commit
```

## Project Structure

Planning artifacts live in `~/.claude/docs/projects/<name>/`:

```
~/.claude/docs/projects/
├── inbox/                    # Raw ideas landing zone
├── <project-name>/
│   ├── README.md             # Executive summary
│   ├── technical.md          # Codebase context
│   ├── features/             # Feature docs (NNN-name.md)
│   ├── scenarios/            # Behavioral specs (holdout set)
│   └── <facet>.md            # Facet documents
```

## Planning Guides

Domain-specific reference docs consulted during planning.

| Guide | When to Read |
|-------|-------------|
| [methodology.md](methodology.md) | How planning stages relate — zoom hierarchy, artifact flow, quality gates |
| [frontend-design.md](frontend-design.md) | Frontend/UI work, design systems, design contracts |
| [agentic-systems.md](agentic-systems.md) | LLM agents, tool use, AI pipelines, intelligence boundaries |
| [infrastructure.md](infrastructure.md) | Docker, deployment, CI/CD, server config, operational systems |
