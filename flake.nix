{
  description = "NixOS system configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ambxst.url = "github:axenide/ambxst";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    home-manager,
    ambxst,
    ...
  }: let
    system = "x86_64-linux";
  in {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      inherit system;

      specialArgs = {
        inherit ambxst inputs;
      };

      modules = [
        ./configuration.nix

        home-manager.nixosModules.home-manager

        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.artem = import ./home.nix;
          home-manager.extraSpecialArgs = {
            inherit inputs ambxst;
          };
          home-manager.backupFileExtension = "backup";
        }
      ];
    };
  };
}
