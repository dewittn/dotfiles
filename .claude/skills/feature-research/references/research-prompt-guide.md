# Research Prompt Guide

Guidance for crafting adaptive research prompts in Phase 2. Not a fixed template — the prompt shapes itself to the specific unknowns.

## Prompt Dimensions

Choose dimensions based on what the operator genuinely doesn't know:

| Dimension | When to include | Example question |
|-----------|----------------|------------------|
| Established approaches | New problem domain | "How do teams typically solve X?" |
| Tooling/libraries | Unknown ecosystem | "What's available, what's actively maintained?" |
| Common pitfalls | Any unfamiliar territory | "What goes wrong when teams try X?" |
| Architectural implications | Touches system design | "How does X affect the existing architecture?" |

Not every research prompt needs every dimension. A feature using a well-known tool but in an unfamiliar pattern might skip tooling entirely and focus on architectural implications.

## Adaptive Depth

Match depth to the operator's knowledge gap:

**Familiar territory** (operator knows the basics):
- Skip fundamentals
- Ask about edge cases, failure modes, scaling concerns
- Focus on "what experienced practitioners wish they'd known"

**Completely new** (operator has no prior exposure):
- Start with established patterns and why they exist
- Ask for concrete examples of each approach
- Request trade-off comparisons between alternatives

**Partially known** (operator knows adjacent areas):
- Bridge from what's known to what's unknown
- Ask about differences from the adjacent domain
- Focus on where intuition from the known domain breaks down

## Prompt Structure Guidance

Frame the research request for Claude AI:

1. **Set context** — include what the feature doc says about this feature (the "what" and "why")
2. **State what's known** — prevents the research from rehashing basics
3. **Specify unknowns** — direct questions, not "tell me everything about X"
4. **Ask for trade-offs** — "what are the trade-offs between A and B?" beats "what's the best practice?"
5. **Request concrete examples** — code snippets, config samples, real-world usage over abstract advice

## Anti-Patterns

- **Kitchen-sink prompts**: Asking about everything at once produces shallow answers. Focus on 2-3 dimensions per prompt.
- **Leading questions**: "Isn't X the best approach?" biases the research. Ask open-ended questions.
- **Abstract-only**: "Tell me about authentication patterns" vs "How would you add JWT auth to an Express API that currently uses session cookies?" — specificity gets actionable answers.
- **Ignoring project context**: Research without the feature doc's constraints produces generic advice. Always ground the prompt in the specific project.
