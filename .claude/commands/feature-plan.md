# Feature Planning

A conversational skill for turning loose ideas into well-defined feature documents. Use this when the operator has an idea — or several — that they want to think through before building.

**Usage**: `/feature-plan <description of what you want to build>`

## Purpose

The operator often knows what they want but can't fully articulate it until challenged. This skill surfaces hidden assumptions, connects loosely related ideas, and produces a feature document that captures decisions, constraints, and open questions — before any implementation planning begins.

The deliverable is a **feature doc** that answers WHAT and WHY, not HOW. Implementation details may appear when they represent architectural constraints, but the goal is to define the problem space, not solve it.

The feature doc becomes the input artifact for the **pre-plan** skill, which handles implementation planning.

## How This Works

This is a conversation, not a template. The operator will start with something vague — a few bullet points, a half-formed idea, a problem they've noticed. Your job is to help them think it through by asking the right questions, not by filling in the blanks for them.

**You are not building a spec. You are helping the operator discover what they actually want.**

If the feature is small and well-defined, keep the process proportional. Not every feature needs four rounds of clarification. Match the depth to the complexity.

## Phase 1: Capture the Raw Idea

**Start the clock.** Before the conversation begins, create the feature doc file with just the header and date. This gives us a filesystem creation timestamp for tracking how long planning takes.

The operator's description is passed as the argument to this command. They may describe one feature or several. They may mix problems with solutions, or jump between abstraction levels. That's fine.

Your job in this phase:

- Listen for the core intent behind each idea
- Identify which ideas are actually separate features vs. parts of the same feature
- Note where the operator is confident vs. where they're hand-waving
- Do NOT start organizing yet — just absorb

When the operator has finished their initial dump, summarize back what you heard as distinct features or concerns. Ask: **"Is this everything, or is there more rattling around?"**

## Phase 2: Clarifying Questions

This is where the real work happens. For each feature or idea, ask questions that force concrete answers. Focus on:

### Placement and Boundaries

- Where does this sit in the existing system? What runs before it? What runs after?
- What triggers it? What does it produce?
- What is IN scope and what is explicitly OUT of scope?

### Inputs and Outputs

- What data does this feature need? Where does it come from?
- What does it produce? Who or what consumes the output?
- What format does the output need to be in? (Think about the operator, not just the code.)

### Decisions That Constrain Implementation

- Are there architectural constraints the implementation must respect? (e.g., "this must run in Docker," "this uses the existing provider abstraction," "no new dependencies")
- Is there a specific technology, service, or tool that's already chosen?

### Edge Cases and Failure Modes

- What happens when the input is missing, empty, or malformed?
- What happens when an external service is unavailable?
- What should degrade gracefully vs. what should fail loudly?

### The "What If a Reasonable Developer Got This Wrong" Test

For each feature, ask yourself: could a competent developer read this description and build something that technically satisfies it but isn't what the operator wants? If yes, the description is still ambiguous. Ask the question that would resolve it.

**Important:** Don't ask all these questions at once. Ask the 2-3 most important ones, let the operator respond, and let their answers guide the next round. This is a conversation, not an interrogation.

## Phase 3: Iterative Refinement

After the first round of clarification, draft the feature doc and share it. The operator will read it and say "wait, actually..." — this is the most valuable part of the process. Each tweak is a design decision being surfaced.

When the operator proposes a change or addition:

- Incorporate it into the doc
- Check whether it affects other features already defined (dependencies, ordering, conflicts)
- Ask whether the tweak suggests other related changes they haven't mentioned yet

Keep iterating until the operator says it feels complete. There's no fixed number of rounds.

## Phase 4: Dependency Mapping and Implementation Order

Once features are defined, identify:

- Which features depend on others being built first?
- Which are independent and could be built in any order?
- Is there a natural sequence that minimizes rework?

Present this as a suggested implementation order with brief rationale. The operator may reorder based on priorities you can't see (deadlines, motivation, risk tolerance).

## The Feature Doc

### File Location and Naming

Feature docs live in the project's `docs/` directory with a `feature-plan-` prefix and numeric ordering:

```
docs/
  feature-plan-001-feature-name.md
  feature-plan-002-another-feature.md
  feature-plan-003-third-feature.md
```

Check for existing `feature-plan-*` docs to determine the next number. Feature docs can be removed once the feature is fully implemented — they serve as living design documents, not permanent records. The content in the feature doc can also inform the documentation updates that happen during implementation.

### Document Structure

Use the template at [references/feature-plan-template.md](references/feature-plan-template.md).

## Phase 5: Log the Time

When the operator signals the feature doc is complete, log the planning session:

1. Check the feature doc's filesystem timestamps — created = start, last modified = end
2. Ask: **"This session took about [duration]. Want me to log it?"**
3. If yes, append a line to `~/.claude/docs/planning/planning-log.md`:

```
| YYYY-MM-DD | project-name | feature-name | duration |
```

Create the log file with a header row if it doesn't exist. The planning log is persistent and feeds into quarterly reviews for capacity planning.

## Guiding Principles

- **Ask, don't assume.** If something is ambiguous, ask. Don't fill in gaps with reasonable defaults — the operator's defaults are often different from yours and the whole point of this skill is to surface those differences.
- **Follow the tweaks.** When the operator says "oh, and also..." or "wait, actually..." — that's a signal they're discovering something. Slow down and explore it.
- **Keep implementation out of it (mostly).** The feature doc defines the problem. Implementation planning is a separate step. However, if the operator states an implementation constraint ("this must use the existing agent loop," "no MCP servers"), capture it — that's a decision, not a solution.
- **Name the open questions.** Not everything needs to be resolved in this stage. Explicitly marking something as "open" is more useful than pretending it's decided.
- **Respect the operator's energy.** If they're on a roll and ideas are flowing, keep up. If they're slowing down, summarize what you have and ask if it's enough to start with. The goal is to capture the thinking while it's fresh, not to be exhaustive.
