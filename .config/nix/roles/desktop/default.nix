# This file sets the defaults for which modules are loaded
{ pkgs, lib, config, self, nix-homebrew, homebrew-core, homebrew-cask, ... }: {

  imports = [
    ../../programs
  ];

  baseModule.enable = true;
  programmingModule.enable = true;
  
  programmingMasModule.enable = lib.mkDefault true;
  writtingMasModule.enable = lib.mkDefault true;
  personalMasModule.enable = lib.mkDefault true;
  photographyMasModule.enable = lib.mkDefault true;
}