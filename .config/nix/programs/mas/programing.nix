{ pkgs, lib, config, homebrew, ... }: {

  options = {
    programmingMasModule.enable = lib.mkEnableOption "enables programmingMasModule";
  };

  config = lib.mkIf config.programmingMasModule.enable {      
    environment.systemPackages.homebrew.masApps = {
        Boop = 1518425043;
        "Data Jar" = 1453273600;
        "Screens 5" = 1663047912;
      };
    };

}