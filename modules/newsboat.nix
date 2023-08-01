{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.newsboat = {
    enable = true;
  };
}
