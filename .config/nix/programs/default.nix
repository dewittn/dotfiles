{ pkgs, lib, config, darwin, nix-homebrew, homebrew-core, homebrew-cask, ... }: {
  
  imports = [
    ./base.nix
    ./pkgs/programing.nix
    ./mas
  ];

  baseModule.enable = lib.mkDefault true;
  programmingPkgsModule.enable = lib.mkDefault false;
  masModule.enable = lib.mkDefault false;
}