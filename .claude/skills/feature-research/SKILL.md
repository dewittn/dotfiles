---
name: feature-research
description: >
  Research unfamiliar territory for a feature doc by crafting adaptive prompts for Claude AI
  and integrating findings through discussion. Use when a feature doc involves tools, patterns,
  or techniques the operator hasn't used before. Invoked manually via /feature-research.
  Not embedded in feature-define or feature-plan — standalone skill.
argument-hint: "[NNN or path]"
---

# Feature Research

Research unfamiliar territory for a feature doc by crafting adaptive prompts for Claude AI and integrating curated findings.

## Phase 0: Locate Feature Doc

Parse the argument — accept NNN (zero-padded feature number) or a full path. Look in `~/Programing/dewittn/agentic-docs/projects/<name>/features/` where `<name>` is derived from the current working directory's folder name.

Read the feature doc. Check the YAML frontmatter `status` field:

- **`draft`**: Feature planning not yet complete. Suggest running `/feature-define` first.
- **`feature-planned`**, **`pre-planning`**, **`planned`**: Valid states for research. Proceed.
- **`implementing`** or **`complete`**: Warn the operator — research is typically done before implementation. Proceed only if confirmed.

## Phase 1: Identify & Select Features

Parse `### Feature Name [status]` headings from the feature doc. For each feature, check whether a `#### Research Discoveries` subsection already exists.

Present a selection table:

```
| # | Feature | Researched? |
|---|---------|-------------|
| 1 | Feature A | No |
| 2 | Feature B | Yes (2026-03-01) |
| 3 | Feature C | No |
```

Ask the operator which feature(s) to research this session. Incremental by design — can research one today, another tomorrow.

## Phase 2: Craft Research Prompt

For each selected feature, generate an adaptive prompt for Claude AI. Not a fixed template — shape the prompt to the specific unknowns. Reference `references/research-prompt-guide.md` for crafting guidance.

Include in the prompt:
- Project context from the feature doc (what the feature describes)
- What's known vs unknown
- Specific questions shaped by the unknowns

Output the prompt for the operator to copy to Claude AI.

## Phase 3: Discussion

When the operator brings back findings, drive a discussion:

1. **Surface trade-offs** — identify tensions between approaches
2. **Ask clarifying questions** — fill gaps the research left open
3. **Help make decisions** — the operator decides what fits, not the research

This is discuss-then-curate. Raw research is noisy — the operator decides what belongs in the feature doc before anything is written.

## Phase 4: Integration

Write curated findings into the feature doc as `#### Research Discoveries` subsections under each researched feature heading. Place after `Architecture` and before `Open questions`.

Structured fields (all optional — only include what's relevant):

- **Approach chosen**: What and why
- **Key tools/libraries**: Relevant resources identified
- **Pitfalls identified**: What to watch out for
- **Decisions made**: Trade-offs resolved during discussion

Handle broader implications separately:
- **Project plan changes** — flag for the operator to update the project plan
- **New inbox items** — suggest items for `~/Programing/dewittn/agentic-docs/projects/inbox/`
- **Constraint updates** — note if research changes assumptions in the feature doc

Update `last-updated` in the feature doc frontmatter via `date +%Y-%m-%d`.

## Integration

Works with: `/feature-define` (produces the docs this skill consumes), `feature-plan` (consumes the enriched docs this skill produces), `/build` (uses research context for implementation), style guide (`~/Programing/dewittn/agentic-docs/coding/style-guide.md`), domain docs (`~/Programing/dewittn/agentic-docs/`).

See `~/Programing/dewittn/agentic-docs/planning/README.md` for the full workflow overview.

## Notes

- Exploratory by nature. For genuinely unfamiliar territory, not procedural research. Prompt generation should reflect curiosity, not checklist completion.
- Incremental research is a first-class concern. A feature doc with three features might get researched across three separate sessions.
- Discuss-then-curate is deliberate. Raw research is noisy and opinionated — the operator makes decisions before anything touches the doc.
