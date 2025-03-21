{ pkgs, lib, config, ... }: {
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages.homebrew.masApps = 
    {
      Ulysses = 1225570693;
      Grammarly_Safari = 1462114288;
      Story_Planner = 1290342643
      Highland = 1171820258
      Bear = 1091189122
      iA_Writer = 775737590
    };
  };
}