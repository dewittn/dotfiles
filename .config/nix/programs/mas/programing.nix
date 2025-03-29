{ pkgs, lib, config, homebrew, ... }: {

  options = {
    programingMasModule.enable = lib.mkEnableOption "enables programingMasModule";
  };

  config = lib.mkIf config.programingMasModule.enable {      
    environment.systemPackages.homebrew.masApps = {
        Boop = 1518425043;
        "Data Jar" = 1453273600;
        "Screens 5" = 1663047912;
      };
    };

}