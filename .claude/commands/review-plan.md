# Plan Review

Review a plan before implementation by analyzing the history and context of affected files.

**Usage**: `/review-plan <plan-file>`

## Process

### 1. Parse the Plan

Read the plan file (typically `PLAN.md` from plan mode) and identify:
- Files that will be modified
- Files that will be created
- Files that will be deleted
- Key functions/classes being changed

### 2. Run History Search

For each affected file, run the **history-search** agent to gather:
- When the file was created and by whom
- Recent modification history
- Any reverts or bug fixes in the file's history
- Files commonly modified together (hidden dependencies)
- Warning signs in commit messages

Run history-search on multiple files in parallel using the Task tool.

### 3. Analyze Dependencies

Check for:
- Files that are frequently co-modified with the affected files
- Test files that correspond to affected files
- Config files that might need updates
- Import/require relationships

### 4. Generate Report

```markdown
## Plan Review: [plan-file]

### Affected Files
| File | Status | Age | Churn | Last Modified |
|------|--------|-----|-------|---------------|
| path/to/file.ts | modify | 6 months | high | 2024-01-15 |
| ... | ... | ... | ... | ... |

### History Findings

#### [filename]
- **Summary**: [One-line history summary]
- **Red flags**: [Any reverts, warnings, or complex evolution]
- **Co-modified with**: [Related files that often change together]

[Repeat for each affected file]

### Dependencies Discovered
- [Files not in the plan that may also need changes]
- [Test files that should be updated]

### Recommendations
- [ ] [Specific concerns to address before implementing]
- [ ] [Files to read/understand before proceeding]
- [ ] [Questions to resolve]

### Verdict
[PROCEED | INVESTIGATE FIRST | RECONSIDER APPROACH]
- PROCEED: History is clean, plan looks safe
- INVESTIGATE FIRST: Some concerns to understand before implementing
- RECONSIDER APPROACH: Significant red flags that suggest the plan may conflict with past decisions
```

## Notes

- This is advisory, not blocking. Red flags mean "understand before proceeding," not "don't proceed."
- If a file has been reverted multiple times, there's likely a reason the code is the way it is.
- High churn files deserve extra scrutiny — they're often more complex than they appear.
- Co-modified files are hidden dependencies — if A always changes with B, your plan should probably touch both.
