{ pkgs, lib, config, ... }: {
# List packages installed in system profile. To search by name, run:
# $ nix-env -qaP | grep wget
environment.systemPackages =
  [
    pkgs._1password-cli
    pkgs.docker
    pkgs.hugo
    pkgs.gh
    pkgs.git
    pkgs.node_22
    pkgs.bun
    pkgs.dino
    pkgs.linode-cli
  ];
};