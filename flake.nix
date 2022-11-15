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

    nonstdlib = {
      url = "gitlab:adam_gaia/nonstdlib/test";
    };

    shim = {
      url = "gitlab:adam_gaia/shim";
    };

    git-track-repos = {
      url = "gitlab:adam_gaia/git-track-repos";
    };
  };

  outputs = { nixpkgs, nixpkgs-unstable, flake-utils, nonstdlib, home-manager, nixos-hardware, shim, git-track-repos, ... }@inputs:
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

    toolchain = [
      nonstdlib.defaultPackage.${system}
      pkgs.shellcheck
      pkgs.shfmt
      pkgs.dconf2nix
    ];

    lib = nixpkgs.lib;

    agaia_drv = home-manager.lib.homeManagerConfiguration {
      inherit system pkgs;
      extraSpecialArgs = { inherit inputs unstable-pkgs shim git-track-repos; };

      username = "agaia";
      homeDirectory = "/home/agaia";
      configuration = {
        imports = [
          ./users/agaia/home.nix
        ];
      };
    };

    apply_script = pkgs.writeShellApplication {
      name = "apply-config";
      runtimeInputs = toolchain;
      text = (builtins.readFile ./scripts/apply-config);
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
      buildInputs = toolchain; 
    };

    packages.${system}.default = apply_script;

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
