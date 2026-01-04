# Pensieve Framework

A Pensieve is an insight discovery space—a structured environment for examining collected materials (documents, notes, ideas) and discovering insights through AI-assisted dialogue. Named after the magical device in Harry Potter that allows examining memories.

## Quick Start

1. Navigate to a folder containing materials you want to examine
2. Run `/pensieve-init`
3. Answer the discovery questions
4. Start exploring your materials

## Architecture

```
~/.config/claude/
├── working-with-nelson.md    # Universal: Communication & working style
├── global-insights.md        # Universal: Cross-cutting patterns
└── pensieve/
    ├── README.md             # This file
    └── templates/
        ├── CLAUDE.template.md
        └── key-insights.template.md

Your Project Folder/
├── CLAUDE.md                 # Generated: Project-specific setup
├── key-insights-[domain].md  # Generated: Domain-specific insights
├── working-with-nelson.md    # Symlink → ~/.config/claude/
├── global-insights.md        # Symlink → ~/.config/claude/
└── [your materials]          # Your documents, notes, etc.
```

## Three-Layer System

### Layer 1: Universal (working-with-nelson.md)
How to work with Nelson. Communication preferences, thinking patterns, vocabulary, resistance patterns. Applies to ALL projects.

### Layer 2: Global (global-insights.md)
Cross-cutting patterns that manifest differently per domain. Examples:
- "Output Over Outcome" - judging work by execution, not external validation
- "Option C Blind Spot" - missing obvious paths
- "Discounting Integration Work" - undervaluing assembly/curation

### Layer 3: Project-Specific (key-insights-[domain].md)
Insights discovered in THIS domain. How global patterns manifest here. Domain-specific red flags, questions, and discoveries.

## The /pensieve-init Command

Located at `~/.claude/commands/pensieve-init.md`

### What It Does

1. **Scans** all .md and .pdf files in the current directory
2. **Assesses** domain, document types, and potential structure
3. **Asks** clarifying questions about goals and context
4. **Generates** CLAUDE.md and key-insights file from templates
5. **Creates** symlinks to universal files
6. **Offers** an optional discovery conversation

### Generated Files

**CLAUDE.md** - Project setup file containing:
- Links to the three insight layers
- Purpose and goals (from your answers)
- Document inventory (auto-generated)
- Domain-specific guidelines
- Reference tables (if applicable)

**key-insights-[domain].md** - Insight file containing:
- Seed sections based on the domain
- Placeholders for global pattern manifestations
- Space for discoveries to accumulate

## Best Practices

### Starting a Pensieve
- Gather materials first, even if disorganized
- Let the init agent assess what you have
- Answer discovery questions honestly—"I don't know yet" is valid
- Don't overthink the structure; it will evolve

### During Conversations
- When something feels off ("I bumped on that"), explore it
- When an insight emerges, ask to add it to key-insights
- Reference global patterns when they seem relevant
- Let the document grow organically

### Maintaining Pensives
- Update key-insights after significant discoveries
- If a pattern seems universal, propose adding to global-insights.md
- Keep domain-specific details in domain files
- Periodically review if the structure still fits

## Supported File Types

- `.md` - Markdown files (primary format)
- `.pdf` - PDF documents (Claude Code can read these)

## Tips

1. **"Pile of stuff" is fine** - The init process will help organize
2. **Insights emerge through use** - Don't expect everything upfront
3. **Global patterns are experiments** - They may or may not fit every domain
4. **The structure serves you** - Modify it if it's not working
