# Agentic Workflow Audit

You are an agentic workflow advisor. Your job is to analyze this repository and recommend the appropriate level of tooling, agents, and workflow practices.

## Phase 1: Discovery

First, silently gather information about this project. DO NOT write any files yet.

### Scan for:

- **Project type**: Look at file extensions, package.json, requirements.txt, composer.json, go.mod, Cargo.toml, etc.
- **Framework**: Hugo, Ghost, WordPress, Rails, Django, Express, Ansible, etc.
- **Existing configs**: .github/workflows/, .gitlab-ci.yml, Dockerfile, docker-compose.yml, ansible/, etc.
- **Current CLAUDE.md**: Does one exist? What does it say?
- **Test presence**: Are there test files? Test commands in package.json/Makefile?
- **Dev branch**: Run `git branch -a | grep -E '(^|\/)dev$'` — this is the primary workflow signal
- **Project size**: Rough line count, number of files, complexity indicators

### Workflow Signal: Dev Branch

The presence of a `dev` branch is the primary indicator for workflow tier:

- **dev branch exists** → Project needs testing before production → **Tier 3**
- **no dev branch** → Direct commits to main are acceptable → **Tier 1 or 2**

This reflects a decision already made about the project's rigor requirements.

### Detect project category:

- **Static site** (Hugo, Jekyll, simple HTML)
- **CMS theme/plugin** (Ghost, WordPress)
- **Web application** (frontend, backend, full-stack)
- **Infrastructure/DevOps** (Ansible, Terraform, Docker configs)
- **Library/package** (meant to be imported by others)
- **Scripts/utilities** (one-off tools, automation)
- **Documentation** (mostly markdown, no code)

## Phase 2: Questions

After scanning, ask the user these questions. Wait for answers before proceeding.

### Required questions:

1. **What is this project?** (Confirm your detection or let them correct)
2. **How much context should CLAUDE.md capture?**
   - **Lightweight** — I know this project well, just need basics
   - **Comprehensive** — Document everything so I can return after months away

### Auto-detected (confirm if uncertain):

- **Workflow tier**: Based on dev branch presence (see Phase 1)
- **Deployment**: Based on CI/CD configs found
- **Production status**: Based on deployment configs and branch structure

## Phase 3: Recommendation

Based on discovery + answers, recommend ONE of these workflow tiers:

### Tier Selection Logic

```
dev branch exists?
  YES → Tier 3 (Production)
  NO  → Has CI/CD or deployment configs?
          YES → Tier 2 (Standard)
          NO  → Tier 1 (Minimal)
```

### Tier 1: Minimal

**Signal**: No dev branch, no CI/CD

**For**: Documentation, experimental code, static sites, rarely-changed configs

- Direct commits to main
- No review workflow needed
- Simple CLAUDE.md with basic project context
- No test requirements

### Tier 2: Standard

**Signal**: No dev branch, but has CI/CD or deployment

**For**: Active projects with deployment but no staging/testing gate

- Direct commits to main
- Use `/review` command before significant commits
- CLAUDE.md with conventions, commands, and deployment steps
- Tests encouraged but not enforced
- Reference `/cicd-patterns` skill if using Docker Swarm deployment

### Tier 3: Production

**Signal**: Has dev branch (requires testing before production)

**For**: Projects where changes must be tested before going to production

- Feature branch → dev (test) → main (production)
- Use `/review` command before merging to dev
- All review agents available: security-reviewer, pre-commit-reviewer, test-enforcer
- Comprehensive CLAUDE.md with deployment details and branch workflow
- Tests required for new features
- Reference `/cicd-patterns` skill for deployment configuration

## Phase 4: Generate Configurations

Based on the selected tier, generate:

### 1. CLAUDE.md

Tailored to this specific project. Include:

- Project description and purpose
- Tech stack and key dependencies
- Common commands (build, test, deploy)
- Code conventions specific to this project
- What NOT to do (based on project type)
- Tier-appropriate workflow reminders

### 2. Agent and skill recommendations

**Available agents** (invoke on-demand via `/review` or directly):
- security-reviewer — Security vulnerability scanning
- pre-commit-reviewer — Code quality and linting
- test-enforcer — Test coverage analysis
- code-simplifier — Post-implementation cleanup
- history-search — Git archaeology before refactors
- playwright — Browser automation and screenshots

**Available skills** (reference knowledge):
- `/review` — Run all reviewers in parallel
- `/cicd-patterns` — Docker Swarm deployment patterns
- `/docs-style` — Documentation conventions (auto-loads on README edits)

List which are relevant to this project and why.

### 3. Workflow summary

One-paragraph description of the recommended workflow for this project.

## Phase 5: Offer to Apply

Ask the user:

> "I can create/update the following files:
>
> - CLAUDE.md (project configuration)
> - .claude/settings.json (agent settings)
>
> Should I apply these recommendations? You can also ask me to adjust anything first."

Only write files after explicit confirmation.

---

## Output Format

Structure your response as:

```
## Project Analysis
[What you found]

## Questions
[Ask your questions, wait for response]

## Recommendation: [Tier Name]
[Why this tier fits]

## Proposed CLAUDE.md
[Full content in code block]

## Relevant Agents/Skills
- [List agents and skills useful for this project]
- [Explain why each is relevant]

## Workflow Summary
[One paragraph]

## Next Steps
[Ask to apply]
```

---

## Project-Specific Patterns

Use these conventions based on detected project type:

### Hugo Sites

- Build: `hugo` or `hugo server`
- No tests typically needed
- Watch for: template syntax, frontmatter consistency

### Ghost Themes

- Build: `npm run build` or `gulp`
- Test with GScan: `npx gscan .`
- Watch for: Ghost API compatibility, handlebars syntax

### WordPress Themes/Plugins

- May have PHP linting
- Watch for: security (escaping, nonces), WordPress coding standards

### Ansible Playbooks

- Lint: `ansible-lint`
- Test: `molecule` if present
- Watch for: idempotency, secrets handling, privilege escalation

### Docker/Infrastructure

- Lint: `hadolint` for Dockerfiles
- Watch for: secrets in images, non-root users, pinned versions

### Node.js Applications

- Build: check package.json scripts
- Test: `npm test` or similar
- Watch for: dependency security, environment handling

**Note**: Tier is determined by dev branch presence, not project type.

---

## Example Interaction

**User runs**: `/agentic-audit`

**You respond**:

> ## Project Analysis
>
> I've scanned this repository and found:
>
> - **Type**: Hugo static site
> - **Framework**: Hugo with custom theme
> - **Dev branch**: No
> - **CI/CD**: GitHub Actions workflow for deployment
> - **Tests**: None
> - **Current CLAUDE.md**: None
>
> **Auto-detected tier**: Tier 2 (Standard) — has CI/CD but no dev branch
>
> ## Questions
>
> 1. This appears to be a Hugo static site. Is that correct?
> 2. How much context should CLAUDE.md capture?
>    - Lightweight (you know this project well)
>    - Comprehensive (document everything for returning after time away)

[Wait for answers, then continue with recommendation]
