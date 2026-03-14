# Context Audit Report — mode: init

**Target:** `CLAUDE.md` (PROSIM Reconstruction Project)
**Date:** 2026-03-14

## Token Estimate

| Metric | Words | ~Tokens |
|--------|-------|---------|
| Before | 404 | 525 |
| After  | — | — |
| Saved  | — | — |

## Skill Inventory

| Skill | Domain |
|-------|--------|
| `playwright-cli` | Browser automation, web testing, screenshots, form filling, data extraction |

Only one skill exists. This project is a pure coding/forensic reconstruction project with no creative, persona, or planning skills.

## Findings

| # | Section | Classification | Rationale |
|---|---------|---------------|-----------|
| 1 | Hard Rules — "Always use Docker" | Hook candidate | Enforceable rule ("always use Docker compose --profile dev"). Could be a pre-commit hook or shell alias that wraps `docker compose`. Leave in place until a hook exists. |
| 2 | Hard Rules — "Always use `playwright-cli` via Bash" | Move to skill (`playwright-cli`) | Only relevant when doing browser testing. A session doing pure simulation math or CLI work never touches Playwright. The `playwright-cli` skill already covers this domain. If absent, no error occurs in non-browser sessions. |
| 3 | Hard Rules — "App URL" | Delete | Discoverable from `docker-compose.yml` or OrbStack configuration. The URL is a runtime artifact, not a non-discoverable convention. |
| 4 | Hard Rules — "Never modify verified mechanics" | Keep | **Specific error if absent:** Claude modifies a VERIFIED simulation formula (e.g., demand forecasting, inventory cost) without checking verification status, silently breaking forensic accuracy. This is a safety rule with severe, hard-to-detect consequences — the project's entire purpose is exact reconstruction. Every coding session risks touching mechanics. |
| 5 | Hard Rules — "Record key discoveries" | Delete | Discoverable from the template in `docs/key_discoveries.md` itself. Claude can read the file and see the template format. No non-discoverable convention here. |
| 6 | Project Overview | Keep | **Specific error if absent:** Claude confuses this PROSIM (Greenlaw commercial product) with the Mize academic PROSIM lineage, producing wrong algorithms or referencing wrong source material. This disambiguation is not in any code file — it's historical context that affects every forensic decision. Also sets the core constraint (identical results given same inputs) that governs all implementation choices. |
| 7 | Commands — pytest/CLI | Delete | Discoverable from `pyproject.toml`, standard Python project conventions, and the CLI module path (`prosim/cli/main.py`). |
| 8 | Commands — Docker Development | Delete | Discoverable from `docker-compose.yml` (profiles, service names) and standard Docker conventions. The "bind-mounted" note is visible from the compose file's volume mounts. The `--build` trigger (pyproject.toml changes) is standard Docker behavior. |
| 9 | Verification Gates | Keep | **Specific error if absent:** Claude modifies a PARTIAL or UNKNOWN mechanic without documenting reasoning or making it configurable, violating the project's forensic methodology. This section operationalizes the "never modify verified mechanics" hard rule with the three-tier protocol. Without it, Claude lacks the behavioral guidance for PARTIAL and UNKNOWN statuses — information not in the verification status doc itself (which tracks status, not the protocol for how to act on each status). |
| 10 | Key Principles | Move to skill | These are project philosophy statements. Principle 1 (historical accuracy) is already covered by the Verification Gates section and the Hard Rules "never modify verified mechanics" entry. Principles 2-4 (document everything, verify against archive, authentic output) are good practices but don't prevent specific errors in a generic coding session — they describe aspirational workflow rather than enforceable constraints. No skill currently owns these, but they could live in a future `forensic-methodology` skill or be deleted as redundant with Verification Gates. |
| 11 | Key Files | Move to skill | This is a file directory. Claude can discover these files via glob/grep. The table duplicates what `ls docs/` and reading file headers would reveal. The "START HERE" annotation for `forensic_verification_status.md` is the only non-discoverable element, but the Verification Gates section (kept) already references this file. No concrete error occurs if this table is absent — Claude can find these files. |
| 12 | Reference Docs | Delete | Purely discoverable. These are files in the `docs/` directory that Claude can find by listing the directory. The one-line descriptions are visible from the files' own headers/content. |

## Hook Candidates

| Rule | Current Location | Suggested Hook Type |
|------|-----------------|-------------------|
| "Always use Docker" for web interface | Hard Rules, bullet 1 | Shell alias or wrapper script that enforces `docker compose --profile dev` |

## Proposed Changes

### Delete
- [ ] **Hard Rules — "App URL"** (line 6, `https://prosim-dev...`): Discoverable from docker-compose/OrbStack config
- [ ] **Hard Rules — "Record key discoveries"** (line 9): Discoverable from the template in `docs/key_discoveries.md`
- [ ] **Commands — pytest/CLI** (lines 17-22): Discoverable from pyproject.toml and standard Python conventions
- [ ] **Commands — Docker Development** (lines 24-41): Discoverable from docker-compose.yml
- [ ] **Reference Docs** (lines 69-77): Discoverable from `ls docs/` and file headers

### Move
- [ ] **Hard Rules — "Always use playwright-cli via Bash"** → `playwright-cli` skill: Only relevant during browser testing sessions
- [ ] **Key Principles** (lines 52-56) → future `forensic-methodology` skill or delete as redundant with Verification Gates
- [ ] **Key Files** (lines 58-67) → future `forensic-methodology` skill or delete as discoverable

### Keep (no action)
- [ ] **Hard Rules — "Never modify verified mechanics"**: Safety rule; without it Claude silently breaks forensic accuracy by modifying verified formulas
- [ ] **Project Overview**: Disambiguates PROSIM lineage (Greenlaw vs. Mize) — not discoverable from code; affects every forensic decision
- [ ] **Verification Gates**: Operationalizes the three-tier verification protocol (VERIFIED/PARTIAL/UNKNOWN) — behavioral guidance not present in the status doc itself
- [ ] **Hard Rules — "Always use Docker"**: Hook candidate, leave in place until hook exists

## Savings Summary

Estimated context reduction: ~310 tokens (59% of original)

Sections kept (~215 tokens): Hard Rules (Docker + verified mechanics), Project Overview, Verification Gates
Sections removed/moved (~310 tokens): App URL, record discoveries, Commands (all), Key Principles, Key Files, Reference Docs, playwright-cli rule
