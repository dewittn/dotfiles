# CI/CD Pipelines

Production deployments are automated via GitHub Actions. Reusable workflows live in the `Coto-Studio/workflows` repository.

## Pipeline Flow

```
push to main → check-base-image → docker-build-image → docker-stack-deploy
```

1. **check-base-image** - Determines if the base image was updated (triggers rebuild)
2. **docker-build-image** - Multi-arch build, pushes to GHCR with layer caching
3. **docker-stack-deploy** - Connects via Tailscale, injects secrets, deploys stack, sends Pushover notification

## Reusable Workflows

Located in `Coto-Studio/workflows/.github/workflows/`:

| Workflow | Purpose | Version |
|----------|---------|---------|
| `check-base-image-v3.yml` | Check if base image updated | v3 |
| `docker-build-image-v3.yml` | Build & push multi-arch image | v3 |
| `docker-build-image-v4.yml` | Build with `docker buildx bake` | v4 |
| `docker-stack-deploy-v3.yml` | Deploy stack via Tailscale | v3 |

## Required GitHub Repository Variables

Set in Settings → Secrets and variables → Actions:

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

## 1Password Item Structure

Each project needs a 1Password item with these `deploy/*` fields:

| Field | Description | Example |
|-------|-------------|---------|
| `deploy/stack` | Project identifier | `nr-com` |
| `deploy/service` | Service type | `ghost` |
| `deploy/image` | GHCR image path | `ghcr.io/coto-studio/nr-com` |
| `deploy/host` | Swarm manager hostname | `swarm.example.com` |
| `deploy/user` | SSH user for deployment | `deploy` |

## Example Caller Workflow

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

## Debugging

```bash
# View workflow runs
gh run list --repo <owner>/<repo>
gh run view <run-id> --log

# Check 1Password references
op read "op://<vault>/<item>/deploy/image"

# Test locally with act
act -j build --secret-file .secrets
```
