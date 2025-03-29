{ pkgs, lib, config, ... }: {

  options = {
    photographyMasModule.enable = lib.mkEnableOption "enables photograghyMasModule";
  };

  config = lib.mkIf config.photograghyMasModule.enable {
    environment.systemPackages.homebrew.masApps = 
      {
        "Pixelmator Pro" = 1289583905;
      };
  }; 
}