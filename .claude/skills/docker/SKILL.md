---
name: docker
description: Docker context safety and operational patterns. Consult before running Docker commands to ensure correct context (orbstack=local, coto-v3=remote). Lightweight orientation for Docker projects.
---

# Docker Context Safety

Consult this skill before running Docker commands to avoid executing local commands on remote servers (or vice versa).

## Context Mapping

| Context | Environment | Commands | URL Pattern |
|---------|-------------|----------|-------------|
| `orbstack` | Local dev | `docker compose` | `*.dev.orb.local` |
| `coto-v3` | Remote server | `docker stack` | Production/staging |

## Pre-Flight Check

**Always verify context before Docker operations:**

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

## Volume Safety

| Action | Safe? | Notes |
|--------|-------|-------|
| `docker stack rm` | Yes | Removes services, keeps data |
| `docker network rm` | Yes | Can recreate |
| `docker volume rm` | **NO** | Data loss — ask user first |
| `docker volume prune` | **NO** | Data loss — ask user first |

**Never delete remote volumes without explicit user permission.**

## Quick Reference

| Task | Local (orbstack) | Remote (coto-v3) |
|------|------------------|------------------|
| Start | `docker compose up --build --watch` | `docker stack deploy` |
| Stop | `docker compose down` | `docker stack rm <stack>` |
| Logs | `docker compose logs -f` | `docker service logs <stack>_<service>` |
| Status | `docker compose ps` | `docker stack services <stack>` |

## Agent Behavior

1. **Before any Docker command** — Check context matches intent
2. **After remote operations** — Restore to `orbstack`
3. **Volume operations** — Always ask user first on remote
4. **Starting local dev** — Run both Docker and build watcher in parallel with `run_in_background: true`
