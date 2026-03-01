# Code Review Suite

Run a comprehensive review of recent changes. Use this after implementation is complete and working.

## Process

### Step 1: Identify Scope

Check `git status` and `git diff` to see what's changed. Focus on modified/added files.

### Step 2: Detect Project Capabilities

Before spawning agents, check what the project actually has:

**Test infrastructure** — Glob for:
- `{test,tests,spec}` directories
- `{jest.config.*,pytest.ini,vitest.config.*,.rspec}`
- `pyproject.toml` (then grep for `[tool.pytest]`)

**CI/CD artifacts** — Glob for:
- `.github/workflows/` directory
- `{Dockerfile,docker-compose*,.gitlab-ci.yml,Jenkinsfile}`

### Step 3: Spawn Agents

Launch agents **in parallel** using the Agent tool. Always spawn the core three; conditionally spawn the others based on Step 2.

**Always spawn:**
1. **security-reviewer** — Scan for vulnerabilities
2. **pre-commit-reviewer** — Check code quality, run linters, find debug artifacts
3. **docs-compliance-reviewer** — Check changes against documented rules

**Conditional:**
4. **test-enforcer** — Only when test infrastructure detected in Step 2
5. **cicd-reviewer** — Only when CI/CD artifacts detected in Step 2

Each agent receives the list of changed files.

### Step 4: Consolidated Summary

After all agents complete, provide a summary. Include sections only for agents that ran. For skipped agents, add a one-line note.

````markdown
## Review Summary

### Security
[Key findings from security-reviewer, or "No issues found"]

### Code Quality
[Key findings from pre-commit-reviewer, or "Ready to commit"]

### Documentation Compliance
[Key findings from docs-compliance-reviewer, or "No conflicts with documented rules"]

### Test Coverage
[If test-enforcer ran: key findings. If skipped: "No test infrastructure detected — skipped"]

### CI/CD
[If cicd-reviewer ran: key findings. If skipped: "No CI/CD configuration detected — skipped"]

### Action Items
- [ ] [Specific items that should be addressed]
- [ ] [Prioritized by severity]

### Verdict
[READY TO COMMIT | ADDRESS ISSUES FIRST]
````

## Notes

- Keep the summary concise. Details are in the individual agent reports.
- Prioritize critical and high-severity issues in the action items.
- If no issues found across all reviewers, say so clearly.
