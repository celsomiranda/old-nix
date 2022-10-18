{
  description = "Celso's config with flakesw";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    flake-utils.url = "github:numtide/flake-utils";
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, home-manager, ... }@inputs: 
    let
      system = "x86_64-linux";
      overlays = [
        inputs.agenix.overlay
        self.overlay
      ];
      lib = nixpkgs.lib.extend (final: prev:
        import ./lib {
          inherit home-manager;
          lib = final;
        });
    in {
      overlay = import ./overlay.nix {
        inherit lib home-manager;
        inherit (inputs);
      };

      # NixOS machines
      nixosConfigurations = lib.celso.allProfiles ./machines (name: file:
        lib.celso.makeNixOS name file { inherit inputs system overlays; });

      # Non-NixOS machines (Alpine, WSL, ++)
      homeConfigurations = lib.celso.nixos2hm {
        inherit (self) nixosConfigurations;
        inherit overlays system;
      };
    } // flake-utils.lib.eachDefaultSystem (system:
      let pkgs = import nixpkgs { inherit system overlays; };
      in {
        # All packages under pkgs.celso.apps from the overlay
        packages = pkgs.celso.apps;

        devShells = {
          # Default dev shell (used by direnv)
          default = pkgs.mkShell { buildInputs = with pkgs; [ agenix ]; };
        };
      });
}
 
 
