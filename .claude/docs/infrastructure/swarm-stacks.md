# Swarm Stack Deployment

Manual deployment of Docker Swarm stacks with 1Password secret injection.

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

## Manual Deployment

Deployments must run on the `coto-v3` Docker context (the swarm). Switch context before deploying and restore after.

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

## Verification Commands

All swarm commands must run on the `coto-v3` context.

```bash
docker context use coto-v3

# List services in the stack
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

## Rollback

If deployment fails, the previous version continues running (rolling update with `order: start-first`). To manually rollback:

```bash
docker context use coto-v3
docker service rollback <stackName>_app
docker context use orbstack
```

## Rolling Deployment Configuration

Ensure app services have proper rolling deployment config:

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

**Healthcheck required for rollback to work** — see `healthchecks.md`.

## Security

- Never commit the output `.yaml` files - they contain injected secrets
- The `.tpl` template files are safe to commit (contain only 1Password references)
- Always use `--with-registry-auth` for private registry authentication
