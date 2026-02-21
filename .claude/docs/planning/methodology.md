# Planning Methodology

How the six planning tools relate to each other — zoom levels, artifact flow, and quality gates.

## Zoom Hierarchy

Planning happens at three levels. Each level has its own tool and its own scope.

### Project Level — /project-plan

Vision, architecture, and strategy for an entire project. Spans multiple sessions. Produces a project directory at `~/.claude/docs/projects/<name>/` with a README and facet documents (technical architecture, business positioning, time/priorities, etc.).

Use when starting a new project or rethinking foundations. The project plan sets constraints and conventions that flow down to feature and implementation planning.

### Feature Level — /feature-plan

WHAT and WHY for a single feature. Produces `docs/feature-plan-NNN-name.md` in the project repo. Scoped to one capability — not the whole system.

Use when an idea needs thinking through before building. Reads project-level docs for context when they exist.

### Implementation Level — pre-plan

HOW to build a specific feature or change. Produces an implementation plan with commit checkpoints, documentation deliverables, and operator alignment confirmation.

Use for any multi-file change. Reads feature docs and handoff docs as input. This is where abstract plans become concrete steps.

## Artifact Flow

Each tool produces artifacts that downstream tools consume.

```
/project-plan
  └─→ ~/.claude/docs/projects/<name>/    (project dir)
        ├─ read by /feature-plan         (for project context)
        └─ read by pre-plan              (for conventions)

/feature-plan
  └─→ docs/feature-plan-NNN-name.md      (feature doc)
        └─ read by pre-plan              (Stage 0 input)

frontend-prototype
  └─→ tmp/prototype/ + HANDOFF.md        (design artifacts)
  └─→ optional design-contract.json      (W3C DTCG tokens)
        └─ read by pre-plan              (design input)

pre-plan
  └─→ implementation plan                (drives build phase)

/review-code
  └─→ review summary                     (gates final commit)

commit
  └─→ committed + pushed code            (enforces safety rules)
```

## Quality Gates

Two hard stops require explicit operator approval before work continues.

### pre-plan Stage 3 — Operator Alignment

After context gathering and plan drafting, pre-plan presents the implementation approach for operator review. No code is written until the operator confirms the plan matches their intent. This catches misunderstandings before they become wasted work.

### /review-code — Quality Check

After implementation is complete, five parallel review agents (security, code quality, test coverage, docs compliance, CI/CD) evaluate the changes. The review produces a verdict: READY TO COMMIT or ADDRESS ISSUES FIRST. This gates the final commit.

## Scenarios

Behavioral specifications that validate whether built software does what the spec described.

### Directory Convention

Scenarios live at `~/.claude/docs/projects/<name>/scenarios/NNN-feature-name/scenario-description.md`, organized by feature number matching the feature plan they validate.

### Holdout Principle

Scenarios live outside project repos so coding agents can't see them during implementation. This separation is intentional — scenarios are the "holdout set" that validates agent output without influencing it. Pre-plan must explicitly exclude `~/.claude/docs/projects/<name>/scenarios/` from context gathering.

### Format

Not yet formalized. Current convention: natural language Given/When/Then markdown. No automation — scenarios are manually written and manually evaluated.

## Commit Rules

The commit skill enforces safety rules at the very end of the chain:

- **Never reuse messages** — `git commit -C` is banned. Every commit gets a fresh message based on `git diff --staged`.
- **GPG signing** — If signing fails (1Password locked), stop and wait. Never bypass with `--no-gpg-sign`.
- **Branch-aware push** — On `main`, push directly. On other branches, push with `-u` and create/update a PR automatically.
- **Versioning** — Semver or CalVer tagging, only when explicitly requested.
