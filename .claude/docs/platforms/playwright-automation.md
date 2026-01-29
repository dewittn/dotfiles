# Playwright Browser Automation

Reference for browser automation via Playwright MCP tools.

## Available MCP Tools

| Tool | Purpose |
|------|---------|
| `mcp__playwright__browser_navigate` | Go to URLs |
| `mcp__playwright__browser_resize` | Set viewport dimensions |
| `mcp__playwright__browser_snapshot` | Get accessibility tree (use for finding element refs) |
| `mcp__playwright__browser_take_screenshot` | Capture images |
| `mcp__playwright__browser_click` | Click elements |
| `mcp__playwright__browser_type` | Type text into fields |
| `mcp__playwright__browser_fill_form` | Fill multiple form fields |
| `mcp__playwright__browser_press_key` | Keyboard input |
| `mcp__playwright__browser_hover` | Hover over elements |
| `mcp__playwright__browser_select_option` | Select dropdown options |
| `mcp__playwright__browser_wait_for` | Wait for text/elements |
| `mcp__playwright__browser_evaluate` | Run JavaScript |
| `mcp__playwright__browser_console_messages` | Get console output |
| `mcp__playwright__browser_network_requests` | Monitor network |
| `mcp__playwright__browser_close` | Close browser |
| `mcp__playwright__browser_install` | Install browser (run first if needed) |

## Standard Viewports

| Name | Dimensions | Use Case |
|------|------------|----------|
| Desktop | 1440x900 | Large screens |
| Tablet | 768x1024 | iPad portrait |
| Mobile | 375x812 | iPhone |

## Workflow Patterns

### Screenshot Batch
1. Navigate to URL
2. For each viewport: resize, wait for load, screenshot
3. Return summary table of captured files

### Form Testing
1. Navigate to form page
2. Get snapshot to identify field refs
3. Fill fields using refs from snapshot
4. Submit and verify result

### E2E Flow
1. Start at entry point
2. Take snapshot before each interaction
3. Perform action using element refs from snapshot
4. Verify expected state
5. Continue to next step

### Visual Regression
1. Capture baseline screenshots (branch A)
2. Capture comparison screenshots (branch B)
3. Compare and report differences

## Key Patterns

**Always snapshot before interacting** — The accessibility tree provides element refs needed for clicks/typing.

**Resize before screenshot** — Set viewport dimensions before capturing.

**Wait for stability** — Use `browser_wait_for` after navigation or actions that trigger loading.

## Error Handling

| Error | Solution |
|-------|----------|
| Browser not installed | Run `mcp__playwright__browser_install` first |
| Element not found | Take snapshot, check available refs |
| Page won't load | Check URL, look at console messages |
