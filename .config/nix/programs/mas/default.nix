{ pkgs, lib, config, darwin, nix-homebrew, homebrew-core, homebrew-cask, ... }: {
  
  imports = [
    ./photography.nix
    ./programing.nix
    ./personal.nix
    ./writing.nix
  ];

}