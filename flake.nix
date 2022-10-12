{
  description = "My system config";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-22.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    home-manager = {
      url = "github:nix-community/home-manager/release-22.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    git-shim = {
      url = "gitlab:adam_gaia/git-shim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, nixpkgs-unstable, flake-utils, home-manager, nixos-hardware, git-shim, ... }@inputs:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config = { allowUnfree = true; };
    };
    unstable-pkgs = import nixpkgs-unstable {
      inherit system;
      config = { allowUnfree = true; };
    };
    lib = nixpkgs.lib;

    agaia_drv = home-manager.lib.homeManagerConfiguration {
      inherit system pkgs;
      extraSpecialArgs = { inherit inputs unstable-pkgs git-shim; };

      username = "agaia";
      homeDirectory = "/home/agaia";
      configuration = {
        imports = [
          ./users/agaia/home.nix
        ];
      };
    };

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
      name = "dev";
      buildInputs =
        [
          pkgs.shellcheck
          pkgs.shfmt
          pkgs.dconf2nix
        ];
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
