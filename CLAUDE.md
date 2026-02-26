# CLAUDE.md

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

## Workflow

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
