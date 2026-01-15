# CLAUDE.md

This file provides guidance to Claude Code when working with this repository.

## Repository Overview

Personal macOS dotfiles repository managed with GNU Stow. These configs are actively used daily across multiple machines and synced via Ansible.

**These are production configs** — changes affect the daily work environment immediately.

## Key Commands

### Applying changes
```bash
# Symlink dotfiles to $HOME
stow .

# Reload shell configuration
source ~/.zshrc
# Or use alias:
reload
```

### Validation (run before committing)
```bash
# Check zsh syntax
zsh -n ~/.zshrc

# Check shell scripts
shellcheck .oh-my-zsh/custom/*.zsh 2>/dev/null || true
```

## Architecture

### Stow Structure
Repository root contains dotfiles/directories symlinked to `$HOME`. The `.stow-local-ignore` excludes version control files, templates (`*.tpl`), and documentation.

### Zsh Configuration
- `.zshrc` — Main config using Zinit plugin manager
- `.oh-my-zsh/custom/*.zinit.zsh` — Modular configs:
  - `aliases.zinit.zsh` — Shell aliases
  - `paths.zinit.zsh` — PATH modifications
  - `binds.zinit.zsh` — Key bindings

### Application Configs (`.config/`)
| Directory | Purpose |
|-----------|---------|
| `nvim/` | LazyVim-based Neovim |
| `zellij/` | Terminal multiplexer (KDL) |
| `alacritty/` | Terminal emulator |
| `ghostty/` | Terminal emulator |
| `ohmyposh/` | Shell prompt theme |
| `atuin/` | Shell history sync |
| `karabiner/` | Keyboard customization |
| `yazi/` | File manager |

### Claude Code (`.claude/`)
- `agents/` — Subagent definitions
- `skills/` — Custom skill prompts
- `settings.json` — Permissions and config

## Common Aliases

- `l`, `la`, `lt` — eza (modern ls) variants
- `za`, `zl` — zellij attach/list
- `y` — yazi with directory following
- `k` — kubectl
- `br` — bun run
- `gi <types>` — Generate .gitignore

## Workflow

### Git
- Direct commits to `main` (no PRs needed for dotfiles)
- Always pull before editing: `git pull`
- Always push after committing: `git push`
- Write clear commit messages — these sync to other machines

### Before Committing
1. Test changes locally (`reload` or restart terminal)
2. Verify no syntax errors in shell configs
3. Consider: "Will this break on my other machines?"

### If Something Breaks
```bash
# Quick rollback
git checkout HEAD~1 -- <broken-file>
stow .
reload

# Or reset entirely
git reset --hard HEAD~1
stow .
reload
```

## What NOT to Do

- **Don't commit untested shell changes** — a broken `.zshrc` breaks the terminal
- **Don't add machine-specific paths** — these sync to multiple machines
- **Don't store secrets** — use environment variables or separate credential stores
- **Don't modify Neovim plugin configs without testing** — LazyVim can be finicky
- **Don't remove aliases without checking dependencies** — other scripts may use them

## Config File Formats

| File type | Format | Validation |
|-----------|--------|------------|
| `*.zsh` | Zsh script | `zsh -n <file>` |
| `*.kdl` | KDL (Zellij) | Zellij validates on load |
| `*.toml` | TOML | Most tools validate on load |
| `*.lua` | Lua (Neovim) | `nvim --headless -c 'quit'` |
| `karabiner.json` | JSON | Karabiner validates on load |
