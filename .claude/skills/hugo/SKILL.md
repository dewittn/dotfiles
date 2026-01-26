---
name: hugo
description: Hugo static site development patterns. Consult when working on Hugo projects for dev server, builds, and common workflows.
---

# Hugo Development

Lightweight orientation for Hugo static site development. Consult when starting dev servers, building sites, or working with Hugo projects.

## Dev Server

When asked to "spin up the dev server", "start the server", or similar phrases:

```bash
hugo server -D --bind 0.0.0.0
```

**Run as a background task** using `run_in_background: true`.

| Flag | Purpose |
|------|---------|
| `-D` | Include draft content |
| `--bind 0.0.0.0` | Accessible from other devices on network |

The server will be available at http://localhost:1313.

## Project Setup

Hugo projects should have this in `.claude/settings.json`:

```json
{
  "permissions": {
    "allow": [
      "Bash(hugo *)"
    ]
  },
  "hooks": {
    "Stop": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "pkill -f 'hugo server' 2>/dev/null || true"
          }
        ]
      }
    ]
  }
}
```

| Setting | Purpose |
|---------|---------|
| `Bash(hugo *)` | Allow Hugo commands without prompting |
| `Stop` hook | Kill dev server when session ends (fallback) |

## Build Commands

```bash
# Production build
hugo --minify --environment main

# Staging build
hugo --minify --environment dev

# Docker build (common pattern)
docker build --build-arg ENVIRONMENT=main -t <project-name> .
```

## Project-Specific Overrides

Individual projects may have different configurations. Always check the project's `CLAUDE.md` for:

- Environment names (may differ from `main`/`dev`)
- Additional build flags
- Custom server flags
- Docker build arguments

## Common Patterns

### Environment-Based Config

Hugo projects often use `/config/` directory structure:

```
config/
  _default/     # Base configuration
  main/         # Production overrides
  dev/          # Staging overrides
```

### Bilingual Sites

Content typically under `/content/{lang}/`:

```
content/
  en/
  es/
```

## Agent Behavior

1. **Starting dev server** — Always use `run_in_background: true`
2. **Before building** — Check project CLAUDE.md for environment names
3. **Docker builds** — Verify correct `ENVIRONMENT` arg for target deployment
