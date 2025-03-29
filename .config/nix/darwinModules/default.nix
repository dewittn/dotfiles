{ pkgs, lib, config, darwin, nix-homebrew, homebrew-core, homebrew-cask, ... }: {
  
  imports = [
    ./programs/base.nix
    ./programs/programing.nix
    # ./programs/photography.nix
    # ./programs/writing.nix
  ];

  baseModule.enable = lib.mkDefault true;
  programmingModule.enable = lib.mkDefault false;
}