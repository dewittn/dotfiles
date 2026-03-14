# Audit Report Template

Use this format when presenting audit findings for both init and skill modes.

## Report Format

```markdown
# Context Audit Report — [mode: init|skill]

**Target:** [file path or "all skills"]
**Date:** [YYYY-MM-DD]

## Token Estimate

| Metric | Words | ~Tokens |
|--------|-------|---------|
| Before | X | Y |
| After  | X | Y |
| Saved  | X | Y |

## Findings

| # | Section | Classification | Rationale |
|---|---------|---------------|-----------|
| 1 | [section name] | [bucket/category] | [why this classification] |
| 2 | ... | ... | ... |

## Hook Candidates (init mode only)

| Rule | Current Location | Suggested Hook Type |
|------|-----------------|-------------------|
| [rule text] | [CLAUDE.md section] | [pre-commit / linter / alias] |

## Proposed Changes

[Numbered list of specific changes to make, grouped by action type:]

### Delete
- [ ] [what to delete and why]

### Move
- [ ] [what to move, from where, to where]

### Keep (no action)
- [ ] [what stays and why]

## Savings Summary

Estimated context reduction: ~X tokens ([Y]% of original)
```

## Usage Notes

- Present the full report before making any changes
- Wait for operator to confirm or modify proposed changes
- After applying changes, re-run estimate-tokens.sh and update the "After" row
- For skill mode batch audits, produce one report per skill audited
