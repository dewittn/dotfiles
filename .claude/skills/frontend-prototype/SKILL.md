---
name: frontend-prototype
description: Use when creating new visual designs, overhauling existing UI, or making significant design system changes. Mocks designs in static HTML before applying to the project. Not for minor adjustments like font tweaks or color changes within an existing system.
---

# Frontend Prototype

Mock significant design changes in static HTML before applying them to the project. This is the frontend equivalent of `/feature-plan` — a place to refine design decisions before they enter the codebase.

**Read first:** `~/.claude/docs/planning/frontend-design.md`

## When to Invoke

- Creating a new visual design or look
- Overhauling existing UI or design system
- Significant layout or component changes across multiple pages
- When the `frontend-design` plugin is about to do major generative work

Do NOT invoke for:
- Minor adjustments (font tweaks, color changes within existing system)
- Bug fixes to existing CSS
- Content updates that don't change the design

## Phase 1: Prototype in Static HTML

Create a temporary directory in the project for mockups:

```
<project>/tmp/prototype/
  index.html
  page-two.html
  styles.css
```

Generate freely. The goal is to explore what the design *could* look like. Don't worry about consistency across pages — that comes later. This is where speed is valuable.

Use `playwright-cli` to capture screenshots at standard viewports (375px, 768px, 1440px) for the operator to review.

**Output:** A set of rough pages representing the design direction.

## Phase 2: Operator Review

Present the prototypes to the operator for art direction review. The questions at this stage:

- Does this direction feel right for the project?
- Which pages have the right feel?
- Which type treatments, color palettes, and layouts work?
- What's the overall visual identity emerging?

This is taste-level judgment. Iterate based on feedback until the operator is satisfied with the direction.

**Output:** An approved design direction.

## Phase 3: Extract Design Decisions

Once a direction is approved, extract the design decisions into the handoff document. Identify:

- Colors used (palette and semantic mappings)
- Typography (families, sizes, weights, line heights)
- Spacing patterns
- Component patterns (cards, buttons, nav, etc.)
- Breakpoint behavior

For larger projects where a formal design contract is warranted, extract tokens into W3C DTCG format (`design-contract.json`). See `~/.claude/docs/planning/frontend-design.md` for the contract format and validation approach.

For smaller projects, the handoff document alone is sufficient.

## Phase 4: Write Handoff Document

Create a handoff document in the prototype directory:

```
<project>/tmp/prototype/
  HANDOFF.md
  index.html
  ...
```

### Handoff Document Structure

```markdown
# Design Handoff: [Project/Feature Name]

**Date**: YYYY-MM-DD
**Status**: Approved / Needs revision

## Approved Direction

[Brief description of what was approved and why]

## Design Decisions

### Colors
- Primary: #xxx
- Accent: #xxx
- Background: #xxx
- Text: #xxx
[List the intentional palette — curate, don't dump every value]

### Typography
- Headings: [family, weight]
- Body: [family, size, line-height]
- [Other notable type treatments]

### Spacing
- [Notable spacing patterns, base unit if established]

### Components
- [Key component patterns and their visual rules]

### Responsive Behavior
- [How layout changes across breakpoints]
- [Any breakpoint-specific decisions]

## Screenshots

[Reference to captured screenshots at each viewport]

## What Was Rejected

[Design directions explored but not chosen — important context for
why the approved direction looks the way it does]

## Implementation Notes

[Anything the implementing agent needs to know — constraints,
gotchas, patterns to follow, files to reference]
```

## Integration

### Workflow Chain

```
/feature-plan (optional, WHAT/WHY)
    → frontend-prototype (DESIGN — mock in static HTML)
        → pre-plan (HOW — implementation plan)
            → implementation
```

The handoff document is the bridge between prototyping and implementation. When pre-plan runs, it should check for a handoff document and use its design decisions to inform the implementation plan.

### Works With

- **`frontend-design` plugin** — Can be invoked manually during Phase 1 for novel design generation. The plugin handles creative generation; this skill handles the process around it.
- **`playwright-cli`** — Used for capturing screenshots at standard viewports during prototyping
- **pre-plan skill** — Consumes the handoff document when planning implementation
- **`~/.claude/docs/planning/frontend-design.md`** — Reference for design contract format when scope warrants it

### Cleanup

The `tmp/prototype/` directory can be removed once the design is implemented in the project. The handoff document captures everything needed — the static HTML is disposable.

## Notes

- The `frontend-design` plugin is a third-party Anthropic marketplace plugin. It may change on update. This skill handles process; the plugin handles creative generation. Don't couple to its internals.
- Not every frontend change needs this workflow. Match the process to the scope. A new site design warrants full prototyping. A button style change does not.
- The handoff document is the minimum deliverable. The formal design contract (`design-contract.json`) is only for projects where mechanical enforcement of design tokens is worth the investment.
