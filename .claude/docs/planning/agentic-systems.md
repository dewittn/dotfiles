# Planning Guide: Agentic / LLM Systems

Additional planning requirements when the project involves LLM agents, tool use, or AI-driven pipelines.

Consulted by the **pre-plan** skill during Stage 1.

## Intelligence Boundary Map

The plan must explicitly identify which steps require LLM judgment and which are deterministic. For each step, answer:

- **Does this step need to think, or just do?**
- If it can be written as a `for` loop, it belongs in Python — not an LLM call.

The plan should clearly state: "The LLM handles X (judgment). Python handles Y (execution)." If this boundary isn't clear, the architecture isn't ready.

## Agent Design Constraints

For each agent in the system, the plan must specify:

- **What tools does this agent have?** Fewer tools = fewer failure modes. Don't give an agent capabilities just because it's a common pattern.
- **What does the agent always need?** If it always needs something (memory, context, config), inject it into the prompt. Don't make it spend a turn asking for it.
- **Is this one agent or multiple?** If an agent needs to reflect on its own earlier decisions, keep it in the same conversation. Don't split a continuous thought process across agents that can't see each other's reasoning.

The pattern that works: **Agent thinks → Python executes → Agent reflects (same conversation).** Python owns the numbers, the agent owns the interpretation.

## Observability Plan

"Tests pass" tells you the code works. It does not tell you whether the agent's judgment is sound.

The plan must specify:

- **What conversation/reasoning output is saved?** Full LLM call history, not just final output.
- **Where is it saved?** In the run directory, in a reviewable format.
- **Is it treated as disposable or as a deliverable?** It's a deliverable. These files are the primary interface for verifying the system's intelligence.

## Local Model Compatibility

If the system should work with local models (Ollama, etc.), the plan must account for:

- Reduced tool-use reliability — minimize required tool calls per turn
- Context window limitations — token-efficient formats for injected content
- Test strategy — how will you verify the agent works on both local and production models?

## Prompt and Memory Format

All prompts, memory files, and agent configuration must live in dedicated files, not inline in code. Specify:

- File format (markdown preferred for anything a human might edit)
- File location (predictable, clearly named)
- Whether the file is operator-editable between runs

If the operator might want to tweak the agent's behavior without changing code, the relevant file must be in a human-friendly format.
