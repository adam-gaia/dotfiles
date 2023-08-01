{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.less = {
    enable = true;
    # Force search to wrap around
    keys = ''
      #command
      / forw-search ^W
      ? back-search ^W
    '';
  };
}
