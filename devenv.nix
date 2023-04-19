{
  inputs,
  pkgs,
  lib,
  ...
}: {
  packages = with pkgs; [
    inputs.nonstdlib.defaultPackage."${system}"
    git-crypt
    dconf2nix
    #rpi-imager
    deploy-rs
    kubectl
    kubernetes-helm-wrapped
    inputs.build-img.defaultPackage."${pkgs.system}"
    inputs.deploy-rs.defaultPackage."${pkgs.system}"
    (inputs.treefmt-nix.lib.mkWrapper pkgs (import ./treefmt.nix))
  ];

  pre-commit = {
    hooks = {
      black.enable = true;
      shellcheck.enable = true;
      alejandra.enable = true; # nix formatter
      #deadnix.enable = true;
      shfmt.enable = true;
      stylua.enable = true;
      yamllint.enable = true;
      ansible-lint.enable = true;
      commitizen.enable = true;
      editorconfig-checker.enable = true;
    };

    settings = {
      deadnix.noLambdaArg = true;
    };
  };
}
