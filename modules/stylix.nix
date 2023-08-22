{
  lib,
  config,
  pkgs,
  ...
}: let
  theme = "${pkgs.base16-schemes}/share/themes/monokai.yaml";
  wallpaper = pkgs.runCommand "image.png" {} ''
    COLOR=$(${pkgs.yq}/bin/yq -r .base00 ${theme})
    COLOR="#"$COLOR
    ${pkgs.imagemagick}/bin/magick convert -size 1920x1080 xc:$COLOR $out
  '';
in {
  stylix = {
    image = wallpaper;
    base16Scheme = theme;
    fonts = {
      monospace = {
        package = pkgs.nerdfonts.override {fonts = ["FiraCode"];};
        name = "FiraCode Nerd Font";
      };
      # TODO: dont just repeat font styles
      serif = config.stylix.fonts.monospace;
      sansSerif = config.stylix.fonts.monospace;
      emoji = config.stylix.fonts.monospace;
    };
  };
}
