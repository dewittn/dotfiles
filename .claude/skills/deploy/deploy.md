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

## Related Skills

- `/docker` — Context safety, volume protection (enforced via permission rules)
- `/ghost` — Ghost replica limitation, theme development patterns

## Security

- Never commit the output `.yaml` files - they contain injected secrets
- The `.tpl` template files are safe to commit (contain only 1Password references)
- Always use `--with-registry-auth` for private registry authentication

---

## CI/CD Pipeline

Production deployments are automated via GitHub Actions. The reusable workflows live in the `Coto-Studio/workflows` repository.

### Standard Pipeline Flow

```
push to main → check-base-image → docker-build-image → docker-stack-deploy
```

1. **check-base-image** - Determines if the base image was updated (triggers rebuild)
2. **docker-build-image** - Multi-arch build, pushes to GHCR with layer caching
3. **docker-stack-deploy** - Connects via Tailscale, injects secrets, deploys stack, sends Pushover notification

### Reusable Workflows

Located in `Coto-Studio/workflows/.github/workflows/`:

| Workflow | Purpose | Version |
|----------|---------|---------|
| `check-base-image-v3.yml` | Check if base image updated | v3 |
| `docker-build-image-v3.yml` | Build & push multi-arch image | v3 |
| `docker-build-image-v4.yml` | Build with `docker buildx bake` | v4 |
| `docker-stack-deploy-v3.yml` | Deploy stack via Tailscale | v3 |

### Required GitHub Repository Variables

Set these in the project repo under Settings → Secrets and variables → Actions:

**Secrets:**
| Secret | Description |
|--------|-------------|
| `OP_SERVICE_ACCOUNT_TOKEN` | 1Password service account token |

**Variables:**
| Variable | Description | Example |
|----------|-------------|---------|
| `WORKFLOWS_OP_REF` | 1Password ref for GitHub PAT | `op://vault/item/pat` |
| `CLIENTS_VAULT_ID` | 1Password vault ID for client secrets | `abcd1234` |
| `ITEM_ID` | 1Password item ID for this project | `xyz789` |
| `TS_OAUTH_CLIENT_ID_OP_REF` | Tailscale OAuth client ID ref | `op://vault/item/client-id` |
| `TS_OAUTH_SECRET_OP_REF` | Tailscale OAuth secret ref | `op://vault/item/secret` |
| `PUSHOVER_USER_KEY_OP_REF` | Pushover user key ref | `op://vault/item/user` |
| `PUSHOVER_API_TOKEN_GITHUB_OP_REF` | Pushover API token ref | `op://vault/item/token` |

### 1Password Item Structure

Each project needs a 1Password item with these `deploy/*` fields:

| Field | Description | Example |
|-------|-------------|---------|
| `deploy/stack` | Project identifier | `nr-com` |
| `deploy/service` | Service type | `ghost` |
| `deploy/image` | GHCR image path | `ghcr.io/coto-studio/nr-com` |
| `deploy/host` | Swarm manager hostname | `swarm.example.com` |
| `deploy/user` | SSH user for deployment | `deploy` |

The stack name is composed as `{stack}-{service}` (e.g., `nr-com-ghost`).

### Example Caller Workflow

In your project's `.github/workflows/deploy.yml`:

```yaml
name: Deploy

on:
  push:
    branches: [main]
  workflow_dispatch:

jobs:
  build:
    uses: Coto-Studio/workflows/.github/workflows/docker-build-image-v3.yml@main
    secrets:
      OP_SERVICE_ACCOUNT_TOKEN: ${{ secrets.OP_SERVICE_ACCOUNT_TOKEN }}

  deploy:
    needs: build
    uses: Coto-Studio/workflows/.github/workflows/docker-stack-deploy-v3.yml@main
    secrets:
      OP_SERVICE_ACCOUNT_TOKEN: ${{ secrets.OP_SERVICE_ACCOUNT_TOKEN }}
```

### Debugging CI/CD

**View workflow runs:**
```bash
gh run list --repo <owner>/<repo>
gh run view <run-id> --log
```

**Check 1Password references:**
```bash
op read "op://<vault>/<item>/deploy/image"
```

**Test locally with act:**
```bash
act -j build --secret-file .secrets
```
