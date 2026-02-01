# Healthchecks

Healthchecks enable automatic rollback on failed deployments. Without them, Swarm can't detect failures.

## Basic Configuration

```yaml
healthcheck:
  test: ["CMD", "nc", "-z", "localhost", "<port>"]  # Or appropriate health endpoint
  start_period: 60s   # Allow time for startup/migrations
  interval: 10s
  timeout: 5s
  retries: 3
```

## Minimal Image Gotcha

Many minimal/scratch-style images lack common tools. Your healthcheck will fail if the image doesn't have the binary.

| Tool | Available in | Missing from |
|------|--------------|--------------|
| `curl` | Most images | Alpine minimal, scratch, distroless |
| `wget` | Alpine | Scratch, distroless |
| `nc` | Alpine, busybox | Scratch, distroless |
| shell | Most images | Scratch, distroless |

**Example:** `lipanski/docker-static-website` has no shell, wget, nc, or curl. Healthchecks using these tools will fail silently.

## Testing Locally

Always test healthchecks before deploying:

```bash
# 1. Build and run locally
docker --context orbstack build -t test-image .
docker --context orbstack run --rm -d --name test-health -p 3333:3000 test-image

# 2. Test the healthcheck command inside the container
docker --context orbstack exec test-health nc -z localhost 3000

# 3. Clean up
docker --context orbstack rm -f test-health
```

If the exec fails with "executable file not found", the image lacks that tool.

## When to Skip Healthchecks

For static sites using minimal images (like `lipanski/docker-static-website`), healthchecks are often unnecessary — if the container starts, it's serving.

Consider omitting them from the stack template rather than fighting with missing tools.
