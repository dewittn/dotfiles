# Getting started

## Install x-code

## Install Nix

```
curl -L https://nixos.org/nix/install | sh
```

## Install Homebrew

```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

## Download dotfiles

```
git clone https://github.com/dewittn/dotfiles.git
```

## Stow dotfiles

```
nix-shell -p stow --run 'stow .'
```

## Install Nix-Darwin

```
nix run nix-darwin -- switch --flake .config/nix#<hostname>
```
