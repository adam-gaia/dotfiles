{
  config,
  pkgs,
  lib,
  ind,
  ...
}: {
  home.packages = with pkgs; [
    ind.packages.${system}.default
  ];
}
