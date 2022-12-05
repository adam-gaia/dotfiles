{
  config,
  pkgs,
  lib,
  shim,
  ...
}: {
  home.packages = with pkgs; [
    shim.packages.${system}.default
  ];
}
