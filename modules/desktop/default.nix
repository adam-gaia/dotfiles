{
  config,
  pkgs,
  lib,
  system,
  settings-script,
  ...
}: {
  imports = [
    ./gnome
    ./sway
  ];

  environment = {
    systemPackages = with pkgs; [
      settings-script.packages.${system}.default
    ];
  };

  services.xserver = {
    displayManager = {
      gdm = {
        enable = true;
        wayland = true;
      };
    };
  };
}
