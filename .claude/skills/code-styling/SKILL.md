---
name: code-styling
description: Apply consistent coding style patterns when writing or reviewing code. Complements linters with higher-level style decisions.
---

# Code Styling Profile

**Read first:** `~/.claude/docs/coding/style-guide.md`

## When to Invoke

- **Refactor phase** — After code is working, before final commit
- **Cleanup requests** — "Clean this up", "apply my style", "refactor"
- **Code review** — When suggesting improvements to existing code

During initial implementation, focus on getting things working. Apply these patterns when polishing.

## Agent Behavior

1. **Guard clauses over nesting** — Flatten control flow with early returns
2. **Single-line if** — For simple guards and assignments (JavaScript)
3. **Data-driven design** — Prefer configuration over hardcoded branches
4. **Extract at 3+** — Only extract when pattern repeats 3+ times
5. **Project standards win** — CLAUDE.md and linter configs take precedence

## Integration

This skill complements:
- **code-simplifier agent** — Uses these patterns when refactoring
- **pre-commit-reviewer** — Catches violations of these patterns
- **Project linters** — Handle formatting; this handles style
