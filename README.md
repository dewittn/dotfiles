# Getting started

## Sign Into App Store

Open the Mac App Store and sign in.

## Install x-code

```
xcode-select --install
```

## Install Rosetta

```
softwareupdate --install-rosetta
```

## Install Nix

```
curl -L https://nixos.org/nix/install | sh
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
nix --extra-experimental-features 'nix-command flakes' run nix-darwin -- switch --flake .config/nix#<hostname>
```

## Rebuild config

```
darwin-rebuild switch --flace .config/nix#
```
