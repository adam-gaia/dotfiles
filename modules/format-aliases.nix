{
  config,
  pkgs,
  lib,
  format-aliases,
  ...
}: {
  home.packages = with pkgs; [
    format-aliases.packages.${system}.default
  ];
}
