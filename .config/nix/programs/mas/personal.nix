{ pkgs, lib, config, ... }: {
  
  
  options = {
    personalMasModule.enable = lib.mkEnableOption "enables personalMasModule";
  };
  
  config = lib.mkIf config.personalMasModule.enable {
    environment.systemPackages.homebrew.masApps = 
      {
        ## Personal Apps
        Portal = 1436994560;
        "Paprika Recipe Manager 3" = 1303222628;
        "Save to Matter" = 1548677272;
        Kindle = 302584613;
      };
    };
  };
  
}