---
name: code-styling
description: Apply consistent coding style patterns when writing or reviewing code. Use when generating new code that should follow your established preferences. Works with any language. Complements linters (which handle formatting) with higher-level style decisions.
---

# Code Styling Profile

Apply these coding style preferences during the **refactor phase**, not initial implementation. This skill captures style decisions that linters don't enforce.

## When to Use

- **Refactor phase** - After code is working, before final commit
- **Cleanup requests** - "Clean this up", "apply my style", "refactor"
- **Code review** - When suggesting improvements to existing code

During initial implementation, focus on getting things working. Apply these patterns when polishing.

---

## Core Philosophy

### 1. Clever Solutions Made Readable

Write solutions that are both elegant and easy to understand. Invest time making clever approaches accessible. It's not cleverness OR readability - it's cleverness expressed clearly.

### 2. Organize for Future Flexibility

Structure code so it can adapt to change. Trade short-term simplicity for long-term flexibility when the investment is worthwhile. Modular systems, data-driven configuration, and clear separation of concerns.

### 3. Explicit Over Implicit

Dependencies passed in, not magically available. Configuration visible, not hidden. Make the code's requirements and behavior obvious from reading it.

### 4. Composition Over Inheritance

Build from small, focused pieces. Combine simple functions and modules rather than creating deep hierarchies. Prefer flat structures that can be rearranged.

---

## Organization Patterns

### File & Folder Structure

Organize by **function**, not by type. Group related code together.

**Good:**
```
partials/
  header/
    site-header.html
    site-nav.html
  footer/
    site-footer.html
    copyright.html
  components/
    button.html
    form.html
```

**Avoid:**
```
partials/
  header.html
  footer.html
  nav.html
  button.html
  form.html
```

### When to Extract

- **Extract** when a pattern repeats 3+ times with clear purpose
- **Extract** when a section has a distinct, nameable responsibility
- **Inline** when extraction would obscure meaning
- **Inline** for one-time operations - three similar lines is better than a premature abstraction

### Naming Conventions

| Type | Convention | Example |
|------|------------|---------|
| Files | kebab-case | `form-builder.html`, `insert-template.js` |
| Classes | PascalCase | `ServiceContainer`, `ContentPipeline` |
| Functions/Methods | camelCase | `handleSubmit`, `findOrCreate` |
| Variables | camelCase | `activeUsers`, `teamSettings` |
| Private fields (JS) | `#` prefix | `#settings`, `#dependencies` |
| Constants | SCREAMING_SNAKE | `DEFAULT_TIMEOUT`, `MAX_RETRIES` |
| CSS custom properties | `--semantic-name` | `--color-accent`, `--fs-xl` |

**Naming principles:**
- Descriptive over abbreviated - `teamSettings` not `ts`
- Intent-revealing - `isValidKey()` not `check()`
- Domain language when appropriate to the project

---

## Control Flow

### Guard Clauses Over Nested Conditionals

This is a core pattern. Flatten control flow with early returns.

**Before (avoid):**
```javascript
function process(user) {
  if (user) {
    if (user.isActive) {
      if (user.hasPermission) {
        return doWork(user)
      } else {
        return { error: 'No permission' }
      }
    } else {
      return { error: 'User inactive' }
    }
  } else {
    return { error: 'No user' }
  }
}
```

**After (preferred):**
```javascript
function process(user) {
  if (!user) return { error: 'No user' }
  if (!user.isActive) return { error: 'User inactive' }
  if (!user.hasPermission) return { error: 'No permission' }

  return doWork(user)
}
```

### Early Returns

Exit as soon as you know the answer. Don't wrap entire functions in conditionals.

```javascript
// Good
function getValue(key) {
  if (!this.isValidKey(key)) return undefined
  return this.data[key]
}

// Avoid
function getValue(key) {
  let result
  if (this.isValidKey(key)) {
    result = this.data[key]
  }
  return result
}
```

### Avoid If-Else When Possible

Use if-return guard clauses. Reserve `else` for true binary choices.

```javascript
// Good - guard clause
if (error) return handleError(error)
return processSuccess(data)

// Acceptable - true binary
const status = isComplete ? 'done' : 'pending'

// Avoid - unnecessary else
if (error) {
  return handleError(error)
} else {
  return processSuccess(data)
}
```

### Maximum Nesting: 3 Levels

If you're deeper than 3 levels, extract a function or use guard clauses.

---

## Data-Driven Design

Prefer configuration over hardcoded logic. Build systems that can adapt without code changes.

### Configuration Objects

```javascript
// Good - data-driven
const destinations = {
  bear: { action: 'send-to-bear', scrubText: true },
  drafts: { action: 'new-draft', scrubText: false }
}

function send(destination) {
  const config = destinations[destination]
  if (!config) return handleError('Unknown destination')
  return execute(config)
}

// Avoid - hardcoded branches
function send(destination) {
  if (destination === 'bear') {
    return sendToBear({ scrubText: true })
  } else if (destination === 'drafts') {
    return sendToDrafts({ scrubText: false })
  }
}
```

### External Configuration (YAML, JSON, TOML)

For complex or user-editable configuration, externalize to data files.

```yaml
# data/forms/contact.yaml
formID: abc123
submitText: Send Message
fields:
  - id: name
    type: text
    required: true
  - id: email
    type: email
    required: true
```

### UI from Data Structures

Build user interfaces from configuration rather than hardcoded markup.

```javascript
// Define menu structure as data
const menuItems = [
  { label: 'Home', action: 'navigate', path: '/' },
  { label: 'Settings', action: 'modal', target: 'settings-panel' }
]

// Render from data
menuItems.forEach(item => createMenuItem(item))
```

---

## CSS & Styling

### Modern Features First

Use the latest CSS features. Prefer native CSS over preprocessors when possible.

**Prioritize:**
- CSS custom properties for theming and configuration
- `clamp()` for fluid typography and spacing
- CSS Grid and Flexbox for layout
- Container queries when appropriate
- Native nesting (when browser support allows)

### Custom Properties Pattern

```css
:root {
  /* Colors - semantic naming */
  --color-bg: #ffffff;
  --color-fg: #212931;
  --color-accent: #85a6de;

  /* Typography - fluid scaling */
  --fs-xl: clamp(1.5rem, 8vw + 0.4rem, 4.5rem);
  --fs-400: clamp(1rem, 1vw + 1rem, 1.6rem);

  /* Spacing */
  --space-s: clamp(0.5rem, 2vw, 1rem);
  --space-m: clamp(1rem, 4vw, 2rem);

  /* Layout */
  --content-width: min(85%, 44em);
}
```

### SCSS: Modular When Used

If using SCSS, organize in layers:

```
scss/
  main.scss           # Entry point (@use imports)
  libs/               # Variables, functions, mixins
  base/               # Reset, typography, page
  components/         # One file per component
  layout/             # Header, footer, nav, main
```

Use `@use` not `@import`. Keep each file focused on one thing.

---

## Code Clarity

### Section Markers

Use visual separators for large files with distinct sections:

```javascript
// **********************
// Getters/Setters
// **********************

get settings() { ... }

// **********************
// Private Methods
// **********************

#validateInput() { ... }
```

### Minimal Comments

Code should be self-documenting. Comment only when:
- Explaining **why**, not what
- Documenting non-obvious business logic
- Warning about gotchas or edge cases

```javascript
// Good - explains why
// Drafts doesn't support ES modules, so we use require
if (typeof Settings == "undefined") require("libraries/Settings.js")

// Avoid - states the obvious
// Loop through users
users.forEach(user => ...)
```

### JSDoc for Public APIs

Document public interfaces, especially in libraries:

```javascript
/**
 * Register a service with lazy instantiation
 * @param {string} name - Service identifier
 * @param {Function} factory - Factory function that creates the service
 * @param {boolean} singleton - Whether to cache the instance (default: true)
 */
register(name, factory, singleton = true) { ... }
```

### Fix Spelling Errors

Correct typos in variable names, function names, and comments. Consistency matters for searchability and professionalism.

---

## Language-Specific Patterns

### JavaScript/TypeScript

```javascript
// Use const by default, let only when reassignment needed
const settings = loadSettings()
let counter = 0

// Lazy initialization via getters
get service() {
  if (!this.#service) {
    this.#service = new Service()
  }
  return this.#service
}

// Optional chaining and nullish coalescing
const name = user?.profile?.name ?? 'Anonymous'

// Destructuring for clarity
const { menuSettings, errorMessage } = this.#settings

// Conditional require for environments that need it
if (typeof Module == "undefined") require("path/to/Module.js")
```

### Ruby/Rails

```ruby
# Memoization pattern
def settings
  @settings ||= load_settings
end

# find_or_create for lookup tables
Factura.find_or_create_by(descr: numero, fecha: fecha)

# Guard clauses
def process(user)
  return { error: 'No user' } unless user
  return { error: 'Inactive' } unless user.active?

  do_work(user)
end

# Scoped queries - build dynamically
scope = Model.all
scope = scope.where(status: params[:status]) if params[:status]
scope = scope.order(params[:order] || 'created_at')
```

### Hugo/Go Templates

```html
{{/* Partial organization by location */}}
{{ partial "header/site-nav" . }}
{{ partial "components/button" . }}

{{/* Data-driven sections */}}
{{ range where site.RegularPages "Type" "homepage" }}
  {{ partial (printf "sections/%s" .Params.section_type) . }}
{{ end }}

{{/* Guard clauses in templates */}}
{{ if not .Params.title }}{{ return }}{{ end }}
```

### CSS

```css
/* Semantic custom properties */
--color-accent: #85a6de;

/* Fluid typography with clamp() */
font-size: clamp(1rem, 2vw + 0.5rem, 1.5rem);

/* Logical properties */
padding-block: var(--space-m);
margin-inline: auto;

/* Container-based sizing */
max-width: min(85%, 44em);
```

---

## Anti-Patterns to Avoid

### Nested Conditionals

Already covered above. Flatten with guard clauses.

### Magic Values

```javascript
// Avoid
if (status === 3) { ... }
setTimeout(fn, 86400000)

// Prefer
const STATUS_COMPLETE = 3
const ONE_DAY_MS = 24 * 60 * 60 * 1000

if (status === STATUS_COMPLETE) { ... }
setTimeout(fn, ONE_DAY_MS)
```

### Implicit Dependencies

```javascript
// Avoid - relies on global state
function process() {
  return currentUser.settings.theme  // Where does currentUser come from?
}

// Prefer - explicit
function process(user) {
  return user.settings.theme
}
```

### Over-Abstraction

Don't extract until you need to. Three similar lines is often better than a helper function used once.

### Backwards-Compatibility Clutter

Don't keep dead code, unused exports, or `// removed` comments. Delete cleanly.

---

## Integration Notes

This skill complements:
- **code-simplifier agent** - Uses these patterns when refactoring
- **pre-commit-reviewer** - Catches violations of these patterns
- **Project linters** - Handle formatting; this handles style

When conflicts occur, explicit project standards (CLAUDE.md, linter configs) take precedence over this skill.
