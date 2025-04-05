{ pkgs, lib, config, darwin, nix-homebrew, homebrew-core, homebrew-cask, ... }: {
  
  imports = [
    ./base.nix
    ./pkgs/programing.nix
    ./mas
  ];

  baseModule.enable = lib.mkDefault true;
  programmingPkgsModule.enable = lib.mkDefault false;
  masModule.enable = lib.mkDefault false;
  
  programmingMasModule.enable = lib.mkDefault true;
  writtingMasModule.enable = lib.mkDefault true;
  personalMasModule.enable = lib.mkDefault true;
  photographyMasModule.enable = lib.mkDefault true;
}