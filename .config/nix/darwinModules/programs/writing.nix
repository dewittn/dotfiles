{ pkgs, lib, config, ... }: {
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
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