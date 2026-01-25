# Coto Studio CI/CD Patterns

Reference guide for Coto Studio's Docker Swarm deployment pipeline. Apply these patterns when creating or modifying CI/CD configuration.

## Pipeline Overview

All projects (Hugo, Ghost, WordPress) use the same deployment pipeline:

```
push to main/dev → check-base-image (scheduled) → docker-build-image → docker-stack-deploy
```

Reusable workflows live in `Coto-Studio/workflows/.github/workflows/`:
- `check-base-image-v3.yml` - Scheduled/nightly checks for base image updates
- `docker-build-image-v3.yml` - Multi-arch build, push to GHCR
- `docker-build-image-v4.yml` - Build with `docker buildx bake`
- `docker-stack-deploy-v3.yml` - Deploy via Tailscale + 1Password

## GitHub Workflow Configuration

**Required:** `.github/workflows/` directory with deployment workflow

**Workflow calls:**
- Reference correct reusable workflow versions (prefer v3)
- Job dependencies: `deploy` needs `build`
- Secrets passed: `OP_SERVICE_ACCOUNT_TOKEN: ${{ secrets.OP_SERVICE_ACCOUNT_TOKEN }}`

**Triggers:**
```yaml
on:
  push:
    branches: [main]  # or [main, dev] for multi-environment
  workflow_dispatch:
```

**Conditional requirements:**
- If `.gitmodules` exists → workflow needs `submodules: "true"` and PAT token
- If `.gitattributes` has LFS patterns → workflow needs `lfs: true`
- Always use `platforms: linux/amd64,linux/arm64` for multi-arch builds

**Optional but recommended:**
- `check-base-image` workflow for scheduled rebuilds (e.g., new Ghost releases)
- Pushover notifications in deploy workflow

## Docker Stack Template

**Required file:** `docker-stack-op.yaml.tpl`

**Deploy configuration (zero-downtime updates):**
```yaml
deploy:
  update_config:
    order: start-first
    failure_action: rollback
    delay: 30s
    monitor: 60s
    max_failure_ratio: 0
  rollback_config:
    order: stop-first
    parallelism: 1
  restart_policy:
    condition: on-failure
    max_attempts: 3
```

**Healthcheck (required):**
```yaml
healthcheck:
  test: ["CMD", "nc", "-z", "localhost", "<port>"]
  start_period: 60s
  interval: 10s
  timeout: 5s
  retries: 3
```

**Traefik labels (required):**
- `traefik.enable=true`
- Router with HTTPS entrypoint (`websecure`)
- TLS certresolver (`le-http`)
- HTTP→HTTPS redirect middleware
- Service loadbalancer port defined

**1Password references:**
- All secrets use `op://` or `{{ op://...}}` format
- No hardcoded credentials

## Staging Environments

**Hugo sites:** Staging runs continuously alongside production
- Same stack file, two services (main + dev)
- Different domains (e.g., `beta.example.com`)

**Ghost/WordPress sites:** Staging is on-demand
- Separate template: `docker-stack-staging-op.yaml.tpl`
- Stack name uses `-staging` suffix

## Dockerfile Patterns

When present:
- Use multi-stage build pattern
- Appropriate base image for the project type
- `ENVIRONMENT` build arg for environment-specific builds

## Project Configuration

**.gitignore must exclude injected secrets files:**
```
docker-stack-op.yaml
docker-stack-staging.yaml
```

**CLAUDE.md should document:**
- Stack name (`deploy/stack` + `deploy/service`)
- Deployment instructions

## 1Password Item Structure

Each project needs a 1Password item with:
- `deploy/stack` - Project identifier
- `deploy/service` - Service type
- `deploy/image` - GHCR image path
- `deploy/host` - Swarm manager hostname
- `deploy/user` - SSH user

## Critical Rules

- Ghost does NOT support multiple replicas. Always use `replicas: 1`
- The injected `.yaml` files contain secrets. NEVER commit them
- All sites use the same pipeline pattern. Only the docker-stack template differs
