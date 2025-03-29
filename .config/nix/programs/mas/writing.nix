{ pkgs, lib, config, ... }: {
  
  options = {
    writtingMasModule.enable = lib.mkEnableOption "enables writtingMasModule";
  };
  
  config = lib.mkIf config.writtingMasModule.enable {
    environment.systemPackages.homebrew.masApps = 
      {
        ## Writing Apps
        Bear = 1091189122;
        Ulysses = 1225570693;
        "iA Writer" = 775737590;
        "Highland 2" = 1171820258;
        "Story Planner" = 1290342643;
        "Grammarly for Safari" = 1462114288;
      };
    };
  
}