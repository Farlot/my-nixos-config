{
  description = "My NixOS configuration with ckb-next PR build";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Other inputs if needed
  };

  outputs = { self, nixpkgs, ... }@inputs:
    let
      system = "x86_64-linux";  # Adjust based on your architecture
      pkgs = import nixpkgs {
        system = system;
      };
      ckb-next = import ./ckb.nix {
        lib = nixpkgs.lib;
        pkgs = pkgs;  # Pass the correct pkgs for the system
      };
    in {
      nixosConfigurations.riggen = nixpkgs.lib.nixosSystem {
        specialArgs = {
          username = "maw";
          inherit inputs system;
          };
        modules = [
          ./configuration.nix
          ./modules/virt.nix
          ./modules/nh.nix
          ./modules/hardware/mounts.nix
          {
            nixpkgs.overlays = [
              (final: prev: {
                ckb-next = ckb-next;
              })
            ];
          }
        ];
      };
    };
}
