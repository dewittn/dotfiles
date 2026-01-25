---
trigger:
  files: ["README.md", "**/README.md", "docs/**", "doc/**"]
---

# Documentation Style Guide

Apply these rules when writing or editing documentation.

## Core Philosophy

**READMEs are entry points, not manuals.** Detailed information belongs in `docs/`.

## Writing Style

1. **No emojis.** Ever. In any documentation.
2. **No em dashes.** Replace with periods, commas, or colons.
3. **Semicolons: rare.** Default to periods or commas.
4. **No rhetorical questions.** Use declarative statements.
5. **Short paragraphs.** 1-4 sentences for readability.
6. **Active voice** preferred.
7. **Explain jargon** in plain terms.
8. **Neutral tone.** Don't inject artificial warmth or personality.

### Punctuation Patterns

| Avoid | Use Instead |
|-------|-------------|
| `all volunteers—working on passion` | `all volunteers working on passion` |
| `This hit a wall—phase two collapsed` | `This hit a wall. Phase two collapsed.` |
| `one thing—consistency` | `one thing: consistency` |
| `What was the problem?` | `The problem was unclear.` |

## README Structure

```markdown
# Project Name

One-line description.

## Overview

1-3 paragraphs explaining what the project does and why it matters.
Adjust length based on project complexity. Include screenshots when they aid understanding.

## Why I Built This (optional)

[Only include if the overview doesn't already cover motivation]

## Quick Start

**Prerequisites**

- List only essential requirements

**Installation**

\`\`\`bash
# Copy-pasteable commands
\`\`\`

Use numbered steps for multi-step processes. Use bold labels, not headers (###) within Quick Start.

## Documentation

See the [docs](./docs) folder for detailed information:

- [Architecture](./docs/architecture.md)
- [Configuration](./docs/configuration.md)
- [Development](./docs/development.md)

## AI Usage

[Honest, specific statement about AI tool usage in development]

## License

[License type]
```

## What Goes Where

**README (concise)**
- What is this project
- How to get started quickly
- Where to find more info

**docs/ (detailed)**
- How everything works
- All configuration options
- Development setup details
- Architecture explanations

**Rule of thumb:** If someone needs to scroll past the fold to find basic info, the README has too much detail. Move it to docs/.

## docs/ Structure

Create a `docs/` folder with relevant files:

- **docs/README.md** (always) — Index with links to all doc files
- **docs/architecture.md** — System design, data flow, key decisions
- **docs/development.md** — Setup, workflow, testing, troubleshooting
- **docs/configuration.md** — All options, env vars, examples
- **docs/api.md** — Endpoints, formats, auth, errors

## Screenshots

- Place in `docs/images/` or `assets/`
- Use descriptive filenames: `dashboard-overview.png` not `screenshot1.png`
- Reference with relative paths
- Include alt text for accessibility

## AI Usage Section

Be honest and specific:
- Name the tools used (Claude Code, Copilot, etc.)
- Describe what AI helped with
- If AI wasn't used: "This project was developed without AI assistance."

## Why I Built This Section

Only include if the overview doesn't already explain motivation. When needed, use placeholder text for the user to fill in.
