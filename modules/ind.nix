{
  config,
  pkgs,
  lib,
  ind,
  system,
  ...
}: {
  home.packages = [
    ind.packages.${system}.default
  ];
}
