{ pkgs, lib, ... }: {

  imports = [
    ./programs/base.nix
    # ./programs/photography.nix
    # ./programs/web-dev.nix
    # ./programs/writing.nix
  ];

  baseModule.enable = lib.mkDefault true;

}