---
name: feature-idea
description: >
  Capture feature ideas into the projects inbox with a consistent format.
  Use when the operator wants to save a raw idea for later — mid-conversation
  or with inline text. Invoked via /feature-idea. Also trigger when the operator
  says things like "I should write this down", "add this to the inbox",
  "save this idea", or "capture this for later".
---

# Feature Idea Capture

Write-first: generate the idea file immediately, then present it for review. The idea is on disk before any confirmation — speed of capture is the priority.

## Workflow

### Step 1: Determine Input Mode

Two modes based on how the skill is invoked:

- **With args** (`/feature-idea Add dark mode support for the dashboard`): Use the provided text as the idea.
- **Without args** (invoked mid-conversation): Summarize the current conversation into a concise idea.

### Step 2: Resolve Project

Derive project name from the current working directory's folder name. Validate against `~/Programing/dewittn/agentic-docs/projects/`.

- **Match found**: Use it silently — no question asked.
- **No match**: List existing project directories and ask the operator which project this belongs to.
- **Operator override**: If the operator names a different project, validate that name instead.

### Step 3: Multi-Idea Detection

Before writing, assess: does the input describe one feature or several?

- **Single idea**: Proceed to Step 4.
- **Multiple ideas**: Flag it — "This sounds like N separate features. Want me to split them into separate idea files?" If yes, repeat Steps 4-5 for each. If no, capture as one.

### Step 4: Write Immediately

1. Generate a title from the idea
2. Create a slug from the title (kebab-case, e.g., `dark-mode-dashboard.md`)
3. Run `date +%Y-%m-%d` for the date (never generate manually)
4. Fill the template at [references/idea-template.md](references/idea-template.md)
5. Write the file to `~/Programing/dewittn/agentic-docs/projects/inbox/<slug>.md`

Do not ask for confirmation before writing. The file must exist on disk before presenting it.

### Step 5: Present and Refine

Show the operator what was written. Offer to refine — update the file in place with any changes. If the operator says it looks good, done.

## Integration

This skill feeds into `/feature-plan` Phase 0, which checks the inbox for pending items. The standardized format ensures feature-plan can reliably parse and suggest project matches.

Output location: `~/Programing/dewittn/agentic-docs/projects/inbox/`
