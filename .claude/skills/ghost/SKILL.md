---
name: ghost
description: Ghost theme development patterns and gotchas. Consult when working on Ghost themes for routing, templates, member access, and known limitations.
---

# Ghost Theme Development

Lightweight orientation for Ghost theme development. Consult when working with templates, routing, or member features.

## Template Hierarchy

| File | Purpose |
|------|---------|
| `default.hbs` | Base layout (contains `{{{body}}}`) |
| `index.hbs` | Homepage |
| `post.hbs` | Single post |
| `page.hbs` | Static page |
| `tag.hbs` | Tag archive |
| `author.hbs` | Author archive |
| `error.hbs` | Error pages (restricted helpers) |
| `custom-*.hbs` | Custom post templates (selectable in editor) |

**Partials:** `partials/*.hbs` — included via `{{> partial-name}}`

## Routes Configuration

`routes.yaml` defines URL structure. **Critical rule:** The catch-all collection must be last or posts won't get proper URLs.

```yaml
collections:
  /special/:           # Filtered collection
    permalink: /special/{slug}/
    filter: tag:special
    template: custom-template
  /:                   # Catch-all (MUST BE LAST)
    permalink: /{slug}/
    template: index
```

**Deploying changes:**
- Local: Restart Ghost container
- Production: Upload via Ghost Admin → Settings → Labs → Routes

## Common Helpers

| Helper | Purpose | Example |
|--------|---------|---------|
| `{{asset}}` | Asset paths | `{{asset "css/theme.css"}}` |
| `{{img_url}}` | Responsive images | `{{img_url feature_image size="m"}}` |
| `{{excerpt}}` | Truncated content | `{{excerpt words="30"}}` |
| `{{date}}` | Formatted date | `{{date format="MMMM D, YYYY"}}` |
| `{{reading_time}}` | Read estimate | `{{reading_time}}` |
| `{{content}}` | Post body | `{{content}}` |
| `{{navigation}}` | Site menu | `{{navigation}}` |
| `{{pagination}}` | Page navigation | `{{pagination}}` |
| `{{t}}` | Translation | `{{t "Read more"}}` |

## Context Variables

| Variable | Contains |
|----------|----------|
| `@site` | Site config (title, url, logo, description) |
| `@custom` | Theme settings from package.json |
| `@member` | Current member (null if logged out) |
| `@member.paid` | Boolean: paid subscriber? |
| `@index` | Loop index in `{{#foreach}}` |

## Member Access Patterns

```handlebars
{{!-- Check if member is logged in --}}
{{#if @member}}
  Welcome back!
{{/if}}

{{!-- Paid-only content --}}
{{#if @member.paid}}
  Premium content here
{{/if}}

{{!-- Content visibility check --}}
{{#has visibility="paid"}}
  {{!-- Post is paywalled --}}
{{/has}}

{{!-- Limit free preview items --}}
{{#foreach posts}}
  {{#match @index "<" 3}}
    {{!-- Show first 3 to everyone --}}
  {{/match}}
{{/foreach}}
```

**Portal links:**
- `#/portal/signup` — Sign up modal
- `#/portal/signin` — Sign in modal
- `#/portal/account` — Member account

## Conditional Helpers

```handlebars
{{#is "post"}}...{{/is}}        {{!-- Context is a post --}}
{{#is "page"}}...{{/is}}        {{!-- Context is a page --}}
{{#has tag="featured"}}...{{/has}}  {{!-- Has specific tag --}}
{{#if featured}}...{{/if}}      {{!-- Is featured post --}}
{{#if access}}...{{/if}}        {{!-- User can access content --}}
```

## Known Gotchas

### error.hbs is restricted
Only `{{asset}}` helper works. Use `error-404.hbs` for themed error pages.

### Header/content wrapper pattern
Header partials open containers that `content.hbs` closes:
```handlebars
{{!-- post-header-*.hbs opens --}}
<article class="ms-article">
  <header>...</header>
  <div class="wrapper">
{{!-- content.hbs closes them --}}
```

### Ghost doesn't support multiple replicas
Always use `replicas: 1`. Multiple instances cause 405 errors, session logout, and theme sync issues (in-memory sessions, no Redis support). Scale via CDN caching, not replicas. Use `order: start-first` for zero-downtime deploys.

### Image sizes defined in package.json
```json
"image_sizes": {
  "xs": { "width": 150 },
  "s": { "width": 300 },
  "m": { "width": 750 },
  "l": { "width": 1000 }
}
```

## Validation

```bash
# Ghost theme linter
bun run test        # or: npx gscan .

# Check for errors
gscan --fatal       # Fail on warnings too
```
