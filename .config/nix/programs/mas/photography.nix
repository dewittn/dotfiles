{ pkgs, lib, config, ... }: {
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages.homebrew.masApps = 
    {
      "Pixelmator Pro" = 1289583905;
    };
  };
}