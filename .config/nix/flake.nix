{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin,  ... }:
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#rcoto
    darwinConfigurations."ndewitt" = nix-darwin.lib.darwinSystem {
      specialArgs = { inherit inputs; };
      modules = [
        ./darwinModules 
      ];
      # modules = [ base dev ];
      
      # Set Git commit hash for darwin-version.
      # system.configurationRevision = self.rev or self.dirtyRev or null;
      system.configurationRevision = self.rev or self.dirtyRev or null;
    };
    
    darwinConfigurations."rcoto" = nix-darwin.lib.darwinSystem {
      modules = [ ./modules/base.nix ];
    };
  };
}