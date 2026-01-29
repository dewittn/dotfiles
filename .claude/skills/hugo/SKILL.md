---
name: hugo
description: Hugo static site development. **Always consult this skill when working on any Hugo project** — starting dev servers, building sites, reviewing pages, or making changes.
---

# Hugo Development

**IMPORTANT:** Always consult this skill when working on any Hugo project. This includes:
- Starting or managing the dev server
- Building the site for any environment
- Reviewing pages with Playwright
- Making content or template changes

This skill provides standardized patterns that may differ from or extend what's in a project's CLAUDE.md.

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

## Docker Deployment (lipanski/docker-static-website)

Hugo sites commonly use `lipanski/docker-static-website` for serving static files. This minimal image has gotchas:

### Custom Error Pages (E404)

The `E404:404.html` directive in `httpd.conf` requires explicit config path:

```dockerfile
# REQUIRED for E404 to work
CMD ["/busybox-httpd", "-f", "-v", "-p", "3000", "-c", "/home/static/httpd.conf"]
```

Without the `-c` flag, httpd ignores the config file and E404 fails with:
`httpd: config error 'E404:404.html' in 'httpd.conf'`

### Healthchecks

The image is scratch-style with **no shell, wget, nc, or curl**. Healthchecks using these tools will fail.

For static sites, healthchecks are often unnecessary — if the container starts, it's serving. Consider omitting them from the stack template.

## Agent Behavior

1. **Starting dev server** — Always use `run_in_background: true`
2. **Before building** — Check project CLAUDE.md for environment names
3. **Docker builds** — Verify correct `ENVIRONMENT` arg for target deployment
4. **Docker deployment** — If using `lipanski/docker-static-website`, ensure CMD includes `-c` flag for httpd.conf
