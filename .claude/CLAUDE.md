# Global Claude Configuration

Documentation at ~/.claude/docs/ captures patterns pre-training gets wrong.

## Hard Rules

These override default behavior. They exist because Claude repeatedly gets them wrong.

- **NEVER use `git commit -C`** — Always write a fresh commit message based on the actual changes. The `-C` flag reuses old messages which are often wrong for the new commit.
- **NEVER use `git -C <path>`** — Always run git commands directly from the current working directory. The `-C` flag is redundant when already in the project directory and triggers unnecessary permission prompts.
- **Use `skill-creator` when editing or creating skills** — Any work on `.claude/skills/`, `.claude/commands/`, or SKILL.md files MUST consult the skill-creator skill for structure, frontmatter, and progressive disclosure patterns.

## Index

| Path | Topics |
|------|--------|
| infrastructure/docker-contexts.md | Context switching, orbstack vs coto-v3 |
| infrastructure/volume-safety.md | Volume deletion, data loss prevention |
| infrastructure/swarm-stacks.md | Stack naming, templates, rollback |
| infrastructure/healthchecks.md | Healthcheck config, minimal images |
| infrastructure/cicd-pipelines.md | GitHub Actions, reusable workflows |
| platforms/ghost-themes.md | Templates, routes.yaml, member access |
| platforms/hugo-development.md | Dev server, builds, Docker deployment |
| platforms/playwright-automation.md | playwright-cli commands, viewports, browser install, workflows |
| coding/style-guide.md | Style patterns, control flow, data-driven design |
| planning/README.md | Workflow chain overview, when to use each stage |
| planning/frontend-design.md | Design contracts, W3C DTCG tokens, Playwright validation |
| planning/agentic-systems.md | LLM agents, tool use, intelligence boundaries |
| planning/infrastructure.md | Docker, deployment, CI/CD, config hierarchy, observability |
