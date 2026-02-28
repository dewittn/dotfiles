---
name: pre-plan
description: >
  Walk through a feature doc section by section for operator alignment, producing an enriched
  feature doc that a fresh /build session can execute from. Runs BEFORE /build, not during it.
  Triggers: auto-trigger when discussing implementing a feature that has a feature doc,
  explicit /pre-plan invocation, or when the user describes work requiring multiple files
  or architectural decisions. Also suggest /feature-plan first if the user has a loose idea
  without a feature doc.
---

# Pre-Plan

**This skill is NOT optional.** Every feature MUST go through this process before building. Do not begin implementation without completing all stages below. Skipping this skill leads to builds that miss hidden dependencies, ignore project conventions, and waste operator time on rework.

Walk through the feature doc section by section for operator alignment, producing an enriched feature doc that a fresh `/build` session can execute from.

**Read first:** `~/.claude/docs/coding/style-guide.md`

## Stage 0: Locate Feature Doc

Check `~/.claude/docs/projects/<name>/features/` for a feature doc (files matching `NNN-*.md`) that covers the work being planned, where `<name>` is derived from the current working directory's folder name.

- **If a feature doc exists**: Read it. Use it to guide the section-by-section review in Stage 1.

After reading the feature doc, check the YAML frontmatter `status` field:

- **`feature-planned`**: Fresh start. Run `date +%Y-%m-%d` for today's date. Update frontmatter: set `status: pre-planning`, set `last-updated` to today's date (add the field if absent). Proceed to Stage 1 from the first section. (Section headings already have `[pending]` tags from the feature-plan template.)
- **`pre-planning`**: Resuming an interrupted session. Read heading tags to find section statuses. Present a structured resumption summary (generated display, not stored in the doc):

  ```
  ## Resuming Pre-Plan: [Feature Name]

  | Section | Status |
  |---------|--------|
  | Feature 1 | reviewed |
  | Feature 2 | reviewed |
  | Feature 3 | pending |

  Picking up at: **Feature 3 — [Section Name]**
  ```

  Heading tags are the single source of truth for status; enriched section bodies are the decision record. Do not add a progress table to the doc.

  If all sections are `[reviewed]`, skip Stage 1 and go directly to Completion.

  Do not re-review completed sections.
- **`planned`**: Pre-planning already complete. Tell the operator: "This feature doc has been pre-planned and is ready for `/build`. Want to re-review instead?"
- **`draft`**: Feature planning not yet complete. Suggest running `/feature-plan` first.
- **`implementing`** or **`complete`**: Already past pre-planning. Tell the operator the current status.

Heading tag format:
```
### Feature A [pending]
### Feature B [in-review]
### Feature C [reviewed]
```

- **If no feature doc exists**: Assess whether one would help. If the user is describing a loose or multi-part idea rather than a well-defined task, suggest: **"This sounds like it could benefit from `/feature-plan` first to nail down what we're building. Want to do that before we plan the implementation?"** This is not a hard gate — if the user wants to proceed directly, skip Stage 1 and go to Completion with whatever context is available.

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

   **Default to tables for structured information.** Use these substitutions:

   | Instead of... | Use... |
   |---------------|--------|
   | "We'll modify X to do Y, and also update Z to..." | File change table: File / Change / Reason |
   | "The current behavior is A, but we want B..." | Before/after comparison table |
   | "This feature depends on X, which requires Y..." | Dependency table with status column |
   | "The inputs are A and B, producing output C..." | Input/output table |

   Reserve narrative for rationale, tradeoffs, and open questions — information that needs explanation, not structure.

   **Lead with visuals for structural information.** Pick the format that fits the data:

   | Format | Use when showing... |
   |--------|---------------------|
   | Flow diagram | Data paths, control flow, pipeline stages |
   | Before/after comparison | What changes in a file, component, or system |
   | Dependency graph | What depends on what, implementation order |
   | Summary table | Multiple items with shared attributes |
   | Change map | Where in the system changes land |

   Use box-drawing characters (`─ │ ├ └ →`) for ASCII diagrams. See `references/visual-formats.md` for examples of each format.
4. **Pause for operator review** — confirm or redirect. Do not proceed to the next section until the operator confirms this section's interpretation.
5. **Update the feature doc** — After the operator confirms a section:
   - Mark the section heading `[reviewed]` (replace `[pending]` or `[in-review]`)
   - Enrich the section content: update Architecture with codebase findings, resolve answered Open Questions, add specifics discovered during review
   - Update `last-updated` in frontmatter (via `date +%Y-%m-%d`)
   - When beginning a new section's review, mark its heading `[in-review]`

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

## Completion

When all sections are reviewed and confirmed:

1. Update feature doc frontmatter: set `status: planned`, `last-updated` via `date +%Y-%m-%d`
2. Create feature branch: `feature/NNNN-name` (base: `dev` if it exists, `main` otherwise)
   - NNNN is the zero-padded feature number, name is the feature slug from the doc filename
3. Push branch to remote: `git push -u origin feature/NNNN-name`

The enriched feature doc is the handoff artifact. A fresh session runs `/build` to plan and implement.

## Integration

This skill handles HOW. The feature doc (from `/feature-plan`) defines WHAT and WHY. If a feature doc exists, use its constraints and decisions — don't re-ask questions it already answers. Respect its implementation order when defining commit checkpoints.

Works with: `/feature-plan` command, `/build` skill, `/review-code` command, tdd skill, history-search agent, Explore agents, code-styling skill, style guide (`~/.claude/docs/coding/style-guide.md`), domain docs (`~/.claude/docs/`).

See `~/.claude/docs/planning/README.md` for the full workflow overview.

## Notes

- History findings are advisory, not blocking. Red flags mean "understand before proceeding," not "don't proceed."
- Co-modified files are hidden dependencies — if A always changes with B, the plan should probably touch both.
- The section-by-section review is feedback on spec quality — did the feature plan generate enough context? Over time, this feedback loop improves spec writing.
