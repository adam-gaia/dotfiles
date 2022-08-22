{
  description = "My system config";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-22.05";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager.url = "github:nix-community/home-manager/release-22.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
    #pretty-print.url = "github.com/shell-lib/pretty-print";
 };

  outputs = { nixpkgs, flake-utils, home-manager, nixos-hardware, ... }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config = { allowUnfree = true; };
    };
    lib = nixpkgs.lib;

  in rec {
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
          ./system/nixbox/configuration.nix
        ];
      };
      orion = lib.nixosSystem {
        inherit system;
        modules = [
          ./system/orion/configuration.nix
        ];
      };
    };
    devShells.${system}.default = pkgs.mkShell {
      buildInputs =
        [
          pkgs.shellcheck
          pkgs.shfmt
          pkgs.dconf2nix
        ];
    };

  };
}
