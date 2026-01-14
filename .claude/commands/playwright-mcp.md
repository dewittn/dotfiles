---
description: Set up Playwright MCP servers (Chrome + WebKit) for browser automation and testing
---

# Playwright MCP Setup

Set up Playwright MCP servers in this project for browser automation. This configures both Chrome and WebKit browsers in headless/isolated mode.

## Step 1: Create .mcp.json

Create a `.mcp.json` file in the project root with the following exact configuration:

```json
{
  "mcpServers": {
    "playwright-chrome": {
      "command": "npx",
      "args": [
        "@playwright/mcp@latest",
        "--headless",
        "--isolated"
      ]
    },
    "playwright-webkit": {
      "command": "npx",
      "args": [
        "@playwright/mcp@latest",
        "--headless",
        "--isolated",
        "--browser=webkit",
        "--ignore-https-errors"
      ]
    }
  }
}
```

## Step 2: Project Settings (Optional)

Ask the user if they want to enable auto-approval of these MCP servers in the project settings. Present this as a question with two options:

1. **Enable auto-approval** - Add `enableAllProjectMcpServers: true` to `.claude/settings.json`. This means the servers will load automatically without a trust prompt.

2. **Skip** - The user will be prompted to approve the servers when they restart Claude Code. This is fine for one-time setup.

If the user chooses to enable auto-approval, create or update `.claude/settings.json`:
- If the file doesn't exist, create it with: `{ "enableAllProjectMcpServers": true }`
- If it exists, read it first, then add `"enableAllProjectMcpServers": true` to the existing config

## Step 3: Notify User

After completing the setup, inform the user:

1. The `.mcp.json` file has been created with Chrome and WebKit Playwright servers
2. **They must restart Claude Code** for the MCP servers to load
3. On first use, `npx` will download `@playwright/mcp` which takes a few seconds
4. After restart, they can verify with `/mcp` to see the available servers

## Notes

- Both browsers run in headless mode (no visible browser window)
- `--isolated` flag creates a fresh browser context each session
- WebKit includes `--ignore-https-errors` for local dev with self-signed certs
- The config is portable and safe to commit to git
