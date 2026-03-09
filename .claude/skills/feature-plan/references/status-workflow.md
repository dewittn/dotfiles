# Status Workflow

## Status State Machine

| Current Status | Action |
|---------------|--------|
| `defined` | Fresh start. Set `status: planning`, set `last-updated` to today (`date +%Y-%m-%d`). Proceed to Stage 1 from first section. |
| `planning` | Resuming. Read heading tags, show resumption summary, pick up at first non-reviewed section. |
| `planned` | Already complete. Tell operator: "Ready for `/feature-build`. Want to re-review instead?" |
| `defining` | Not yet defined. Suggest `/feature-define` first. |
| `implementing` / `implemented` | Already past feature planning. Tell operator the current status. |

## Resumption Display

When resuming (`planning` status), present this generated display (not stored in the doc):

```
## Resuming Feature Plan: [Feature Name]

| Section | Status |
|---------|--------|
| Change 1 | reviewed |
| Change 2 | reviewed |
| Change 3 | pending |

Picking up at: **Change 3 — [Section Name]**
```

Heading tags are the single source of truth for status. Do not add a progress table to the doc. Do not re-review completed sections. If all sections are `[reviewed]`, skip Stage 1 and go to Final Review/Completion.

## Heading Tag Format

```
### Change A [pending]
### Change B [in-review]
### Change C [reviewed]
```
