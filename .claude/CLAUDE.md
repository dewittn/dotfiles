# Global Claude Configuration

Documentation at ~/Programing/dewittn/agentic-docs/ captures patterns pre-training gets wrong.

## Hard Rules

These override default behavior. They exist because Claude repeatedly gets them wrong.

- **NEVER use `git commit -C`** — Always write a fresh commit message based on the actual changes. The `-C` flag reuses old messages which are often wrong for the new commit.
- **NEVER use `git -C <path>`** — Always run git commands directly from the current working directory. The `-C` flag is redundant when already in the project directory and triggers unnecessary permission prompts.
- **Use `skill-creator` when editing or creating skills** — Any work on `.claude/skills/`, `.claude/commands/`, or SKILL.md files MUST consult the skill-creator skill for structure, frontmatter, and progressive disclosure patterns.

## Index

| Path | Topics |
|------|--------|
| ~/Programing/dewittn/agentic-docs/infrastructure/docker-contexts.md | Context switching, orbstack vs coto-v3 |
| ~/Programing/dewittn/agentic-docs/infrastructure/volume-safety.md | Volume deletion, data loss prevention |
| ~/Programing/dewittn/agentic-docs/infrastructure/swarm-stacks.md | Stack naming, templates, rollback |
| ~/Programing/dewittn/agentic-docs/infrastructure/healthchecks.md | Healthcheck config, minimal images |
| ~/Programing/dewittn/agentic-docs/infrastructure/cicd-pipelines.md | GitHub Actions, reusable workflows |
| ~/Programing/dewittn/agentic-docs/platforms/ghost-themes.md | Templates, routes.yaml, member access |
| ~/Programing/dewittn/agentic-docs/platforms/hugo-development.md | Dev server, builds, Docker deployment |
| ~/Programing/dewittn/agentic-docs/platforms/playwright-automation.md | playwright-cli commands, viewports, browser install, workflows |
| ~/Programing/dewittn/agentic-docs/coding/style-guide.md | Style patterns, control flow, data-driven design |
| ~/Programing/dewittn/agentic-docs/planning/README.md | Workflow chain overview, tool table, common paths |
| ~/Programing/dewittn/agentic-docs/planning/methodology.md | Zoom hierarchy, artifact flow, quality gates, commit rules |
| ~/Programing/dewittn/agentic-docs/planning/frontend-design.md | Design contracts, W3C DTCG tokens, Playwright validation |
| ~/Programing/dewittn/agentic-docs/planning/agentic-systems.md | LLM agents, tool use, intelligence boundaries |
| ~/Programing/dewittn/agentic-docs/planning/infrastructure.md | Docker, deployment, CI/CD, config hierarchy, observability |
