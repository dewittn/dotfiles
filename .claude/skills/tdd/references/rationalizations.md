# Rationalizations

Common excuses for skipping verification gates, with rebuttals. When you catch yourself forming one of these reasons, stop and follow the gate.

| Rationalization | Rebuttal |
|----------------|----------|
| "This change is too small to test" | Small changes cause the most insidious bugs. If it's small, the test is small too. |
| "I'll write the tests after" | Tests written after implementation verify what you wrote, not what you need. They miss edge cases by design. |
| "The test would just be testing the framework" | Then the task doesn't need Red-Green-Refactor. Reassign the gate — don't skip testing entirely. |
| "It works on my machine / in my head" | That's not verification. Run the command. Read the output. |
| "I'm confident this is correct" | Confidence is not a gate. The whole point is external verification. |
| "Writing the test will take longer than the fix" | The test prevents re-fixing this same thing next week. Time spent now saves time later. |
| "This is just a refactor, nothing changed" | Then the existing tests still pass. Run them. If there are no tests, this isn't "just a refactor." |
| "The test environment isn't set up" | Setting up the test environment is part of the task. Don't skip verification because the infrastructure is missing. |
| "I already tested it manually" | Manual testing is not reproducible. If the gate requires automated verification, provide it. |
| "This is blocking other work" | Skipping verification doesn't unblock — it creates a landmine for whoever touches this next. |
