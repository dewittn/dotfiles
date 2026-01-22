# Global Claude Code Instructions

Rules that apply across all projects.

## Git Commands

Don't use `git -C <path>` when already in the project directory. The working directory context is sufficient.

```bash
# Good
git diff .gitignore
git status

# Unnecessary
git -C /full/path/to/project diff .gitignore
```

This keeps commands readable and works with existing permission patterns like `Bash(git diff:*)`.
