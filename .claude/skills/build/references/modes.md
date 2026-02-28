# Execution Modes

Three modes for how work is delegated during implementation. All share the same plan, task list, and quality gates — only the delegation strategy differs.

## main (default)

Single agent builds everything. Plan mode produces the implementation plan, then the same agent executes each task sequentially.

- Simplest model — no coordination overhead
- Best for features touching few files or requiring tight coupling between steps
- Invocation: `/build 003` or `/build 003 main`

## sub

Orchestrator dispatches fresh subagents per task via the Task tool. Each subagent gets a focused prompt with the task description, relevant feature doc context, and gate assignment. No peer communication — the orchestrator manages all coordination.

- Use `general-purpose` subagent type for broad tool access
- Orchestrator waits for each subagent to complete before dispatching dependent tasks
- Independent tasks can be dispatched in parallel
- Subagents return results to the orchestrator, who verifies gate compliance
- Best for features with independent, well-scoped tasks
- Invocation: `/build 003 sub`

## team

TeamCreate with shared TaskList. Agents join the team, claim tasks from the shared list, and self-coordinate via peer messaging.

- Uses TeamCreate to establish the team and shared task list
- Agents claim unassigned, unblocked tasks via TaskUpdate
- Peer messaging via SendMessage for coordination
- Team lead monitors progress and resolves blockers
- Most autonomous model — agents decide task order within dependency constraints
- Experimental — no TeamCreate usage exists in codebase yet
- Invocation: `/build 003 team`

## Common Across All Modes

- **TaskList**: Claude Code's TaskList is the shared task management layer
- **Gate enforcement**: Each task carries its gate assignment from the feature doc. TDD skill auto-triggers on code-producing tasks.
- **Review limit**: 3-cycle review limit per task, then escalate to operator
- **Final quality gate**: `/review-code` runs before the last commit
- **Failure handling**: If a task fails its gate after 3 cycles, pause and ask the operator rather than proceeding with broken work
