{
  description = "My NixOS configs";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-23.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # NixOS Hardware
    hardware.url = "github:nixos/nixos-hardware";
    
    # Impermanence
    impermanence.url = "github:nix-community/impermanence";

    # I'm awesome at keeping secrets
    sops-nix.url = "github:mic92/sops-nix";
  };

  outputs = { self, nixpkgs, home-manager, impermanence, sops-nix, ... }@inputs:
    let
      inherit (self) outputs;
      lib = nixpkgs.lib // home-manager.lib;
      systems = [ "x86_64-linux" ];
      forEachSystem = f: lib.genAttrs systems (sys: f pkgsFor.${sys});
      pkgsFor = nixpkgs.legacyPackages;
    in
    {
    inherit lib;

    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      omenix = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs outputs; }; # Pass flake inputs to our config
        # > Our main nixos configuration file <
        modules = [ ./hosts/omenix ];
      };
      isctex = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; }; # Pass flake inputs to our config
        # > Our main nixos configuration file <
        modules = [ ./hosts/isctex ];
      };
    };

    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager --flake .#your-username@your-hostname'
    homeConfigurations = {
      "cjcma@omenix" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = { inherit inputs outputs; }; # Pass flake inputs to our config
        # > Our main home-manager configuration file <
        modules = [ ./home/cjcma/omenix.nix ];
      };
      "cjcma@isctex" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = { inherit inputs; }; # Pass flake inputs to our config
        # > Our main home-manager configuration file <
        modules = [ ./home/cjcma/isctex.nix ];
      };
    };
  };
}
