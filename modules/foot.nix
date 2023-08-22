{
  config,
  pkgs,
  lib,
  ...
}:
#let
#  c = import ../../modules/colors/Sonokai.nix {};
#in
let
  term = "xterm-256color";
in {
  programs.foot = {
    enable = true;
    settings = {
      main = {
        term = "${term}";
        #font = "FiraCode Nerd Font:size=14";
        #dpi-aware = "yes";
      };
      #colors = {
      #  background = c.primary.background;
      #};
    };
  };
}
