---
name: hugo
description: Hugo static site development. Always consult when working on Hugo projects — dev servers, builds, or content changes.
---

# Hugo Development

**Read first:** `~/.claude/docs/platforms/hugo-development.md`

## When to Invoke

- Starting or managing the dev server
- Building the site for any environment
- Reviewing pages with Playwright
- Making content or template changes

## Agent Behavior

1. **Starting dev server** — Use `run_in_background: true`
2. **Before building** — Check project CLAUDE.md for environment names
3. **Docker builds** — Verify correct `ENVIRONMENT` arg for target deployment
4. **Docker deployment** — If using `lipanski/docker-static-website`, ensure CMD includes `-c` flag for httpd.conf
5. **Project overrides** — Individual projects may have different configs; always check their CLAUDE.md
