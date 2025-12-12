# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a macOS dotfiles repository managed with GNU Stow and nix-darwin. The dotfiles are symlinked to `$HOME` using Stow, while system packages and configuration are managed declaratively through Nix flakes.

## Key Commands

### Applying dotfiles with Stow
```bash
# From the dotfiles directory
stow .

# Or using nix-shell if stow isn't installed
nix-shell -p stow --run 'stow .'
```

### Nix-Darwin Operations
```bash
# Initial nix-darwin installation
nix --extra-experimental-features 'nix-command flakes' run nix-darwin -- switch --flake .config/nix#<hostname>

# Rebuild system configuration (available hostnames: desktop, vm, server)
darwin-rebuild switch --flake .config/nix#desktop
```

### Shell Configuration
```bash
# Reload zsh configuration
source ~/.zshrc
# Or use the alias:
reload
```

## Architecture

### Stow Structure
The repository root contains dotfiles/directories that get symlinked to `$HOME`. The `.stow-local-ignore` file excludes version control files, templates (*.tpl), and documentation from being symlinked.

### Nix-Darwin Configuration (`.config/nix/`)
- `flake.nix` - Main flake defining system configurations for different hosts
- `roles/` - Host-specific configurations (desktop, vm)
- `programs/` - Shared program/package definitions
  - `base.nix` - Core packages (alacritty, atuin, eza, fzf, git, zellij, etc.) and system defaults
  - `mas/` - Mac App Store app configurations
- `hosts/` - User-specific configurations

### Zsh Configuration
- `.zshrc` - Main shell config using Zinit plugin manager
- `.oh-my-zsh/custom/*.zinit.zsh` - Modular configs:
  - `aliases.zinit.zsh` - Shell aliases (eza, zellij, etc.)
  - `paths.zinit.zsh` - PATH modifications for homebrew, node, go, pnpm
  - `binds.zinit.zsh` - Key bindings

### Application Configs (`.config/`)
- `nvim/` - LazyVim-based Neovim configuration
- `zellij/` - Terminal multiplexer config (KDL format)
- `alacritty/` - Terminal emulator config
- `ghostty/` - Terminal emulator config
- `ohmyposh/` - Shell prompt theme
- `atuin/` - Shell history sync
- `karabiner/` - Keyboard customization
- `yazi/` - File manager config

## Common Aliases

- `l`, `la`, `lt` - eza (modern ls) variants
- `za`, `zl` - zellij attach/list
- `y` - yazi file manager with directory following
- `k` - kubectl
- `br` - bun run
- `gi <types>` - Generate .gitignore from gitignore.io
