# Planning Methodology

How the six planning tools relate to each other — zoom levels, artifact flow, and quality gates.

## Zoom Hierarchy

Planning happens at three levels. Each level has its own tool and its own scope.

### Project Level — /project-plan

Vision, architecture, and strategy for an entire project. Spans multiple sessions. Produces a project directory at `~/.claude/docs/projects/<name>/` with a README and facet documents (technical architecture, business positioning, time/priorities, etc.).

Use when starting a new project or rethinking foundations. The project plan sets constraints and conventions that flow down to feature and implementation planning.

### Feature Level — /feature-plan

WHAT and WHY for a single feature. Produces `~/.claude/docs/projects/<name>/features/NNN-feature-name.md` outside the project repo. Scoped to one capability — not the whole system.

Use when an idea needs thinking through before building. Reads project-level docs for context when they exist. Checks the inbox (`~/.claude/docs/projects/inbox/`) for raw ideas that may seed the session.

### Implementation Level — pre-plan → /build

HOW to build a specific feature or change. Two phases: **pre-plan** enriches the feature doc through section-by-section review with operator alignment, then **`/build`** creates an implementation plan and executes it in a fresh session.

Use pre-plan for any multi-file change. It reads feature docs and handoff docs as input, gathers codebase context, and writes findings back to the feature doc. The enriched doc becomes the handoff artifact for `/build`.

## Artifact Flow

Each tool produces artifacts that downstream tools consume.

```
/project-plan
  └─→ ~/.claude/docs/projects/<name>/    (project dir)
        ├─ read by /feature-plan         (for project context)
        └─ read by pre-plan              (for conventions)

/feature-plan
  └─→ ~/.claude/docs/projects/<name>/features/NNN-feature-name.md  (feature doc)
        ├─ read by pre-plan              (Stage 0 input)
        └─ written back by pre-plan      (status updates, section enrichment)

frontend-prototype
  └─→ tmp/prototype/ + HANDOFF.md        (design artifacts)
  └─→ optional design-contract.json      (W3C DTCG tokens)
        └─ read by pre-plan              (design input)

pre-plan
  ├─→ enriched feature doc               (status + section updates written back)
  └─→ feature branch                     (pushed to remote for /build)

/build
  ├─→ implementation plan                (created in plan mode)
  ├─→ committed code on feature branch   (with verification gates passed)
  └─→ pull request                       (to dev or main)

/review-code
  └─→ review summary                     (gates final commit)

commit
  └─→ committed + pushed code            (enforces safety rules)
```

## Document Lifecycle

Feature docs carry YAML frontmatter with a `status` field that tracks where the document is in the planning chain. Each tool advances the status when it finishes its work.

```
draft → feature-planned → pre-planning → planned → implementing → complete
  │          │                  │            │            │            │
  │     /feature-plan      pre-plan      pre-plan     /build       /build
  │       sets this       Stage 0       completion    start        final
  │                       sets this      sets this    sets this    sets this
  └── initial state                                                  │
                                                                     ▼
                                                          features/complete/
```

| Status | Set by | Meaning |
|--------|--------|---------|
| `draft` | Template default | Feature planning not yet complete |
| `feature-planned` | `/feature-plan` | Feature defined, ready for implementation planning |
| `pre-planning` | pre-plan Stage 0 | Section-by-section review in progress |
| `planned` | pre-plan completion | Enriched and ready for `/build` |
| `implementing` | `/build` start | Code work underway |
| `complete` | `/build` finish | Feature delivered; doc archived to `features/complete/` |

Frontmatter also carries `date` (creation) and `last-updated` (set via `date +%Y-%m-%d` at each transition).

During pre-plan Stage 1, individual feature sections are tracked with heading tags (`[pending]`, `[in-review]`, `[reviewed]`). These tags enable session resumption — if a pre-planning session is interrupted, the next session reads the heading tags to skip already-reviewed sections and pick up where it left off.

## Quality Gates

Four quality gates ensure operator and agent stay in sync.

### pre-plan Stage 1 — Section-by-Section Review

Before plan mode, pre-plan walks through each feature section individually. For each section: gather targeted context, present interpretation, pause for operator confirmation. This catches misinterpretation at the section level before it compounds across features.

After the operator confirms a section, pre-plan enriches the feature doc — updating Architecture with codebase findings, resolving answered Open Questions, and marking the heading `[reviewed]`. This enrichment means the feature doc improves as a side effect of implementation planning.

If a session is interrupted mid-review, the heading tags (`[pending]`/`[in-review]`/`[reviewed]`) serve as the resumption point. The next session presents a summary of completed sections and picks up at the first `[pending]` section without re-reviewing.

### /build — Operator Alignment

After entering plan mode, `/build` presents the full implementation approach for operator review. No code is written until the operator confirms the plan matches their intent.

### TDD Verification Gates — Build Phase

During implementation, each task carries a verification gate assigned during pre-plan:
Red-Green-Refactor, Command & Confirm, Evals, or Human Review.
Evals currently falls back to Human Review until eval tooling is configured.
The TDD skill enforces gate compliance. See `~/.claude/skills/tdd/SKILL.md`.

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
