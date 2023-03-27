{ config
, pkgs
, ...
}: {

  imports = [
    ./gnome
    ./sway
  ];

  services.xserver = {
    displayManager = {
      gdm = {
        enable = true;
        wayland = true;
      };
    };
  };

}
