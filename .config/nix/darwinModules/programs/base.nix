{ pkgs, lib, config, self, ... }: {

  options = {
    baseModule.enable = lib.mkEnableOption "enables baseModule";
  };
  
  config = lib.mkIf config.baseModule.enable {
    # List packages installed in system profile. To search by name, run:
    # $ nix-env -qaP | grep wget
    nixpkgs.config.allowUnfree = true;
    # nixpkgs.overlays = [
    #   inputs.templ.overlays.default
    # ];
    
    environment.systemPackages =
      [ 
        pkgs.alacritty
        pkgs.fastfetch
        pkgs.git
        pkgs.tailscale
        pkgs.vim
        pkgs.zoxide
      ];
    
    nix-homebrew = {
      # Install Homebrew under the default prefix
      enable = true;
    
      # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
      enableRosetta = true;
    
      # User owning the Homebrew prefix
      user = "dewittn";
    
      # Optional: Declarative tap management
      taps = {
        "homebrew/homebrew-core" = homebrew-core;
        "homebrew/homebrew-cask" = homebrew-cask;
        "homebrew/homebrew-bundle" = homebrew-bundle;
      };
    
      # Optional: Enable fully-declarative tap management
      #
      # With mutableTaps disabled, taps can no longer be added imperatively with `brew tap`.
      mutableTaps = false;
    };
    
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
      # masApps = {
      #   Things = 904280696;
      #   Drafts = 1435957248;
      #   "1Password for Safari" = 1569813296;
      # };
    };
    
    services.nix-daemon.enable = true;
    nix.settings.experimental-features = "nix-command flakes";
    programs.zsh.enable = true;  # default shell on catalina
    
    # Set Git commit hash for darwin-version.
    # system.configurationRevision = self.rev or self.dirtyRev or null;
    system.configurationRevision = self.rev or self.dirtyRev or null;
    
    # Used for backwards compatibility, please read the changelog before changing.
    # $ darwin-rebuild changelog
    system.stateVersion = 4;
    # nixpkgs.hostPlatform = "aarch64-darwin";
    security.pam.enableSudoTouchIdAuth = true;
    
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

    system.defaults = {
      NSGlobalDomain.AppleICUForce24HourTime = false;
      NSGlobalDomain.AppleShowAllExtensions = true;
      loginwindow.GuestEnabled = false;
      finder.FXPreferredViewStyle = "clmv";
      screencapture.location = "~/Pictures/screenshots";
      screensaver.askForPasswordDelay = 10;
      dock.persistent-apps = [
        # "/Applications/Things3.app"
        "/System/Applications/Calendar.app"
        # "/Applications/Drafts.app"
        "/System/Applications/Safari.app"
        "/System/Applications/Mail.app"
        "/System/Applications/Music.app"
        "/System/Applications/App Store.app"
        "/System/Applications/System Settings.app"
      ];
    };
    #networking.hostName = "rcoto"
    
    # The platform the configuration will be used on.
    nixpkgs.hostPlatform = "aarch64-darwin";
  };
}