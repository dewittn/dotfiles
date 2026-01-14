# Pensieve Initialization

You are initializing a new Pensieve—an insight discovery space for examining collected materials through AI-assisted dialogue.

## Important Files

**Templates location:** `~/.config/claude/pensieve/templates/`
- `CLAUDE.template.md` - Base template for project CLAUDE.md
- `key-insights.template.md` - Base template for key-insights file

**Universal files to symlink:** `~/.config/claude/`
- `working-with-nelson.md` - Universal working style guidance
- `global-insights.md` - Cross-cutting patterns

## Phase 1: Scan

First, understand what materials exist in this folder.

1. Use the Glob tool to find all `.md` and `.pdf` files in the current directory (not subdirectories initially)
2. Read each file to understand its content, purpose, and potential value
3. Note:
   - File types (markdown vs PDF)
   - Content categories (notes, drafts, research, reference, etc.)
   - Themes or topics that emerge
   - Potential document hierarchy (what's authoritative vs. working draft)
   - Any existing structure or organization

**Create a mental inventory** of what you found before proceeding.

## Phase 2: Assess

Based on your scan, determine:

1. **Domain/Subject**: What is this Pensieve about? (e.g., "fiction writing", "ultimate frisbee season planning", "career transition")

2. **Document Types Present**:
   - Source material (research, references)
   - Working documents (drafts, notes, ideas)
   - Structured content (outlines, plans)
   - Historical/archival material

3. **Potential Authority Hierarchy**:
   - What documents are most authoritative/current?
   - What is historical/archival?
   - What is work-in-progress?

4. **Reference Table Potential**:
   - Are there terms, names, or concepts that would benefit from a reference table?
   - Are there project shorthands that need mapping?

## Phase 3: Discover

Ask the user these questions using the AskUserQuestion tool. Provide your suggestions based on the scan.

**Questions to ask:**

1. **Domain**: "Based on the materials, this looks like a Pensieve for [your assessment]. What would you like to call this domain?"
   - Offer your suggested domain name
   - Let them confirm or provide alternative

2. **Purpose**: "What are you hoping to discover or accomplish with this Pensieve?"
   - This will populate the Purpose & Goals section
   - Probe for specific outcomes if the answer is vague

3. **Existing Insights**: "Are there any patterns or insights you're already tracking that I should know about?"
   - These become seed content for key-insights

4. **Git Consideration**: If a .git directory exists, ask: "This folder is a git repository. Should I add the generated Pensieve files to .gitignore?"

5. **Any additional clarifying questions** based on what you found in the materials.

## Phase 4: Generate

Using the templates and the user's answers, generate the following files:

### 1. Create symlinks

```bash
ln -s ~/.config/claude/working-with-nelson.md ./working-with-nelson.md
ln -s ~/.config/claude/global-insights.md ./global-insights.md
```

### 2. Generate CLAUDE.md

Read the template from `~/.config/claude/pensieve/templates/CLAUDE.template.md` and fill in:

- `{{PROJECT_NAME}}` - A descriptive name for this Pensieve
- `{{DOMAIN}}` - The domain/subject area
- `{{KEY_INSIGHTS_FILE}}` - `key-insights-[domain-slug].md`
- `{{PURPOSE_AND_GOALS}}` - From user's answer to purpose question
- `{{DOCUMENT_INVENTORY}}` - Auto-generate from your scan:
  ```
  | File | Type | Description |
  |------|------|-------------|
  | filename.md | markdown | Brief description |
  ```
- `{{DOCUMENT_AUTHORITY_NOTES}}` - Your assessment of document hierarchy
- `{{DOMAIN_SPECIFIC_GUIDELINES}}` - Any domain-specific agent guidance
- `{{REFERENCE_TABLES}}` - If applicable, create reference tables for terms, shorthands, etc.

### 3. Generate key-insights-[domain].md

Read the template from `~/.config/claude/pensieve/templates/key-insights.template.md` and fill in:

- `{{DOMAIN}}` - The domain/subject area
- `{{SEED_INSIGHTS}}` - Any insights the user mentioned, or leave as "*No insights yet. Add them as they emerge from conversation.*"
- `{{SEED_PATTERNS}}` - Any patterns already visible, or leave empty
- `{{OUTPUT_OVER_OUTCOME_MANIFESTATION}}` - How this pattern might appear in this domain
- `{{OPTION_C_MANIFESTATION}}` - How this pattern might appear in this domain
- `{{SEED_RED_FLAGS}}` - Domain-specific warning signs if apparent
- `{{SEED_QUESTIONS}}` - Key questions for this domain if apparent

### 4. Update .gitignore (if requested)

If the user asked for it, add to .gitignore:
```
# Pensieve files
CLAUDE.md
key-insights-*.md
working-with-nelson.md
global-insights.md
```

## Phase 5: Discovery Conversation (Optional)

After generating files, offer:

"The Pensieve is set up. Would you like me to do an initial discovery pass through the materials to seed some insights?"

If yes:
1. Read through the materials more thoroughly
2. Identify 3-5 initial observations or potential insights
3. Propose them as additions to the key-insights file
4. Note any questions that emerged from reading
5. Suggest potential sections or categories for organizing future insights

## Output Summary

When complete, summarize what was created:

```
## Pensieve Initialized: [Project Name]

**Domain:** [domain]
**Files created:**
- CLAUDE.md
- key-insights-[domain].md
- working-with-nelson.md (symlink)
- global-insights.md (symlink)

**Documents inventoried:** [count] files

**Next steps:**
- Review the generated CLAUDE.md to ensure accuracy
- Start a conversation about your materials
- Insights will accumulate in key-insights-[domain].md as we discuss
```

## Notes

- Be thorough in the scan phase—understanding the materials is crucial
- The global pattern manifestations are experiments; make your best guess
- If unsure about something, ask rather than assume
- The structure should serve Nelson's needs; suggest modifications if something doesn't fit
