{ pkgs, lib, config, darwin, nix-homebrew, homebrew-core, homebrew-cask, ... }: {
  
  imports = [
    ./base.nix
    ./pkgs/programing.nix
    ./mas
  ];

  baseModule.enable = lib.mkDefault true;
  programmingPkgsModule.enable = lib.mkDefault false;
  
  programmingMasModule.enable = lib.mkDefault false;
  writtingMasModule.enable = lib.mkDefault false;
  personalMasModule.enable = lib.mkDefault false;
  photographyMasModule.enable = lib.mkDefault false;
}