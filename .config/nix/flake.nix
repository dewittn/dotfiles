{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    
    # Optional: Declarative tap management
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
  };

  outputs = inputs@{ self, nix-darwin, darwin, nix-homebrew, homebrew-core, homebrew-cask,  ... }:
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#rcoto
    darwinConfigurations."ndewitt" = nix-darwin.lib.darwinSystem {
      specialArgs = { 
        inherit (inputs) self; 
        inherit (inputs) darwin; 
        inherit (inputs) nix-homebrew; 
        inherit (inputs) homebrew-core; 
        inherit (inputs) homebrew-cask; 
      };
        
      modules = [
        ./darwinModules 
        nix-homebrew.darwinModules.nix-homebrew
        {
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
            };
        
            # Optional: Enable fully-declarative tap management
            #
            # With mutableTaps disabled, taps can no longer be added imperatively with `brew tap`.
            mutableTaps = false;
          };
        }
      ];
      
    };
    
    darwinConfigurations."rcoto" = nix-darwin.lib.darwinSystem {
      modules = [ ./modules/base.nix ];
    };
  };
}