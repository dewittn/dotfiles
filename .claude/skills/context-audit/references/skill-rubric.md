# Skill Mode Rubric — SKILL.md Audit

## The Signal Test

Ask of every line: **"Is this signal or noise?"**

Skill mode is lighter touch than init mode. Skills already benefit from progressive disclosure (loaded only on trigger). The goal is to trim noise within that loaded content, not to reclassify it.

## Five Noise Categories

These are guides, not gates. Use judgment — some content looks like noise but serves a purpose.

### 1. Commentary

Prose that restates the frontmatter description or explains why the skill exists. The description already triggered the skill — repeating it in the body wastes tokens.

Examples:
- "This skill helps you..." (the description said this)
- "Use this when..." in the body (belongs in frontmatter description)
- Motivational framing ("Writing good tests is important because...")

### 2. File Discovery

Directory trees, file paths, or project structure that Claude can find via glob/grep. Listing files Claude can discover on its own adds noise.

Examples:
- Full directory tree listings
- "The config file is at src/config/app.ts" (glob finds this)
- Enumerating all files in a directory

**Exception:** Paths that encode priority ("Read X first") or non-obvious locations outside the project directory are signal.

### 3. Inline Bloat

Lookup tables, output templates, sub-procedures, or detailed reference material that should live in references/ files. Content over ~20 lines that serves as reference rather than procedure.

Examples:
- Large configuration examples
- Multi-page output templates inline
- Detailed API documentation inline
- Lookup tables with more than 5-6 rows

Action: Move to `references/` and add a pointer from SKILL.md.

### 4. Redundancy

Content restating what another skill, the system prompt, or CLAUDE.md already handles. Duplicated instructions waste tokens and risk divergence.

Examples:
- Git commit rules duplicated from the commit skill
- Style guidance duplicated from code-styling
- "Always read the file before editing" (system prompt says this)

### 5. Dead Weight

Notes that should be rules (but aren't actionable), or content that doesn't need saying. Information with no impact on Claude's behavior.

Examples:
- Historical context about why a decision was made (unless it affects current behavior)
- "TODO" items left in the skill
- Caveats about edge cases that never occur

## Persona/Creative Skill Exception

Do NOT flag persona traits, atmospheric details, voice characteristics, or character context as noise. For persona and creative skills (e.g., nelson-voice, story-editor, story-circle-brainstorm), these details are signal — they directly affect output quality.

## Batch Triage

When auditing multiple skills, triage by size:

| Size | Lines | Action |
|------|-------|--------|
| Lean | <50 | Skip — unlikely to have meaningful noise |
| Medium | 50–150 | Quick review — scan for obvious noise |
| Verbose | 150+ | Deep audit — walk through all five categories |

## Audit Workflow

1. Run `estimate-tokens.sh` on the target SKILL.md (or all skills if auditing broadly)
2. For each skill meeting the triage threshold:
   a. Read the SKILL.md
   b. Walk each section through the five noise categories
   c. For "Inline bloat" items: check if a references/ file already exists for this content
   d. For "Redundancy" items: identify the authoritative source
3. Present the audit report per `references/report-template.md`
4. Wait for operator confirmation before applying any changes
5. Apply confirmed changes (move to references/, delete, consolidate)
6. Run `estimate-tokens.sh` again and report savings
