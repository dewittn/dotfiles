# Code Style Guide

Style decisions that linters don't enforce. Apply during refactor phase, not initial implementation.

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

### Single-Line If Statements (JavaScript)

For simple guard clauses and assignments, prefer single-line if statements. This improves readability by keeping related logic compact.

```javascript
// Preferred - single line for simple operations
if (welcomeScreen.show() == false) return context.cancel();
if (!this.#settings) this.#settings = this.#services.get('cpSettings');
if (name == undefined) return handleError();

// Avoid - unnecessary braces for simple statements
if (welcomeScreen.show() == false) {
  return context.cancel();
}

if (!this.#settings) {
  this.#settings = this.#services.get('cpSettings');
}
```

**When to use multi-line:** If the body has multiple statements or the line becomes too long, use braces.

```javascript
// Multi-line when body is complex
if (!this.#settings) {
  this.#settings = this.#services.get('cpSettings');
  this.#settingsLoaded = true;
}
```

This is primarily a JavaScript preference - other languages may have different conventions.

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

### Extract Truthiness Checks into Named Methods

When a conditional checks complex logic, extract it into a method whose name describes what it's checking. This makes if statements read like natural language.

```javascript
// Preferred - descriptive getter encapsulates the check
get statusIsNotSet() {
  return this.status == "";
}

get destinationIsNotSet() {
  return this.destination == "" || this.destination == undefined;
}

get activeDocInPipeline() {
  return this.db.docIsInPipeline(this.#activeDoc);
}

// Usage reads like English
if (this.#activeDoc.statusIsNotSet) {
  this.#activeDoc.status = this.statuses.select(this.#activeDoc.title);
}

if (this.activeDocInPipeline) {
  return this.ui.displayAppMessage("info", docExistsMessage);
}
```

```javascript
// Avoid - inline complex logic
if (this.#activeDoc.status == "" || this.#activeDoc.status == undefined) {
  this.#activeDoc.status = this.statuses.select(this.#activeDoc.title);
}

if (this.db.docIsInPipeline(this.#activeDoc)) {
  return this.ui.displayAppMessage("info", docExistsMessage);
}
```

**Naming conventions for truthiness methods:**
- `is...` / `isNot...` - state checks (`isValid`, `isNotSet`)
- `has...` - possession checks (`hasPermission`, `hasRecords`)
- `can...` - capability checks (`canProcess`, `canEdit`)
- `...IsNotSet` / `...IsUndefined` - specific null/empty checks

This pattern is especially valuable when:
- The same check appears in multiple places
- The logic involves multiple conditions (`||`, `&&`)
- The check's purpose isn't immediately obvious from the code

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

### Externalize User-Facing Content

Prompts, templates, report formats, and user-facing messages belong in config/template files — not inline in code. The test: **would you want to tweak the wording without changing program logic?** If yes, externalize it.

```python
# Good - template loaded from file, editable without touching code
system_prompt = load_prompt("review-scoring")
banner = load_template("cli-banner", phase="pipeline", count=companies)

# Avoid - user-facing content buried in code
SYSTEM_PROMPT = """\
You are a job review agent. Score each listing on 6 dimensions...
"""  # 130 lines of prompt text inline

click.echo(f"\n{'='*60}")
click.echo("  Running pipeline")
click.echo(f"{'='*60}\n")
```

**Keep inline:** strings that change only when the surrounding code changes.
- Logger messages (`logger.info`, `logger.warning`) — developer-facing, read alongside code
- Structured error returns (`{"error": f"Unknown ATS: {ats}"}`) — machine-consumed API contracts
- JSON schemas and tool definitions — tightly coupled to their handler implementation
- Raise/exit messages (`raise ValueError(...)`) — developer/operator errors, fix is in the code

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

## Annotated Example

This excerpt from `ContentPipeline.js` demonstrates multiple patterns working together. Comments marked with `// PATTERN:` highlight specific style choices.

```javascript
// PATTERN: Conditional require - check before loading
if (typeof ServiceContainer == "undefined") require("core/ServiceContainer.js");

class ContentPipeline {
  // PATTERN: Static configuration - externalized, not hardcoded
  static basePath = "/Library/Data/cp/";
  static settingsFile = "cp/settings.yaml";

  // PATTERN: Private fields with # prefix
  #fs;
  #ui;
  #settings;
  #services;
  #activeDoc;

  constructor(table = "Content") {
    this.#tableName = table;
    this.#services = ServiceContainer.getInstance();
    this.#activeDoc = null;
    this.#registerServices(table);
    this.#loadWorkspace();
  }

  // PATTERN: Data-driven service registration
  // Configuration determines behavior, not hardcoded branches
  #registerServices(table) {
    if (!this.#services.has('cpSettings')) {
      this.#services.register('cpSettings', () => {
        if (typeof Settings == "undefined") require("libraries/Settings.js");
        return new Settings(this.settingsFile);  // Settings loaded from YAML file
      }, true);
    }

    if (!this.#services.has('cpUI')) {
      this.#services.register('cpUI', (c) => {
        if (typeof DraftsUI == "undefined") require("cp/ui/DraftsUI.js");
        const settings = c.get('cpSettings');
        return new DraftsUI(settings.ui);  // UI configured from settings
      }, true);
    }
  }

  // PATTERN: Lazy initialization via getters
  // Dependencies created on first access, not at construction
  // PATTERN: Single-line if for simple assignments
  get settings() {
    if (!this.#settings) this.#settings = this.#services.get('cpSettings');
    return this.#settings;
  }

  get ui() {
    if (!this.#ui) this.#ui = this.#services.get('cpUI');
    return this.#ui;
  }

  // PATTERN: Explicit dependency injection
  // Dependencies passed as object, not implicitly available
  #getDependencies() {
    return {
      ui: this.ui,
      fileSystem: this.fs,
      settings: this.settings,
      tableName: this.#tableName,
      textUtilities: this.text,
    };
  }

  // PATTERN: Truthiness getters - encapsulate checks with descriptive names
  // Makes if statements read like natural language
  get activeDocIsUndefined() {
    return this.#activeDoc == undefined;
  }

  get activeDocInPipeline() {
    return this.db.docIsInPipeline(this.#activeDoc);
  }

  // PATTERN: Section markers for visual organization
  // **************
  // * openDoc()
  // * Open content in Drafts or Ulysses
  // **************
  openDoc(docID, docIDType) {
    // PATTERN: Destructuring settings from configuration
    const { docNotFound, recentDocsNotSaved } = this.settings.openDoc;

    // PATTERN: Guard clause - handle undefined early
    // Note: Multi-line here because the body spans multiple lines
    if (this.#activeDoc == undefined) {
      this.#activeDoc = this.document_factory.load({ docID, docIDType });
    }

    // PATTERN: Early return with error context
    // Error objects include debugging information
    if (this.#activeDoc == undefined) {
      return this.ui.displayAppMessage("error", docNotFound, {
        errorMessage: docNotFound,
        activeDoc: this.#activeDoc,
      });
    }

    // PATTERN: Guard clause instead of nested if
    if (this.recentRecordsUpdated != true) {
      this.ui.displayAppMessage("info", recentDocsNotSaved, {
        recentRecordsUpdated: false,
        activeDoc: this.#activeDoc,
      });
    }

    this.#activeDoc.open();
  }

  // PATTERN: Data-driven menu building
  // UI structure comes from settings, not hardcoded
  welcome() {
    const { menuPicker, menuSettings, errorMessage } = this.ui.settings("welcome");

    this.ui.utilities.addRecordColomsToMenuPicker(
      menuPicker,
      menuSettings,
      this.recent.records,
    );

    const welcomeScreen = this.ui.buildMenu(menuSettings);

    // PATTERN: Early return on cancel
    if (welcomeScreen.show() == false) return context.cancel();

    const nextFunction = welcomeScreen.buttonPressed;
    this.#functionToRunNext(nextFunction);
  }

  // PATTERN: Private helper keeps public methods clean
  #functionToRunNext(name, args) {
    const errorMessage = "Function name missing!";

    // PATTERN: Guard clause
    if (name == undefined) {
      return this.ui.displayAppMessage("error", errorMessage, {
        errorMessage: errorMessage,
        class: "ContentPipeline",
        function: "#functionToRunNext()",
        name: name,
      });
    }

    if (Array.isArray(args) == false) args = [args];
    return this[name].apply(this, args);
  }
}
```

### Patterns Demonstrated

| Pattern | Description |
|---------|-------------|
| Conditional require | Check before loading modules |
| Static configuration | Settings externalized to files |
| Private fields | `#` prefix for encapsulation |
| Data-driven services | Registration via configuration |
| Lazy initialization | Getters create on first access |
| Single-line if | Compact guard clauses and assignments |
| Truthiness getters | Named methods for boolean checks |
| Explicit dependencies | Pass as object, not global |
| Section markers | Visual organization |
| Guard clauses | Early returns, flat control flow |
| Error context | Debug info in error objects |
| Data-driven UI | Menu structure from settings |
