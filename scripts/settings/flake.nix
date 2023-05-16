{
  description = "TODO";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        inherit system;
      };

      runtimeInputs = with pkgs; [
        gst_all_1.gst-plugins-bad
        gst_all_1.gstreamer
      ];
      toolchain = with pkgs;
        [
        ]
        ++ runtimeInputs;

      ide = pkgs.writeShellApplication {
        name = "settings";
        runtimeInputs = runtimeInputs;
        text = builtins.readFile ./settings.sh;
      };
    in {
      packages.default = ide;

      devShells.default = pkgs.mkShell {
        # Tools that should be avaliable in the shell
        nativeBuildInputs = toolchain;
      };
    });
}
