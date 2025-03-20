{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs }:
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#rcoto
    darwinConfigurations."ndewitt" = nix-darwin.lib.darwinSystem {
      modules = [ ./modules/base.nix ];
      # modules = [ base dev ];
    };
    darwinConfigurations."rcoto" = nix-darwin.lib.darwinSystem {
      modules = [ ./modules/base.nix ];
    };
  };
}