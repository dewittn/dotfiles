# Project Planning

A conversational skill for thinking through an entire project — its architecture, business model, technical stack, and development strategy — before writing any code. Use this when starting a new project or rethinking the foundations of an existing one.

**Usage**: `/project-plan <optional description of what you want to build>`

## Purpose

The operator has a project idea but hasn't mapped out all the dimensions needed to build it. This skill helps them think through the full picture — not just the technical architecture, but the business positioning, development approach, target audience, and launch strategy.

The deliverable is a **project plan directory** containing a global overview and individual documents for each facet of the project. These documents grow organically across sessions as thinking matures.

Project plans live at `~/.claude/docs/projects/<project-name>/`, where `<project-name>` is derived from the current working directory's folder name. This keeps planning docs in a central location (symlinked to the Pensieve project-manager) rather than scattered across project repos.

The project plan becomes the foundation for **feature planning** (`/feature-plan`) and **implementation planning** (`pre-plan`).

## How This Works

This is a long-running planning process that spans multiple sessions. The project plan directory is the persistent state — every session starts by reading what exists and continuing from there.

**You are not filling out a template. You are helping the operator think through their project from every angle.**

## Phase 0: Locate the Project Plan

Derive the project name from the current working directory's folder name (e.g., if cwd is `/Users/dewittn/Projects/my-tool`, the project name is `my-tool`). The plan directory is `~/.claude/docs/projects/<project-name>/`.

Before anything else, check `~/.claude/docs/projects/` for existing project directories. This gives context on what's already being tracked.

**If a plan directory exists for this project:**
1. Read `README.md` and all existing facet documents in the project directory
2. Present the current planning status table
3. Ask: "Which facet do you want to work on, or is there something new to explore?"
4. If the operator provided a description with the command, treat it as direction for this session (e.g., `/project-plan let's figure out the auth model` → jump to the relevant facet)

**If no plan directory exists for this project:**
- Note any existing projects in `~/.claude/docs/projects/` for context (don't list them unprompted, but be aware)
- Continue to Phase 1
- If the operator provided a description, use it as the seed

## Phase 1: Project Discovery

This only happens on the first invocation. The goal is to understand the project broadly and discover which facets need planning.

### Capture the Vision

Start with the operator's description and explore:

- **What is this?** — One sentence. What does it do?
- **Who is it for?** — Target users, audience, community
- **Why build it?** — What problem does it solve? What's the motivation?
- **What exists already?** — Competitors, alternatives, prior art
- **What's the ambition level?** — Side project, serious product, commercial venture, open source tool?

Don't interrogate. Have a conversation. Let the operator's energy guide the depth.

### Discover Facets

Based on the conversation, propose which facets of the project need their own planning documents. Common facets include:

- **Technical Architecture** — Stack choices, system design, data model
- **Frontend** — Framework, design system, user experience
- **Backend** — API design, services, infrastructure
- **Data & Storage** — Database, caching, data flows
- **Business & Positioning** — Open source vs. commercial, pricing, market fit
- **Users & Auth** — User model, authentication, authorization, capacity
- **Development Strategy** — Build approach, agents, difficulty, team/solo
- **Time & Priorities** — Operator time commitment, where human input is essential vs. agent-delegable, scheduling, priority ranking against other projects
- **Infrastructure & Deployment** — Hosting, CI/CD, environments
- **Launch & Distribution** — Marketing, docs, community, go-to-market

But not every project needs all of these. A small CLI tool might only need Technical Architecture and Development Strategy. A SaaS product might need all of them. **Let the project dictate the facets.**

The operator can also propose facets you didn't list, or merge/split facets as they see fit.

### Produce the Global Doc

Create `~/.claude/docs/projects/<project-name>/README.md` using the template at [references/project-plan-overview-template.md](references/project-plan-overview-template.md).

This document captures the project vision and serves as the hub for all facet documents.

After writing the global doc, ask: **"Want to dive into one of these facets now, or let this sit?"**

## Phase 2: Facet Deep-Dive

When the operator chooses a facet (either after Phase 1 or in a returning session), run a focused conversation on that topic.

### Before You Start

Read all existing facet documents, not just the target one. Context from other facets informs the current conversation. If the target facet already has notes from cross-pollination, start from those — don't re-ask questions that have been answered.

### During the Conversation

Each facet is different, but the general approach is:

1. **Understand the current thinking** — What has the operator already decided? What's still open?
2. **Ask the questions that matter for this facet** — Technical choices, tradeoffs, constraints
3. **Surface the hidden assumptions** — What are they taking for granted that could go wrong?
4. **Identify dependencies on other facets** — "This auth model implies a specific user model — have you thought about that?"
5. **Capture decisions and open questions** — Decisions are valuable. Open questions are equally valuable.

Match the depth to the complexity. A database choice for a simple CLI might be one paragraph. A data model for a multi-tenant SaaS might be a full document.

### Write the Facet Document

Use the template at [references/project-plan-facet-template.md](references/project-plan-facet-template.md). Save it to `~/.claude/docs/projects/<project-name>/<facet-name>.md`.

## Phase 3: Cross-Pollination

This happens continuously during any facet conversation. When something comes up that belongs in a different facet's document:

1. **Note it in the relevant facet doc** — Add it under a "Notes" section
2. **Don't derail the current conversation** — Capture the insight and continue with the current facet
3. **If it's a significant cross-cutting concern**, flag it: "This has implications for [other facet] — want to switch focus, or capture this and continue?"

If the facet document doesn't exist yet, create it with just the notes section. Update its status to "Has Notes" in the README.

## Phase 4: Update Status

At the end of every session, update the planning status table in the project's `README.md`:

- **Not Started** — No document exists
- **Has Notes** — Document exists with cross-pollinated notes but no focused session
- **In Progress** — Focused session started but not complete
- **Complete** — Operator is satisfied with this facet's planning
- **Revisit** — Was complete but new information means it needs another look

## Time & Priorities Facet

This facet deserves special attention. Assume the operator works solo with coding agents — the agents handle most programming, but the operator's time and judgment are the bottleneck. When working on this facet (or when time/priority concerns surface in other facets), focus on:

- **Where is operator input essential?** — Design decisions, business judgment, user experience choices, approval gates. These are the tasks only the operator can do.
- **What can agents handle independently?** — Boilerplate, tests, migrations, refactoring, CI/CD setup. Flag these as low-operator-involvement.
- **What are the high-input phases?** — Early architecture, design review, and launch typically need the most operator time. Mid-build may need less.
- **How does this project rank against other active projects?** — The operator has multiple projects. Help them think about priority and sequencing realistically.
- **What's the minimum viable commitment?** — If the operator can only give 2 hours a week, what's the realistic trajectory? Don't assume unlimited availability.

## Guiding Principles

- **Follow the energy.** If the operator wants to talk business before tech, talk business. The facets are tools for organizing output, not a prescribed order of operations.
- **Cross-pollinate aggressively.** The most valuable planning insights often come from unexpected connections between facets. When you hear one, capture it immediately.
- **Name what you don't know.** Open questions are a feature, not a bug. Marking something as "needs more thought" is better than glossing over it.
- **Keep implementation out of it.** This is project-level thinking. "We'll use PostgreSQL" is a project decision. "The users table will have these columns" is implementation — save it for feature-plan or pre-plan.
- **The documents are living.** They'll be updated as thinking evolves. Don't optimize for a perfect first draft.
- **Respect the operator's context.** They may know things about the market, the business, or the constraints that you can't see. When they make a decision that seems odd, ask why rather than pushing back.
