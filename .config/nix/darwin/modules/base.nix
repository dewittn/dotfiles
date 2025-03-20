{ pkgs, lib, config, ... }: {
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages =
    [ 
      pkgs.alacritty
      pkgs.git
      pkgs.neofetch
      pkgs.tailscale
      pkgs.tailscaled
      pkgs.vim
    ];

  homebrew = {
    enable = true;
    brews = [
      "mas"
    ];
    casks = [
      "alfred"
      "firefox"
      "1password"
    ];
    taps = [
    ];
    masApps = {
      Things = 904280696;
      Drafts = 1435957248;
      "1Password for Safari" = 1569813296;
    };
  };
  
  system.activationScripts.applications.text = 
  let
    env = pkgs.buildEnv {
      name = "system-applications";
      paths = config.environment.systemPackages;
      pathsToLink = "/Applications";
    };
  in
    pkgs.lib.mkForce ''
      # Set up applications.
      echo "setting up /Applications..." >&2
      rm -rf /Applications/Nix\ Apps
      mkdir -p /Applications/Nix\ Apps
      find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
      while read -r src; do
        app_name=$(basename "$src")
        echo "copying $src" >&2
        ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
      done
    '';

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # Set Git commit hash for darwin-version.
  system.configurationRevision = self.rev or self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;
  
  system.defaults = {
    NSGlobalDomain.AppleICUForce24HourTime = false;
    NSGlobalDomain.AppleShowAllExtensions = true;
    loginwindow.GuestEnabled = false;
    finder.FXPreferredViewStyle = "clmv";
    screencapture.location = "~/Pictures/screenshots";
    screensaver.askForPasswordDelay = 10;
    dock.persistent-apps = [
      "/Applications/Things3.app"
      "/Applications/Calendar.app"
      "/Applications/Drafts.app"
      "/Applications/Safari.app"
      "/Applications/Mail.app"
      "/Applications/Music.app"
      "/Applications/App Store.app"
      "/Applications/System Settings.app"
    ]
  };
  #networking.hostName = "rcoto"

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
}