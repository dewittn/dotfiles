---
description: Set up Playwright MCP servers (Chrome + WebKit) for browser automation and testing
---

# Playwright MCP Setup

Set up Playwright MCP servers in this project for browser automation and testing. This configures both Chrome and WebKit browsers in headless/isolated mode, adds necessary permissions, and creates a basic test setup.

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

## Step 2: Configure Claude Settings

Update `.claude/settings.json` to add:

1. **MCP Server auto-approval**: Add `"enableAllProjectMcpServers": true` so servers load without prompts
2. **Playwright MCP tool permissions**: Add permissions for all Playwright MCP tools to the `allow` array

Add these permissions to the `permissions.allow` array:

```json
"mcp__playwright-chrome__*",
"mcp__playwright-webkit__*"
```

If `.claude/settings.json` doesn't exist, create it with:

```json
{
  "enableAllProjectMcpServers": true,
  "permissions": {
    "allow": [
      "mcp__playwright-chrome__*",
      "mcp__playwright-webkit__*"
    ]
  }
}
```

## Step 3: Ask About Dev Server

Before creating the config, ask the user:

1. **What port does your dev server run on?** (default: 3000)
2. **What command starts your dev server?** (e.g., `bun run dev`, `bun run start`)

Use these answers to configure `baseURL` and `webServer` in the Playwright config.

## Step 4: Install Dependencies

Install Playwright dependencies using **bun** (not npm):

```bash
bun add -D @playwright/test
bunx playwright install
```

## Step 5: Add package.json Script

Add a test script to `package.json`:

```json
{
  "scripts": {
    "test:e2e": "playwright test"
  }
}
```

If `package.json` exists, read it first and merge the script. If it doesn't exist, create a minimal one.

## Step 6: Create playwright.config.js

Create `playwright.config.js` in the project root. Use the port and dev command from Step 3:

```javascript
import { defineConfig, devices } from '@playwright/test';

export default defineConfig({
  testDir: './tests',
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  workers: process.env.CI ? 1 : undefined,
  reporter: 'html',
  use: {
    baseURL: 'http://localhost:PORT', // Replace PORT with user's answer
    trace: 'on-first-retry',
  },
  projects: [
    {
      name: 'chromium',
      use: { ...devices['Desktop Chrome'] },
    },
    {
      name: 'webkit',
      use: { ...devices['Desktop Safari'] },
    },
  ],
  // Auto-start dev server before tests
  webServer: {
    command: 'DEV_COMMAND', // Replace with user's answer (e.g., 'bun run dev')
    url: 'http://localhost:PORT',
    reuseExistingServer: !process.env.CI,
  },
});
```

## Step 7: Create Basic Test File

Create the tests directory and `tests/example.spec.js`:

```bash
mkdir -p tests
```

```javascript
import { test, expect } from '@playwright/test';

test.describe('Example Tests', () => {
  test('homepage loads successfully', async ({ page }) => {
    await page.goto('/');
    await expect(page).toHaveTitle(/.+/);
  });

  test('page has expected content', async ({ page }) => {
    await page.goto('/');
    // Update this selector based on your app's content
    await expect(page.locator('body')).toBeVisible();
  });
});
```

## Step 8: Update .gitignore

Add Playwright artifacts to `.gitignore`:

```
# Playwright
test-results/
playwright-report/
playwright/.cache/
```

If `.gitignore` exists, append these entries. If not, create the file.

## Step 9: Notify User

After completing the setup, inform the user:

1. The `.mcp.json` file has been created with Chrome and WebKit Playwright servers
2. Permissions have been added to `.claude/settings.json`
3. Playwright dependencies have been installed via bun
4. Test script added to package.json
5. Basic test config with webServer auto-start created
6. Example test file created in `tests/`
7. Playwright artifacts added to `.gitignore`
8. **They must restart Claude Code** for the MCP servers to load
9. After restart, verify MCP servers with `/mcp`

**Run tests with:**
```bash
bun run test:e2e        # Runs all tests (auto-starts dev server)
bunx playwright test    # Alternative without package.json script
bunx playwright test --ui  # Interactive UI mode
```

## Step 10: Commit Changes

Commit all the Playwright setup files:

```bash
git add .mcp.json .claude/settings.json playwright.config.js tests/example.spec.js package.json .gitignore
git commit -m "Add Playwright MCP and test setup"
```

## Notes

- Both MCP browsers run in headless mode (no visible browser window)
- `--isolated` flag creates a fresh browser context each session
- WebKit includes `--ignore-https-errors` for local dev with self-signed certs
- The `webServer` config auto-starts the dev server before tests run
- `reuseExistingServer: !process.env.CI` uses running server locally, starts fresh in CI
- The config is portable and safe to commit to git
