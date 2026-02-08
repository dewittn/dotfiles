# Playwright Browser Automation

Reference for browser automation via `playwright-cli`.

## Setup

Run `/playwright-setup` in any project to install skills, permissions, and verify browsers.

## Required Permissions

Add to `.claude/settings.json`:

```json
"Skill(playwright-cli)",
"Bash(playwright-cli:*)"
```

## Browser Installation

Chrome works out of the box. WebKit requires a one-time install:

```bash
# Install webkit (one-time, global)
node ~/.bun/install/global/node_modules/playwright-core/cli.js install webkit
```

**Do NOT use `bunx playwright install`** — it installs to a transient temp directory.

Browsers live in `~/Library/Caches/ms-playwright/` and are shared across all projects.

## Common Commands

| Command | Purpose |
|---------|---------|
| `playwright-cli open <url>` | Open browser and navigate |
| `playwright-cli open <url> --browser=webkit` | Open in Safari/WebKit |
| `playwright-cli screenshot` | Capture viewport |
| `playwright-cli screenshot --filename=name.png` | Capture with specific name |
| `playwright-cli snapshot` | Get accessibility tree (element refs) |
| `playwright-cli click <ref>` | Click element by ref |
| `playwright-cli fill <ref> "text"` | Fill input by ref |
| `playwright-cli resize <w> <h>` | Set viewport size |
| `playwright-cli eval "js expression"` | Run JavaScript |
| `playwright-cli console` | Get console messages |
| `playwright-cli close` | Close browser |

## Standard Viewports

| Name | Dimensions | Use Case |
|------|------------|----------|
| Desktop | 1280x800 | Standard desktop |
| Large Desktop | 1440x900 | Large screens |
| Tablet | 768x1024 | iPad portrait |
| Mobile | 375x812 | iPhone |

## Workflow Patterns

### Screenshot Batch
1. `playwright-cli open <url>`
2. For each viewport: `resize`, `screenshot --filename=<name>.png`
3. `close`
4. Clean up screenshot files when done

### Form Testing
1. `open` the form page
2. `snapshot` to get element refs
3. `fill` fields using refs from snapshot
4. `click` submit button
5. `snapshot` or `screenshot` to verify result

### Cross-Browser Testing
1. Test in Chrome first (default)
2. `close`, then `open --browser=webkit` for Safari
3. Compare screenshots or behavior

### E2E Flow
1. `open` entry point
2. `snapshot` before each interaction
3. Perform action using element refs
4. Verify expected state
5. Continue to next step

## Key Patterns

- **Always snapshot before interacting** — refs from snapshot are needed for clicks/fills
- **Resize before screenshot** — set viewport first
- **Clean up screenshots** — delete generated .png files after reviewing
- **Close when done** — `playwright-cli close` frees resources

## Error Handling

| Error | Solution |
|-------|----------|
| Browser not installed | Install via playwright-core CLI (see above) |
| Element not found | Run `snapshot`, check available refs |
| Page won't load | Check URL, run `console` for errors |
| Session already open | Run `close` first, or use named sessions (`-s=name`) |

## Named Sessions

For parallel browser testing:

```bash
playwright-cli -s=chrome open http://localhost:3000
playwright-cli -s=safari open http://localhost:3000 --browser=webkit
playwright-cli -s=chrome screenshot --filename=chrome.png
playwright-cli -s=safari screenshot --filename=safari.png
playwright-cli close-all
```
