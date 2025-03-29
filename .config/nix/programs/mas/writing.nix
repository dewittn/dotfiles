{ pkgs, lib, config, ... }: {
  
  
  options = {
    writtingMasModule.enable = lib.mkEnableOption "enables writtingMasModule";
  };
  
  config = lib.mkIf config.writtingMasModule.enable {
    environment.systemPackages.homebrew.masApps = 
      {
        ## Base Apps (Installed on all systems)
        Things = 904280696;
        Drafts = 1435957248;
        "1Password for Safari" = 1569813296;
        "Kagi for Safari" = 1622835804;
        
        ##  Apple Apps
        iMovie = 408981434;
        Numbers = 409203825;
        Keynote = 409183694;
        Pages = 409201541;
      };
    };
  };
  
}