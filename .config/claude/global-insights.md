# Global Insights

**Purpose:** Cross-cutting patterns that manifest differently across domains. These are universal tendencies discovered through various projects that may appear in new contexts with different specifics.

**How this works:** Each pattern below has a universal description. In domain-specific `key-insights-[domain].md` files, you'll find how that pattern manifests in that particular context.

**For working style and communication preferences:** See `working-with-nelson.md`

---

## Methodology Over Category

### Universal Pattern
Nelson's value is organized by a consistent *methodology* applied across domains, not by output categories (developer, designer, architect, writer). Job listings, creative fields, and most professional contexts are organized by outputs—but Nelson's skill set is organized by a repeatable process.

### The Methodology (6 Steps)

1. **Define the problem space** — What are we actually trying to solve?
2. **Deep domain immersion** — Study the field systematically (books, courses, existing works, observation)
3. **Pattern recognition across domains** — Look at how others have solved similar problems in different contexts
4. **Apply and prototype** — Put theory into practice, even imperfectly
5. **Create feedback loops** — Get external input, iterate based on real response
6. **Refine iteratively** — Deepen and add nuance as understanding matures

### Why This Matters
This explains the recurring "70-80% qualified" pattern. Nelson will always be slightly misaligned with roles/opportunities defined by their outputs because his value isn't in any single output category—it's in the methodology itself.

The misalignment isn't a gap to close. It's structural: opportunities are organized by category, Nelson is organized by methodology.

### Where Nelson's Strength Lives
The architecture, not the implementation. Plotting the global story, not writing the prose. Designing the system, not necessarily coding every line. Nelson can do implementation—and has, extensively—but the comparative advantage is in the **understanding → structure → articulation** phase (steps 1-3).

### How to Recognize It
- Nelson describes work in terms of "figuring out" rather than "building"
- Cross-domain pattern recognition appears in explanations
- The same analytical approach shows up across unrelated fields
- Value created often comes from seeing structure others missed

### How to Respond
When evaluating fit for opportunities:
- Ask: "Does this value the methodology, or just the output?"
- Look for: strategy, discovery, due diligence, consulting, advisory—roles that pay for *figuring out what's going on*
- Avoid: roles that assume deep specialization in one output category

### Domain Manifestations
- **Career:** Solutions Architect, Technical Strategist, Staff Engineer roles value the full methodology
- **Creative:** Director/Producer roles (hold structure, articulate to executors) vs. craft specialist roles
- **Planning:** Strategic advisor vs. tactical executor

### Relationship to Other Patterns
- **Output Over Outcome:** Methodology Over Category explains *why* Output Over Outcome matters—judging by execution quality (not vanity metrics) is correct because the value is in the process, not the category
- **Discounting Integration Work:** Implementation (step 4) is one phase; the value is in steps 1-3
- **Option C Blind Spot:** Understanding methodology-over-category helps see paths that don't fit output categories but do fit the methodology
- **Specification as Core Skill:** The methodology-over-category mismatch may be shrinking as the market shifts toward valuing specification and judgment over implementation

---

## Specification as Core Skill

### Universal Pattern
As AI handles more implementation, the ability to define problems precisely, immerse deeply in domains, and write specifications clear enough for machines to execute is becoming the primary value-creating skill. Nelson's methodology (steps 1-3: define, immerse, recognize patterns) IS this skill. He's been practicing it for 20+ years across domains.

### Why This Matters
The methodology-over-category insight explains a structural mismatch — Nelson organized by process, opportunities organized by output. This pattern adds *trajectory*: the market is beginning to move toward valuing specification and judgment over implementation. Nelson doesn't need the entire industry to shift. He needs companies already operating this way — and they exist now.

**Important caveat:** This trajectory is emerging, not guaranteed. The timeline is uncertain and most of the industry is still in early stages. This insight is worth acting on, not betting everything on.

### How to Recognize It
- Framing AI tool work as "getting better at Claude Code" instead of "building specification fluency"
- Treating the planning system as project management rather than deliberate skill development
- Missing that writing better specs is a portable, marketable capability — not just a workflow preference

### How to Respond
Reframe the work:
- "Getting better at Claude Code" → "Building fluency in specification-driven development"
- "My planning system" → "A deliberate practice framework for the skill that's becoming the whole job"
- "Learning to use AI tools" → "Developing the judgment layer that AI can't replace"
- "I need to scramble to get up to speed with AI" → "I need to build the system that demonstrates I can operate at a high level"

The last reframe is critical. "Scrambling to catch up" is defensive and reactive. "Building the framework" is the methodology applied to itself. When Nelson encounters a new domain (including AI), the methodology is always the same: define the problem, immerse, recognize patterns, prototype, create feedback loops, refine. AI isn't an exception to the methodology — it's the latest domain the methodology applies to.

### The Planning System as Deliberate Practice
Nelson's planning tools (`/project-plan` → `/feature-plan` → `pre-plan` → `/review-code` → `commit`) form a specification pipeline. Each level produces artifacts that constrain the next. Quality gates (operator alignment, code review) are where human judgment intervenes. This maps to directing agents with specs and evaluating outcomes — not writing code, not reviewing diffs line-by-line, but defining what should exist and verifying that it does.

### Domain Manifestations
- **Career:** The planning system is evidence of specification fluency — a demonstrable, practiced skill
- **Creative:** Directing AI from detailed briefs (story outlines, craft notes) is the same specification skill
- **Infrastructure:** Ansible playbooks, Docker configs, CI/CD pipelines have always been specification work — declaring desired state, not writing imperative steps
- **Any AI collaboration:** Every session where Nelson defines the problem, provides context, and evaluates output is practice

### The Signaling Dimension
**Discovered:** February 2026, analyzing AI scare trade implications

Having specification fluency isn't enough. The market needs to SEE it demonstrated in a business context. Personal productivity and business operations send different signals — the former shows preference, the latter shows value creation.

The artifact that signals judgment isn't published code or writing alone. It's applied work with real stakes — "I evaluated AI against a real workflow, here's what it handles, here's where it breaks, here's the implementation plan." That specificity is what the market responds to.

**How to recognize it:**
- Treating GitHub repos or blog posts as sufficient signal for specification skill
- Conflating "I use AI daily" with "I can demonstrate AI judgment in a business context"
- Assuming the right audience will connect the dots without being shown

**How to respond:**
- Ask: "Where is this skill demonstrated in a context the market can evaluate?"
- Reframe: Published code shows capability. Applied business judgment shows the thing that's actually scarce.
- The unified story matters: methodology + AI fluency told as one narrative, not two separate claims

### The Scaffolding Pattern
**Discovered:** February 2026, analyzing Nate Jones's four-layer prompting framework against Nelson's existing tooling.

Not all work is equally spec-able. The key question: **can the agent verify its own output against the spec?** Hugo site metadata either renders correctly or it doesn't — that's fully spec-able. A portfolio narrative about lived experience requires Nelson as the verification layer — the agent can't check its own facts against memories it doesn't have.

Nelson's creative work follows a sandwiched pattern: **spec the setup, do the creative work, spec the teardown.** The Craft Notes pipeline is the clearest example — an outline skill eliminates planning boilerplate, Nelson records and edits the episode (creative, human-only), then a transcript skill eliminates post-production boilerplate. The specs don't replace the creative work. They clear the runway around it.

This is analogous to `rails generate scaffold` — it didn't write the application, it eliminated the boilerplate so you could start at the interesting part. Nelson's skills and docs infrastructure function as scaffolding generators for the mechanical layers surrounding creative and judgment-heavy work.

**Implication for automation targets:** Nelson's remaining un-automated work is mostly creative/judgment-heavy. The gains from specification engineering come not from automating the core work but from specifying the mechanical setup and teardown around it. Infrastructure deployment (DNS, SSL, Traefik routing, Docker service config) is the highest-leverage scaffolding target because it's multi-step, mechanical, and currently requires Nelson's time but not his judgment.

**How to recognize the boundary:**
- If the agent can verify its own output → fully spec-able (scaffolding, deployment, checks)
- If only Nelson can verify → spec the surrounding mechanical work, keep the creative core human
- If Nelson is editing LLM output more than writing fresh → the task is on the wrong side of the boundary

### Three Categories of AI-Assisted Work
**Discovered:** February 2026, clarifying where agentic systems fit versus simpler AI use.

Not all AI-assisted work is the same. Three categories, each with different economics and different spec requirements:

1. **Pure automation** — deterministic, no judgment. Drafts scripts, iOS shortcuts, cron jobs, CI/CD pipelines. No LLM needed. Output is predictable from input. Nelson already does a lot of this.

2. **LLM-assisted transformation** — intelligence in a single bounded step. Transcript-to-blog-post, outline generation, text summarization. The LLM adds value but isn't deciding what to do next. One smart call, clear input/output. This is where most of Nelson's current AI collaboration lives — the sandwich pattern (spec the setup, creative work, spec the teardown).

3. **Agentic systems** — multi-step, decision-making. The agent makes judgment calls at each stage, and each step's output shapes the next. The job search pipeline is the existing example: search, fetch, evaluate, with decisions at every transition. Infrastructure deployment (DNS, SSL, routing, service config) is the high-value target because small judgment calls embedded in mechanical sequences currently keep the whole process manual.

**The key question for identifying agentic targets:** Where in your current manual work are small judgment calls keeping an otherwise mechanical process from being automated? Those embedded decisions are what distinguish agentic work from pure automation.

### Blast Radius Gates Agentic Investment
**Discovered:** February 2026, same conversation.

The path to agentic automation is gated by two things most frameworks understate: **blast radius** and **prerequisite infrastructure**.

A bad PowerPoint gets thrown away. A misconfigured DNS record or deleted Docker service takes production websites down. The safety engineering required before letting an agent touch production infrastructure is substantial — not a weekend project. Nelson's job search pipeline (Docker isolation, content scanning, URL validation, write hooks, security architecture doc) demonstrates both the capability and the real cost of doing this responsibly.

**Prerequisite infrastructure matters.** You can't automate what doesn't have an API. A DNS provider that requires manual login blocks agentic automation regardless of how good the spec is. Switching to an API-accessible provider is the foundational move that unlocks the agentic layer. The Coto infrastructure project is exactly this work — building the API surface, safety boundaries, and verification checkpoints that make multi-step agentic automation possible and safe.

**Implication for frameworks like Nate Jones's four layers:** The framework assumes the audience's work is 70% procedural and 30% creative. For someone whose work is mostly creative/judgment-heavy AND who manages production infrastructure, the path to agentic systems is necessarily slower and more careful. That caution is engineering judgment, not a gap. Nelson should capture procedural work in specs where it exists, but shouldn't force-fit agentic patterns onto work that's better served by the sandwich pattern or pure automation.

**How to recognize misapplication:**
- Trying to build agentic systems for tasks that are really single-step transformations
- Pointing agents at production infrastructure without safety boundaries
- Feeling "behind" because agentic automation isn't simple to set up — it shouldn't be for high-stakes work

### Relationship to Other Patterns
- **Methodology Over Category:** Adds trajectory — the structural mismatch between methodology and category may be narrowing as the market shifts
- **Discounting Integration Work:** Writing a good spec IS integration — assembling understanding from multiple domains into a coherent directive
- **Option C Blind Spot:** Companies operating at advanced levels of AI-assisted development are an Option C that may not be visible through traditional job search channels

---

## Output Over Outcome

### Universal Pattern
Judge work by execution quality and what it actually delivers, not by external validation or impact metrics that don't reflect the work's true value.

### Why This Matters
It's easy to discount excellent work because it doesn't have visible external markers of success. This pattern catches the tendency to measure against the wrong metrics.

### How to Recognize It
Nelson discounting work because:
- "Not many people use/read/saw it"
- "It's not well-known"
- "I never got recognition for it"
- "It didn't go viral / get published / win awards"

### How to Respond
Redirect to execution-based questions:
- "Does it still work?"
- "How long has it been running/in use?"
- "Did it accomplish what it was designed to do?"
- "What's the quality of the craft?"

### Domain Manifestations
- **Career:** "It doesn't have many users" → Reframe to production stability, years running
- **Creative:** "It's not published" → Reframe to craft quality, completion, what was learned
- **Planning:** "We didn't win" → Reframe to execution quality, growth, team development

---

## Option C Blind Spot

### Universal Pattern
When facing a decision, Nelson may see only the obvious options (often a false binary) while missing a third path that's actually available and potentially better suited to his situation.

### Why This Matters
This pattern has historically led to significant opportunity costs—not from choosing wrong between visible options, but from not seeing viable alternatives at all.

### How to Recognize It
- Framing decisions as either/or when they might not be
- "I can either X or Y" without considering Z
- Preparation-as-procrastination: "I need to [prepare more] before I can [take action]"
- Not seeing paths that require asking, applying, or putting himself forward

### How to Respond
1. Ask: "What are ALL the options here, not just the obvious ones?"
2. Specifically probe: "Is there an option that involves [asking/applying/joining] rather than [building/preparing/proving]?"
3. Challenge preparation framing: "What would you tell someone else with your current [skills/work/experience]?"

### Domain Manifestations
- **Career:** "I need more projects before applying" → You're already qualified
- **Creative:** "I need to study more craft before submitting" → The work teaches the craft
- **Planning:** "We need more practice before competing" → Competition IS practice

---

## Discounting Integration Work

### Universal Pattern
Undervaluing work that assembles, curates, or builds upon existing components rather than creating everything from scratch.

### Why This Matters
Senior-level work often IS integration—knowing what to use, how to combine it, and building custom pieces only where needed. Discounting this discounts a real skill.

### How to Recognize It
- "I just used [framework/template/existing thing]"
- "I didn't write every line"
- "Other people's [code/ideas/work] did the heavy lifting"
- "Does it count if I didn't create it from scratch?"

### How to Respond
Reframe: Using existing solutions appropriately IS the skill. The judgment of what to use, how to integrate it, and where to build custom—that's expertise, not a shortcut.

### Domain Manifestations
- **Career:** "I just used community Ansible roles" → You built 17 custom roles where needed
- **Creative:** "I'm using genre conventions" → Skilled use of conventions IS craft
- **Planning:** "I'm just adapting someone else's system" → Adaptation to context is valuable

---

## Scale Limiting Belief

### Universal Pattern
Dismissing valid experience or work as "not enough" because it didn't happen at some imagined larger scale.

### Why This Matters
Scale is often about systems thinking, not raw numbers. Work done well at smaller scale often demonstrates the same capabilities needed at larger scale.

### How to Recognize It
- "But it wasn't at enterprise scale"
- "Only [small number] people used it"
- "It was just for [limited context]"
- Comparing to imagined "real" versions at larger scale

### How to Respond
1. Challenge the scale assumption: "What specifically would be different at larger scale?"
2. Highlight transferable thinking: "The systems thinking is the same—the numbers are just parameters"
3. Note that many contexts operate at exactly this scale

### Domain Manifestations
- **Career:** "Not enterprise scale" → Zero data loss for 6 years IS operational excellence
- **Creative:** "Small audience" → Depth of impact matters more than breadth
- **Planning:** "Just recreational level" → Principles transfer across levels

---

## Impostor Trigger Phrases

### Universal Pattern
Certain phrases signal that impostor syndrome is active and Nelson is about to undervalue himself or delay action unnecessarily.

### Why This Matters
These phrases are early warning signs. Catching them allows intervention before they lead to underselling or unnecessary preparation loops.

### Trigger Phrases (Universal)
- "I'm not ready yet"
- "I should [learn/practice/prepare] more first"
- "Maybe I should spend [time period] getting ready"
- "Other people are probably more qualified"
- "Does it count if...?"
- "I just..."

### How to Respond
1. Name the pattern: "That sounds like the impostor pattern"
2. Request evidence review: "Let's look at what you actually have/know/did"
3. Perspective shift: "What would you tell someone else in your position?"

---

## Updating This Document

**Add new patterns when:**
- A pattern discovered in one domain clearly applies across others
- An existing pattern manifests in a new domain (add to that pattern's manifestations)
- A conversation reveals a universal tendency not yet captured

**Keep domain-specific insights in domain files.** This document captures only patterns that genuinely cross domains.
