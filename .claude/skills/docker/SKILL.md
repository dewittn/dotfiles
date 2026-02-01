---
name: docker
description: Docker context safety and operational patterns. Consult before running Docker commands to ensure correct context (orbstack=local, coto-v3=remote).
---

# Docker Context Safety

**Read first:**
- `~/.claude/docs/infrastructure/docker-contexts.md`
- `~/.claude/docs/infrastructure/volume-safety.md`

## When to Invoke

- Before running any Docker command
- Switching between local and remote operations
- Volume or data-related operations

## Agent Behavior

1. **Before any Docker command** — Check context matches intent
2. **After remote operations** — Restore to `orbstack`
3. **Volume operations** — Always ask user first on remote
4. **Starting local dev** — Run Docker with `run_in_background: true`
