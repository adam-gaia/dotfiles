{
  description = "My system config";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-22.05";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager.url = "github:nix-community/home-manager/release-22.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, home-manager, nixos-hardware, ... }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config = { allowUnfree = true; };
    };
    lib = nixpkgs.lib;

  in {
    homeManagerConfigurations = {
      agaia = home-manager.lib.homeManagerConfiguration {
        inherit system pkgs;
        username = "agaia";
        homeDirectory = "/home/agaia";
        configuration = {
          imports = [
            ./users/agaia/home.nix
          ];
        };
      };
    };
    nixosConfigurations = {
      nixbox = lib.nixosSystem {
        inherit system;
        modules = [
          ./system/configuration.nix
        ];
      };
    };
  };
}