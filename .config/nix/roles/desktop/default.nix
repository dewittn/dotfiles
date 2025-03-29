# This file sets the defaults for which modules are loaded
{ pkgs, lib, config, self, nix-homebrew, homebrew-core, homebrew-cask, ... }: {

  imports = [
    ../../programs
  ];

  baseModule.enable = true;
  programmingModule.enable = true;
}