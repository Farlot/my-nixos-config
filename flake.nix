{
  description = "My NixOS configuration with ckb-next PR build";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    stablenixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stable-diffusion-webui-nix = {
      url = "github:Janrupf/stable-diffusion-webui-nix/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, sops-nix, stablenixpkgs, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        system = system;
      };
      stable-pkgs = import stablenixpkgs {
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
          inherit inputs system stable-pkgs;
          };
        modules = [
          #./configuration.nix
          ./modules/virt.nix
          sops-nix.nixosModules.sops
          ./hosts
          ./hosts/riggen.nix
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
