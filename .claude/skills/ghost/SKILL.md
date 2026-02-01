---
name: ghost
description: Ghost theme development patterns and gotchas. Consult when working on Ghost themes for routing, templates, member access, and known limitations.
---

# Ghost Theme Development

**Read first:** `~/.claude/docs/platforms/ghost-themes.md`

## When to Invoke

- Working with Ghost templates (`.hbs` files)
- Configuring `routes.yaml`
- Implementing member access features
- Deploying theme changes

## Agent Behavior

1. **Routes configuration** — Catch-all collection must be last
2. **error.hbs** — Only `{{asset}}` helper works; use `error-404.hbs` for themed errors
3. **Replicas** — Always `replicas: 1`; Ghost doesn't support multiple instances
4. **Validation** — Run `bun run test` or `npx gscan .` before deploying
5. **Deploy routes changes** — Local: restart container; Prod: upload via Ghost Admin
