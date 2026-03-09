# Table and Visual Format Guide

## Table Substitutions

Default to tables for structured information. Reserve narrative for rationale, tradeoffs, and open questions.

| Instead of... | Use... |
|---------------|--------|
| "We'll modify X to do Y, and also update Z to..." | File change table: File / Change / Reason |
| "The current behavior is A, but we want B..." | Before/after comparison table |
| "This feature depends on X, which requires Y..." | Dependency table with status column |
| "The inputs are A and B, producing output C..." | Input/output table |

## Visual Format Selection

Lead with visuals for structural information. Pick the format that fits the data:

| Format | Use when showing... |
|--------|---------------------|
| Flow diagram | Data paths, control flow, pipeline stages |
| Before/after comparison | What changes in a file, component, or system |
| Dependency graph | What depends on what, implementation order |
| Summary table | Multiple items with shared attributes |
| Change map | Where in the system changes land |

## How to Format

ASCII examples for feature-plan section reviews. Use box-drawing characters (`─ │ ├ └ →`).

## Flow Diagram

When showing data paths, control flow, or pipeline stages.

```
Feature Doc → feature-plan → Plan → Build
                │                  │
                ├→ history-search  ├→ tdd gates
                └→ Explore agents  └→ /review-code
```

## Before/After Comparison

When showing what changes in a file, component, or system.

```
Before                          After
──────                          ─────
Stage 1: narrative prose   →    Stage 1: tables + diagrams
Stage 0: single bullet     →    Stage 0: resumption block
No format guidance          →    Substitution table + format guide
```

## Dependency Graph

When showing what depends on what, or implementation order.

```
004 Lifecycle Tracking
 └→ 005 Pre-Plan Improvements
     ├→ Tables Over Narrative (independent)
     ├→ Visual-First Reviews (independent)
     └→ Resumption Summaries (needs 004 tags)
```

## Summary Table

When showing multiple items with shared attributes. Use markdown tables.

```
| File          | Change              | Reason                    |
|---------------|---------------------|---------------------------|
| SKILL.md      | Add table directive | Structured info as tables |
| SKILL.md      | Add visual guide    | Diagrams for structure    |
| visual-formats| New file            | Progressive disclosure    |
```

## Change Map

When showing where in the system changes land.

```
feature-plan/
├── SKILL.md
│   ├── Stage 0 ← resumption summary
│   ├── Stage 1 ← table + visual directives
│   └── Stage 2 ← table format lines
└── references/
    └── visual-formats.md ← new
```
