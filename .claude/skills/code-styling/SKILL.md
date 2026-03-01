---
name: code-styling
description: |
  Apply consistent coding style patterns when writing or reviewing code. Complements linters with higher-level style decisions.

  Trigger when:
  - Refactor phase — After code is working, before final commit
  - Cleanup requests — "Clean this up", "apply my style", "refactor"
  - Code review — When suggesting improvements to existing code

  During initial implementation, focus on getting things working. Apply these patterns when polishing.
---

# Code Styling

**Read first:** `~/.claude/docs/coding/style-guide.md`

## Patterns

1. **Guard clauses over nesting** — Flatten control flow with early returns
2. **Single-line if** — For simple guards and assignments (JavaScript)
3. **Data-driven design** — Prefer configuration over hardcoded branches
4. **Extract at 3+** — Only extract when pattern repeats 3+ times
5. **Project standards win** — CLAUDE.md and linter configs take precedence

## File Length Check

The `scripts/check-file-lengths.sh` script flags files exceeding 600 lines.

Usage: `bash <skill-path>/scripts/check-file-lengths.sh [file ...]`
- Pass file paths as arguments (e.g., changed files from `git diff --name-only`)
- Outputs warnings for files over 600 lines with line count
- Exits 0 if clean, 1 if any warnings

## Integration

- **pre-commit-reviewer** — Runs the file length script as manual check #7
- **code-simplifier agent** — Uses these patterns when refactoring
- **Project linters** — Handle formatting; this handles style
