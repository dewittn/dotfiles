---
name: tdd
description: >
  Verification gates for implementation tasks. Auto-trigger on code-producing tasks during
  the build phase (after /build operator alignment). Also invoked via gate tags in plan
  output ([Red-Green-Refactor], [Command & Confirm], [Usage]).
  Does NOT apply to docs, planning artifacts, or prototype work — those get Usage or
  are exempt. Use when writing code, creating config, or implementing any task that carries
  a verification gate tag.
---

# TDD

Verification gates for implementation tasks. Every task has a "done" criterion — the gate defines what it is and how to prove it.

## Verification Gates

Three gates, ordered by decreasing automation and increasing human judgment.

### Red-Green-Refactor (hard gate)

Code with testable behavior. Write a failing test first, make it pass, then refactor.

1. **Red** — Write a test that fails. The test defines "done."
2. **Green** — Write the minimum code to pass the test. Nothing more.
3. **Refactor** — Clean up while tests stay green.

No production code without a failing test first. The test is the spec.

**Good:**
```
# Write test for new parse_config function
# Run test → fails (function doesn't exist)
# Implement parse_config with minimal code
# Run test → passes
# Refactor: extract validation helper
# Run tests → still green
```

**Bad:**
```
# Write parse_config implementation
# Write tests after the fact
# Tests pass on first run (they test what was written, not what is needed)
# Ship it
```

For testing philosophy, good/bad test patterns, and the anti-horizontal-slice rule, see [references/testing-craft.md](references/testing-craft.md). For mocking guidelines, see [references/mocking.md](references/mocking.md). For designing testable interfaces, see [references/interface-design.md](references/interface-design.md).

### Command & Confirm (strong expectation)

Config, infrastructure, and artifacts with a validator. The plan includes a specific command and expected output.

1. Run the verification command specified in the plan
2. Confirm the output matches expectations
3. If it doesn't match, investigate — don't tweak until it passes by coincidence

### Usage (baseline)

Documentation, planning artifacts, non-executable content. No automated gate — build it, commit it, move on. The operator verifies by using the output and reviewing the PR. This is the default for anything that doesn't fit the other gates.

## Gate Verification Function

For every gate except Usage, follow this sequence:

1. **Identify** — What is the gate? What does "done" look like?
2. **Run** — Execute the test, command, or evaluation
3. **Read** — Actually read the output. Don't assume success from exit codes alone.
4. **Verify** — Does the output match the expected result?
5. **Claim** — Only mark the task complete when verification passes

Do not skip steps. Do not mark a task complete before running verification.

## Debugging Mode

When a test or verification that should pass fails unexpectedly, stop guessing and follow this sequence:

1. **Investigate** — Read error messages, logs, stack traces. What actually happened?
2. **Analyze** — What patterns are visible? What changed since it last worked?
3. **Hypothesize** — Form a specific theory about the root cause
4. **Test** — Verify the hypothesis with a targeted check (not a random fix)
5. **Fix** — Apply the fix that addresses the root cause

**3-fix escalation rule:** If three attempted fixes fail, stop. The problem is likely architectural, not a local bug. Present the situation to the operator with findings and ask whether to continue or rethink the approach.

## Multi-Component Diagnostic

When a failure spans multiple components (API + database, frontend + backend, etc.):

1. **Log at boundaries** — Add logging at the interface between components
2. **Narrow the scope** — Identify which component is producing wrong output
3. **Fix locally** — Address the root cause in the offending component
4. **Remove diagnostic logging** — Clean up before committing

Narrow before fixing. Don't shotgun changes across components hoping one sticks.

## Prototype Exception

Exploratory and prototype work is exempt from verification gates:

- `frontend-prototype` skill workflows
- Design tool workflows (Pencil MCP, Figma)
- Spike/proof-of-concept tasks explicitly marked as exploratory

The operator can also exempt specific tasks during pre-plan alignment. Exemptions appear in the plan as `[Exempt: reason]`.

## Rationalizations

When a rationalization forms for skipping a gate, read `references/rationalizations.md`. Common excuses are cataloged with rebuttals.

## Integration

- **pre-plan** assigns gates to tasks during section-by-section review; **/build** incorporates them into the implementation plan
- **commit** skill handles the commit after verification passes
- **/review-code** is the final quality gate after all tasks complete — separate scope from per-task verification
- **code-styling** applies during the Refactor phase of Red-Green-Refactor
- **Reference guides** — `references/` contains craft guidance for testing philosophy, mocking, interface design, and refactoring. Read the relevant file when working through a Red-Green-Refactor gate.
