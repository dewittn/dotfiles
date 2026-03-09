# Status Workflow

## Status State Machine

| Current Status | Action |
|---------------|--------|
| `feature-planned` | Fresh start. Set `status: pre-planning`, set `last-updated` to today (`date +%Y-%m-%d`). Proceed to Stage 1 from first section. |
| `pre-planning` | Resuming. Read heading tags, show resumption summary, pick up at first non-reviewed section. |
| `planned` | Already complete. Tell operator: "Ready for `/build`. Want to re-review instead?" |
| `draft` | Not yet feature-planned. Suggest `/feature-define` first. |
| `implementing` / `complete` | Already past pre-planning. Tell operator the current status. |

## Resumption Display

When resuming (`pre-planning` status), present this generated display (not stored in the doc):

```
## Resuming Pre-Plan: [Feature Name]

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
### Feature A [pending]
### Feature B [in-review]
### Feature C [reviewed]
```
