---
name: playwright
description: Playwright CLI reference for browser automation. Consult when taking screenshots, testing forms, or running E2E flows.
---

# Playwright CLI Reference

**Read first:** `~/.claude/docs/platforms/playwright-automation.md`

## When to Invoke

- Taking screenshots across viewports
- Testing forms or user flows
- Cross-browser testing (Chrome + WebKit/Safari)
- Visual regression testing

## Agent Behavior

1. **Use `playwright-cli` commands** via Bash, not MCP tools
2. **Always snapshot before interacting** — refs are needed for clicks/fills
3. **Resize before screenshot** — set viewport dimensions first
4. **Clean up screenshots** — delete generated files after reviewing
5. **Close when done** — run `playwright-cli close` to free resources

## Setup

If `playwright-cli` commands fail with "not installed", run `/playwright-setup` to configure the project.
