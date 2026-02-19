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

Each stage has a specific job. Not every project needs every stage — match the process to the scope. See [methodology.md](methodology.md) for how the stages relate (zoom hierarchy, artifact flow, quality gates).

## Tools

| Name | Type | Trigger | Deliverable |
|------|------|---------|-------------|
| /project-plan | Command | Manual | Project dir at `~/.claude/docs/projects/<name>/` |
| /feature-plan | Command | Manual | Feature doc at `docs/feature-plan-NNN-name.md` |
| frontend-prototype | Skill | Auto (design work) | Static HTML in `tmp/prototype/` + `HANDOFF.md` |
| pre-plan | Skill | Auto (plan mode) | Implementation plan with commit checkpoints |
| /review-code | Command | Manual | Review summary with READY TO COMMIT / ADDRESS ISSUES verdict |
| commit | Skill | Auto (git commit) | Committed + pushed code with safety enforcement |

## Common Paths

### Greenfield project
```
/project-plan → Project Dir
/feature-plan → Feature Doc
pre-plan → Implementation Plan
Build → /review-code → commit
```

### Large feature with design
```
/feature-plan → Feature Doc
frontend-prototype → Handoff Doc
pre-plan → Implementation Plan (reads both docs)
Build → /review-code → commit
```

### Feature without design work
```
/feature-plan → Feature Doc
pre-plan → Implementation Plan (reads feature doc)
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

## Planning Guides

Domain-specific reference docs consulted during planning.

| Guide | When to Read |
|-------|-------------|
| [methodology.md](methodology.md) | How planning stages relate — zoom hierarchy, artifact flow, quality gates |
| [frontend-design.md](frontend-design.md) | Frontend/UI work, design systems, design contracts |
| [agentic-systems.md](agentic-systems.md) | LLM agents, tool use, AI pipelines, intelligence boundaries |
| [infrastructure.md](infrastructure.md) | Docker, deployment, CI/CD, server config, operational systems |
