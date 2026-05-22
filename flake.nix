{
  description = "i LOVE NixOS! <3";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:NixOS/nixpkgs";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    affinity-nix.url = "github:mrshmllow/affinity-nix";
  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-master, home-manager, nur, affinity-nix, ... }:
  let
    system = "x86_64-linux";

  in {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {    
      inherit system;

      specialArgs = {
        inherit inputs;
      };
      modules = [

        ({ pkgs, ... }: {
          nixpkgs.overlays = [ affinity-nix.overlays.default ];
        })

        ./hosts/nixos/configuration.nix
        ./hosts/nixos/hardware-configuration.nix

        nur.modules.nixos.default
        nur.legacyPackages."${system}".repos.iopq.modules.xraya

        home-manager.nixosModules.home-manager {
          home-manager.extraSpecialArgs = {
            inherit inputs;
          };
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.artem = import ./home/artem/home.nix;
        }
      ];
    };
  };
}
