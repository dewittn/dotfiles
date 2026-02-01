# Docker Context Management

Docker contexts separate local development from remote server operations. Always verify context before running Docker commands.

## Context Mapping

| Context | Environment | Commands | URL Pattern |
|---------|-------------|----------|-------------|
| `orbstack` | Local dev | `docker compose` | `*.dev.orb.local` |
| `coto-v3` | Remote server | `docker stack` | Production/staging |

## Pre-Flight Check

Always verify context before Docker operations:

```bash
# Check current context
docker context show

# Switch if needed
docker context use orbstack   # Local development
docker context use coto-v3    # Remote server
```

## Local Development (orbstack)

```bash
docker context use orbstack

# Start with file watching (flags are critical)
op run --env-file=".env" -- docker compose up --build --watch

# Stop
docker compose down
```

**Required flags:**
- `--build` — Rebuilds container on startup
- `--watch` — Enables file sync; without this, changes require container rebuild

## Remote Operations (coto-v3)

```bash
# Save context, switch, operate, restore
ORIGINAL_CONTEXT=$(docker context show)
docker context use coto-v3

# ... run commands ...

docker context use $ORIGINAL_CONTEXT
```

**Always restore context after remote operations** to avoid accidentally running local commands on the remote server.

## Quick Reference

| Task | Local (orbstack) | Remote (coto-v3) |
|------|------------------|------------------|
| Start | `docker compose up --build --watch` | `docker stack deploy` |
| Stop | `docker compose down` | `docker stack rm <stack>` |
| Logs | `docker compose logs -f` | `docker service logs <stack>_<service>` |
| Status | `docker compose ps` | `docker stack services <stack>` |
