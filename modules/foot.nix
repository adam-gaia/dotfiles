{
  config,
  pkgs,
  lib,
  term,
  ...
}:
#let
#  c = import ../../modules/colors/Sonokai.nix {};
#in
{
  programs.foot = {
    enable = true;
    settings = {
      main = {
        term = "${term}";
        font = "FiraCode Nerd Font:size=14";
        dpi-aware = "yes";
      };
      #colors = {
      #  background = c.primary.background;
      #};
    };
  };
}
