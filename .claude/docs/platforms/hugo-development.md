# Hugo Development

Reference for Hugo static site builds, dev servers, and Docker deployment.

## Dev Server

**Before starting a server**, check if one is already running:

```bash
pgrep -f 'hugo server' || hugo server -D --bind 0.0.0.0
```

Or start manually after checking:

```bash
hugo server -D --bind 0.0.0.0
```

| Flag | Purpose |
|------|---------|
| `-D` | Include draft content |
| `--bind 0.0.0.0` | Accessible from other devices on network |

The server will be available at http://localhost:1313.

## Build Commands

```bash
# Production build
hugo --minify --environment main

# Staging build
hugo --minify --environment dev

# Docker build (common pattern)
docker build --build-arg ENVIRONMENT=main -t <project-name> .
```

## Environment-Based Config

Hugo projects typically use `/config/` directory structure:

```
config/
  _default/     # Base configuration
  main/         # Production overrides
  dev/          # Staging overrides
```

Individual projects may have different environment names — check project's `CLAUDE.md`.

## Bilingual Sites

Content typically under `/content/{lang}/`:

```
content/
  en/
  es/
```

## Docker Deployment (lipanski/docker-static-website)

Hugo sites commonly use `lipanski/docker-static-website` for serving static files. This minimal image has gotchas.

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
| `Stop` hook | Kill dev server when session ends |
