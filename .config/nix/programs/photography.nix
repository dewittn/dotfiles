{ pkgs, lib, config, ... }: {
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages.homebrew.masApps = 
    {
      Pixelmator = 1289583905;
      "Grammarly Safari" = 1462114288;
      "Story Planner" = 1290342643
      Highland = 1171820258
    };
  };
}