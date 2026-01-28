# Code Review Suite

Run a comprehensive review of recent changes. Use this after implementation is complete and working.

## Process

Run these four agents **in parallel** using the Task tool:

1. **security-reviewer** — Scan for vulnerabilities (injection, XSS, secrets, auth issues)
2. **pre-commit-reviewer** — Check code quality, run linters, find debug artifacts
3. **test-enforcer** — Identify missing test coverage and edge cases
4. **docs-compliance-reviewer** — Check changes against documented rules and decisions

## Instructions

1. First, identify the scope of changes to review:
   - Check `git status` and `git diff` to see what's changed
   - Focus on modified/added files, not the entire codebase

2. Launch all three agents in parallel with the Task tool:
   - Each agent should receive the list of files to review
   - Each agent produces its own report

3. After all agents complete, provide a **consolidated summary**:

```markdown
## Review Summary

### Security
[Key findings from security-reviewer, or "No issues found"]

### Code Quality
[Key findings from pre-commit-reviewer, or "Ready to commit"]

### Test Coverage
[Key findings from test-enforcer, or "Coverage looks good"]

### Documentation Compliance
[Key findings from docs-compliance-reviewer, or "No conflicts with documented rules"]

### Action Items
- [ ] [Specific items that should be addressed]
- [ ] [Prioritized by severity]

### Verdict
[READY TO COMMIT | ADDRESS ISSUES FIRST]
```

## Notes

- Keep the summary concise. Details are in the individual agent reports.
- Prioritize critical and high-severity issues in the action items.
- If no issues found across all reviewers, say so clearly.
