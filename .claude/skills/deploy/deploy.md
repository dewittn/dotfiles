# Docker Swarm Deployment

Deploy Docker Swarm stacks with 1Password secret injection.

## Stack Name Convention

Stack names are composed from two 1Password fields:
- `deploy/stack` - The project identifier (e.g., `nr-com`)
- `deploy/service` - The service type (e.g., `ghost`, `wordpress`)

**Full stack name:** `{stack}-{service}` (e.g., `nr-com-ghost`)

**Staging stack name:** Append `-staging` to avoid overwriting production (e.g., `nr-com-ghost-staging`)

## Template Files

| Environment | Template | Output (gitignored) |
|-------------|----------|---------------------|
| Production | `docker-stack-op.yaml.tpl` | `docker-stack-op.yaml` |
| Staging | `docker-stack-staging-op.yaml.tpl` | `docker-stack-staging.yaml` |

Templates contain 1Password references (`op://vault/item/field`) that get injected at deploy time.

## Deployment Methods

### Method 1: Atuin Scripts (Preferred)

User runs from project directory:
```bash
# Production
deploy-prod
# Prompts for: stackName (e.g., nr-com-ghost)

# Staging
deploy-staging
# Prompts for: stackName (e.g., nr-com-ghost)
```

### Method 2: Manual Commands

If atuin scripts aren't available, run these commands:

**Important:** Deployments must run on the `coto-v3` Docker context (the swarm). Switch context before deploying and restore after.

**Production:**
```bash
ORIGINAL_CONTEXT=$(docker context show)
docker context use coto-v3
op inject -i docker-stack-op.yaml.tpl -o docker-stack-op.yaml -f
docker stack deploy -c docker-stack-op.yaml --detach --with-registry-auth <stackName>
docker stack services <stackName>
docker context use $ORIGINAL_CONTEXT
```

**Staging:**
```bash
ORIGINAL_CONTEXT=$(docker context show)
docker context use coto-v3
op inject -i docker-stack-staging-op.yaml.tpl -o docker-stack-staging.yaml -f
docker stack deploy -c docker-stack-staging.yaml --detach --with-registry-auth <stackName>-staging
docker stack services <stackName>-staging
docker context use $ORIGINAL_CONTEXT
```

## Agent Instructions

When the user asks to deploy:

1. **Identify the environment** (prod or staging)
2. **Get the stack name** - Check the project's CLAUDE.md for the stack name, or ask the user
3. **Run the deployment commands** - Use Method 2 (manual commands) since you can't invoke atuin scripts
4. **Expect 1Password authentication** - The `op inject` command will prompt the user to authenticate
5. **Verify deployment** - After deployment, check service status

### Verification Commands

**Important:** All swarm commands must run on the `coto-v3` context. Switch before running, switch back after.

```bash
# Switch to swarm context
docker context use coto-v3

# List services in the stack (use -staging suffix for staging)
docker stack services <stackName>

# List tasks (containers) in the stack
docker stack ps <stackName>

# View app logs
docker service logs <stackName>_app

# Check service health
docker service inspect <stackName>_app --pretty

# Switch back to local context
docker context use orbstack
```

**Example for staging:** `docker stack services nr-com-ghost-staging`

### Rollback

If deployment fails, the previous version continues running (rolling update with `order: start-first`). To manually rollback:

```bash
docker context use coto-v3
docker service rollback <stackName>_app
docker context use orbstack
```

### Rolling Deployment Configuration

**When working on any Docker stack template (excluding Ghost which is already configured), check that the app service has proper rolling deployment config:**

```yaml
deploy:
  update_config:
    order: start-first          # Start new before stopping old (zero-downtime)
    failure_action: rollback    # Auto-rollback on failure
    delay: 30s                  # Breathing room between steps
    monitor: 60s                # Observation window after update
    max_failure_ratio: 0        # Any failure triggers rollback
  rollback_config:
    order: stop-first           # Conservative rollback (stop bad one first)
    parallelism: 1
  restart_policy:
    condition: on-failure       # Auto-restart on crash
    max_attempts: 3
```

**Also verify a healthcheck exists** (required for rollback to work properly):

```yaml
healthcheck:
  test: ["CMD", "nc", "-z", "localhost", "<port>"]  # Or appropriate health endpoint
  start_period: 60s   # Allow time for startup/migrations
  interval: 10s
  timeout: 5s
  retries: 3
```

**Agent behavior:** When editing a Docker stack template, proactively check if `update_config`, `rollback_config`, and `healthcheck` are configured. If missing, suggest adding them. Ghost stacks are already configured—focus on other services.

## CI/CD Note

Production deployments happen automatically when changes are pushed to `main`. Manual deployment is typically only needed for:
- Configuration changes (1Password values)
- Rollbacks
- Staging environment testing

## Ghost Replica Limitation

**Ghost does NOT support multiple replicas.** Always use `replicas: 1`.

Ghost explicitly prohibits horizontal scaling. Running multiple instances causes:
- 405 Method Not Allowed errors
- Admin session logout (in-memory sessions don't sync)
- Content/theme changes invisible across nodes
- Requires constant service restarts

**Why this happens:**
- Sessions stored in-memory only (no Redis/external store support)
- Internal state caching doesn't sync across instances
- Theme activation only affects single node

**The correct scaling approach:**
- Single Ghost instance with `order: start-first` for zero-downtime updates
- External MySQL 8 database
- S3 storage adapter for images (already configured)
- CDN caching layer (Cloudflare) for traffic scaling

Ghost(Pro) handles 1.5B+ requests/month using single instances per site with aggressive caching—not replicas.

## Critical Safety Rules

**NEVER delete production volumes without explicit user permission.**

- `docker volume rm` on production = **data loss requiring backup restore**
- Stacks and networks can be safely removed and recreated
- Volumes contain persistent data (database, content, backups)

Safe to remove:
- `docker stack rm <stackName>` ✓
- `docker network rm` ✓

**DANGEROUS - requires explicit permission:**
- `docker volume rm` ✗
- `docker volume prune` ✗

If a volume needs to be removed, **always ask the user first** and confirm they understand data will be lost.

## Security

- Never commit the output `.yaml` files - they contain injected secrets
- The `.tpl` template files are safe to commit (contain only 1Password references)
- Always use `--with-registry-auth` for private registry authentication
