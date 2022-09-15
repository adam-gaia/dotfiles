{
  description = "My system config";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-22.05";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager.url = "github:nix-community/home-manager/release-22.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, flake-utils, home-manager, nixos-hardware, ... }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config = { allowUnfree = true; };
    };
    lib = nixpkgs.lib;

    agaia_drv = home-manager.lib.homeManagerConfiguration {
      inherit system pkgs;
      username = "agaia";
      homeDirectory = "/home/agaia";
      configuration = {
        imports = [
          ./users/agaia/home.nix
        ];
      };
    };

    apply-script = "apply.sh";

  in rec {
    homeManagerConfigurations = {
      agaia = agaia_drv;
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

    packages.${system}.default = pkgs.writeShellApplication {
      name = "apply";
      runtimeInputs = [];
      text = (builtins.readFile ./${apply-script});
    };

    templates = {
      rust = {
        path = "./templates/rust";
        description = "Rust flake";
      };
      python = {
        path = "./templates/python";
        description = "Python flake";
      };
    };

  };
}
