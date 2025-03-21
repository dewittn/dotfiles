{ pkgs, lib, inputs, ... }: {
  
  imports = [
    (import ./programs/base.nix inputs)
    # ./programs/photography.nix
    # ./programs/web-dev.nix
    # ./programs/writing.nix
  ];

  baseModule.enable = lib.mkDefault true;
}