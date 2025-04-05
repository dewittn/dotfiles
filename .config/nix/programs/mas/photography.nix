{ pkgs, lib, config, ... }: {

  options = {
    photographyMasModule.enable = lib.mkEnableOption "enables photographyMasModule";
  };

  config = lib.mkIf config.photographyMasModule.enable {
    environment.systemPackages.homebrew.masApps = 
      {
        "Pixelmator Pro" = 1289583905;
      };
  }; 
}