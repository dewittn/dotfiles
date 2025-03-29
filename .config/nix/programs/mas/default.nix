{ pkgs, lib, config, darwin, nix-homebrew, homebrew-core, homebrew-cask, ... }: {
  
  imports = [
    ./photography.nix
    ./programing.nix
    ./personal.nix
    ./writing.nix
  ];
  
  options = {
    masModule.enable = lib.mkEnableOption "enables masModule";
  };
  
  config = lib.mkIf config.masModule.enable {
    programmingMasModule.enable = lib.mkDefault true;
    writtingMasModule.enable = lib.mkDefault true;
    personalMasModule.enable = lib.mkDefault true;
    # photographyMasModule.enable = lib.mkDefault true;
  };

}