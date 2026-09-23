{
  description = "i LOVE NixOS! <3";

  inputs = {
    ryoku = {
      url = "github:aethctl/Ryoku-on-NixOS/main";
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-codex.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:NixOS/nixpkgs";

    home-manager = {
      url = "github:nix-community/home-manager";
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
    codex-desktop.url = "github:ilysenko/codex-desktop-linux";
    claude-desktop.url = "github:aaddrick/claude-desktop-debian";
    happ-nix.url = "github:DaHL-gh/happ-nix";
    millennium.url = "github:SteamClientHomebrew/Millennium?dir=packages/nix";
  };

  outputs = inputs @ {
    ryoku, self,
    nixpkgs,
    nixpkgs-codex,
    nixpkgs-master,
    home-manager,
    nur,
    codex-desktop,
    claude-desktop,
    happ-nix,
    ...
  }:
  let
    system = "x86_64-linux";

  in {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {    
      inherit system;

      specialArgs = {
        inherit inputs;
      };
      modules = [
        ryoku.nixosModules.default
        ./ryoku.nix

        happ-nix.nixosModules.default

        ./hosts/nixos/configuration.nix
        ./hosts/nixos/hardware-configuration.nix

        nur.modules.nixos.default
        nur.legacyPackages."${system}".repos.iopq.modules.xraya

        ({ pkgs, ... }: {
          nixpkgs.overlays = [ 
            claude-desktop.overlays.default
            inputs.millennium.overlays.default
          ];
        })

        home-manager.nixosModules.home-manager {
          home-manager.extraSpecialArgs = {
            inherit inputs;
          };
          home-manager.backupCommand = ''
            rm -f "$1.backup"
            mv "$1" "$1.backup"
          '';
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.artem = {
            imports = [
              ./home/artem/home.nix             
            ];
          };
        }
      ];
    };
  };
}

