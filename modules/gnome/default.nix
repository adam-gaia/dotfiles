{
  config,
  pkgs,
  ...
}: {
  # Enable the X11 windowing system with gnome.
  services.xserver = {
    # Enable Gnome
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

  # dconf and gnome-settings-daemon needed to set settings with home manager's dconf module
  services.dbus.packages = [pkgs.dconf];
  services.udev.packages = [pkgs.gnome3.gnome-settings-daemon];

  # Exclude some gnome apps
  environment = {
    gnome.excludePackages =
      (with pkgs; [
        gnome-photos
        gnome-tour
      ])
      ++ (with pkgs.gnome; [
        cheese # webcam tool
        gnome-music
        #gedit # text editor
        epiphany # web browser
        geary # email reader
        gnome-characters
        totem # video player
        tali # poker game
        iagno # go game
        hitori # sudoku game
        atomix # puzzle game
      ]);
    systemPackages = with pkgs; [
      gnome.gnome-tweaks
    ];
  };
}
