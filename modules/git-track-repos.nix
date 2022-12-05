{
  config,
  pkgs,
  lib,
  git-track-repos,
  ...
}: {
  home.packages = with pkgs; [
    git-track-repos.packages.${system}.default
  ];
}
