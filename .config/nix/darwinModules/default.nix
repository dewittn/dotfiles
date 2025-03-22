{ pkgs, lib, config, darwin, nix-homebrew, homebrew-core, homebrew-cask, ... }: {
  
  imports = [
    ./programs/base.nix
    # ./programs/photography.nix
    # ./programs/web-dev.nix
    # ./programs/writing.nix
  ];

  baseModule.enable = lib.mkDefault true;
}