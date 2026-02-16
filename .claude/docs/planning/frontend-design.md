# Planning Guide: Frontend Design

Reference for frontend design work, design systems, and the design contract approach.

Consulted by the **pre-plan** skill and the **frontend-prototype** skill.

## The Core Problem

When using Claude Code to generate frontend designs:

1. **Claude can't see what it built.** It generates CSS and HTML as tokens but has no perceptual experience of the rendered result.
2. **There's no spec to verify against.** Hundreds of micro-decisions (which gray, which spacing, which shadow depth) drift across pages with no single source of truth.

The design contract approach narrows the surface area that requires human eyes by handling mechanical consistency programmatically.

## When to Use a Design Contract

A full design contract is warranted when:

- Building a new site or application from scratch
- Overhauling an existing design system
- The project has multiple pages/components that must stay visually consistent
- You want programmatic enforcement of design tokens

A full contract is NOT needed when:

- Making small changes within an existing design system
- The project is a single page or small prototype
- The design is already defined by a framework (Tailwind config, etc.)

For smaller work, the **frontend-prototype** skill's handoff document captures design decisions without the overhead of a formal contract.

## The Design Contract Format

The contract uses the W3C Design Tokens Community Group (DTCG) format. The file is JSON and lives at the project root as `design-contract.json`.

### Structure

```json
{
  "$schema": "https://design-tokens.github.io/community-group/format/",
  "$description": "Design contract for [Project]. All frontend code must reference these tokens.",

  "color": {
    "$type": "color",
    "brand": {
      "primary": { "$value": "#1a1a2e" },
      "accent": { "$value": "#e94560" }
    },
    "neutral": {
      "50": { "$value": "#fafafa" },
      "600": { "$value": "#525252" },
      "900": { "$value": "#171717" }
    },
    "semantic": {
      "text-primary": { "$value": "{color.neutral.900}" },
      "text-secondary": { "$value": "{color.neutral.600}" },
      "background-primary": { "$value": "{color.neutral.50}" },
      "link": { "$value": "{color.brand.accent}" }
    }
  },

  "spacing": {
    "$type": "dimension",
    "$description": "Only these values are permitted for margin, padding, and gap.",
    "xs": { "$value": "4px" },
    "sm": { "$value": "8px" },
    "md": { "$value": "16px" },
    "lg": { "$value": "24px" },
    "xl": { "$value": "32px" },
    "2xl": { "$value": "48px" },
    "3xl": { "$value": "64px" }
  },

  "typography": {
    "fontFamily": {
      "$type": "fontFamily",
      "heading": { "$value": ["Inter", "system-ui", "sans-serif"] },
      "body": { "$value": ["Inter", "system-ui", "sans-serif"] }
    },
    "fontSize": {
      "$type": "dimension",
      "sm": { "$value": "0.875rem" },
      "base": { "$value": "1rem" },
      "lg": { "$value": "1.125rem" },
      "2xl": { "$value": "1.5rem" },
      "4xl": { "$value": "2.5rem" }
    }
  },

  "elevation": {
    "$type": "shadow",
    "sm": { "$value": "0 1px 2px 0 rgba(0, 0, 0, 0.05)" },
    "md": { "$value": "0 4px 6px -1px rgba(0, 0, 0, 0.1)" }
  },

  "borderRadius": {
    "$type": "dimension",
    "sm": { "$value": "4px" },
    "md": { "$value": "8px" },
    "lg": { "$value": "12px" }
  },

  "breakpoints": {
    "$type": "dimension",
    "mobile": { "$value": "375px" },
    "tablet": { "$value": "768px" },
    "desktop": { "$value": "1440px" }
  }
}
```

Adapt the token categories to the project. The example above is a starting point, not a mandatory structure.

### Creating the Contract

The contract can be extracted from approved prototypes:

- **Automatically** — Tools like Dembrandt (`npx dembrandt yoursite.com --dtcg`) extract tokens from live sites
- **Semi-automatically** — Have Claude extract computed styles from approved prototypes into structured JSON
- **Manually** — Curate the token set yourself

The curation step is essential. Extraction will find every value used; curation is where you say "these 8 grays are actually 4 intentional grays and 4 accidents."

## Contract Rules for CLAUDE.md

When using a design contract, add these rules to the project's CLAUDE.md:

```markdown
## Design Contract Rules

1. **No rogue values.** Every color, spacing value, font size, shadow, and border radius
   must reference a token from `design-contract.json`. If a new value is needed, propose
   adding it to the contract — do not use it inline.

2. **Semantic colors only in components.** Components reference semantic tokens
   (e.g., `text-primary`) not raw palette values (e.g., `neutral.900`).

3. **Spacing scale is strict.** No arbitrary pixel values for margin, padding, or gap.

4. **Test at all breakpoints.** Every page must be validated at mobile (375px),
   tablet (768px), and desktop (1440px).
```

## Programmatic Validation

Use `playwright-cli` to validate contract compliance after generating or modifying pages. These are DOM-based checks, no vision needed.

### What Playwright Can Check

- **Overflow detection** — Elements with horizontal overflow or extending past viewport
- **Color compliance** — Computed colors compared against contract values
- **Spacing validation** — Margin/padding values checked against the spacing scale
- **Typography compliance** — Font sizes checked against the type scale
- **Viewport testing** — All checks run at each defined breakpoint

See `~/.claude/docs/platforms/playwright-automation.md` for `playwright-cli` commands and patterns.

### What Still Requires Human Review

- Visual hierarchy and eye flow
- Emotional tone and appropriateness
- Layout balance and visual weight
- Content-design fit
- Responsive behavior beyond "doesn't overflow"
- Animation and interaction quality

The human reviewer shifts from copy editor (catching every inconsistency) to art director (making judgment calls about feel and flow).

## Tool Recommendations

### Immediate (no additional dependencies)

- **`playwright-cli` screenshot** — Visual regression baseline
- **Custom Playwright audit scripts** — DOM-based contract compliance checks
- **CLAUDE.md contract rules** — Instruction-level enforcement

### When the workflow is established

- **Dembrandt** — Extract tokens from live sites in W3C format
- **Style Dictionary v4** — Transform token JSON into CSS custom properties, Tailwind configs
- **@lapidist/design-lint** — Lint for rogue values not in the token set
