---
description: Set up playwright-cli for browser automation and testing (replaces Playwright MCP)
---

# Playwright CLI Setup

Set up `playwright-cli` in this project for browser automation. This replaces the old Playwright MCP approach with a lighter CLI that uses less context.

## Step 1: Install Skills

Run `playwright-cli install --skills` to install the skill files into `.claude/skills/playwright-cli/`:

```bash
playwright-cli install --skills
```

This creates the SKILL.md and reference docs that Claude Code needs.

## Step 2: Configure Permissions

Read `.claude/settings.json` if it exists. Add these permissions to the `permissions.allow` array:

```json
"Skill(playwright-cli)",
"Bash(playwright-cli:*)"
```

If `.claude/settings.json` doesn't exist, create it:

```json
{
  "permissions": {
    "allow": [
      "Skill(playwright-cli)",
      "Bash(playwright-cli:*)"
    ]
  }
}
```

**Important:** Preserve all existing permissions. Only add the new ones if they're not already present.

## Step 3: Remove Old MCP Config

Check for and clean up old Playwright MCP artifacts:

1. **`.mcp.json`** — If it exists, read it. Remove any `playwright` or `playwright-chrome` or `playwright-webkit` server entries. If the file becomes empty (no other servers), delete it.
2. **`.claude/settings.json` permissions** — Remove any entries matching `mcp__playwright*` from the allow array.
3. **`.claude/settings.local.json` permissions** — Same cleanup if this file exists. Remove `mcp__playwright*` entries.

## Step 4: Check Browser Installation

Verify that the required browsers are installed:

```bash
playwright-cli open --browser=chrome http://example.com 2>&1
playwright-cli close
```

If chrome works, check webkit:

```bash
playwright-cli open --browser=webkit http://example.com 2>&1
playwright-cli close
```

If webkit is not installed, install it. The `playwright-cli install-browser` command has a known issue, so use the playwright-core CLI directly:

```bash
node ~/.bun/install/global/node_modules/playwright-core/cli.js install webkit
```

**Note:** Do NOT use `bunx playwright install webkit` — it installs to a transient temp directory that `playwright-cli` cannot find.

## Step 5: Update .gitignore

Add playwright-cli artifacts to `.gitignore`:

```
# Playwright CLI
.playwright-cli/
```

If `.gitignore` exists, read it first and append only if not already present.

## Step 6: Notify User

After completing setup, inform the user:

1. Playwright CLI skills installed to `.claude/skills/playwright-cli/`
2. Permissions added to `.claude/settings.json`
3. Old MCP config removed (if any was found)
4. Browser status (chrome/webkit installed or not)
5. `.gitignore` updated

**Usage:**
```bash
# Invoke the skill
# Use: Skill(playwright-cli) or reference the playwright-cli skill

# Direct CLI usage
playwright-cli open http://localhost:3000
playwright-cli screenshot
playwright-cli close

# WebKit (Safari) testing
playwright-cli open http://localhost:3000 --browser=webkit
playwright-cli screenshot
playwright-cli close
```

## Step 7: Commit Changes

Stage and commit the setup files:

```bash
git add .claude/settings.json .claude/skills/playwright-cli/ .gitignore
git commit -m "Set up playwright-cli for browser automation"
```

Do NOT commit `.claude/settings.local.json` — that's for local-only overrides.

## Notes

- `playwright-cli` runs browsers headless by default (no visible window)
- Browsers are installed globally in `~/Library/Caches/ms-playwright/` — this is a one-time setup per machine
- Skills are project-local so each project gets the right version
- The CLI uses significantly less context than MCP tools since each command is a single bash call
- Chrome works out of the box; WebKit needs a one-time install
