{
  description = "My (darwin) system config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-22.05-darwin";
    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-22.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, darwin, nixpkgs, nixpkgs-unstable, home-manager }@inputs:
  let
    system = "x86_64-darwin";
    pkgs = import nixpkgs {
      inherit system;
      config = {allowUnfree = true;};
    };
    unstable-pkgs = import nixpkgs-unstable {
      inherit system;
      config = {allowUnfree = true;};
    };

    agaia_drv = home-manager.lib.homeManagerConfiguration {
      inherit system pkgs;
      extraSpecialArgs = {inherit inputs unstable-pkgs; };
      username = "agaia";
      homeDirectory = "/Users/agaia";
      configuration = {
        imports = [
          ./users/agaia/home.nix
        ];
      };
    };
  in
  {
      homeManagerConfigurations = {
        agaia = agaia_drv;
      };

    darwinConfigurations."helix" = darwin.lib.darwinSystem {
      system = "x86_64-darwin";
      modules = [ ./configuration.nix ];
    };
  };
}

