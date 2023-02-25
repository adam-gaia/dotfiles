{
  config,
  pkgs,
  lib,
  cbtr,
  system,
  ...
}: {
  home.packages = [
    cbtr.packages.${system}.default
  ];
}
