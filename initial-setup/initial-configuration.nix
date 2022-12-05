{
  config,
  pkgs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.supportedFilesystems = ["btrfs"];
  hardware.enableAllFirmware = true;
  nixpkgs.config.allowUnfree = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "orion"; # Define your hostname.
  networking.networkmanager.enable = true;

  # Define a user account. Don't forget to update password with ‘passwd’.
  users.users.agaia = {
    isNormalUser = true;
    extraGroups = ["wheel"]; # Wheel group grants sudo permissions.
    initialPassword = "agaia";
  };

  environment.systemPackages = with pkgs; [
    vim
    tree
    git
    gnumake
    htop
    curl
    wget
    tmux
    unzip
    firefox
  ];

  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  environment.gnome.excludePackages =
    (with pkgs; [
      gnome-photos
      gnome-tour
    ])
    ++ (with pkgs.gnome; [
      cheese # webcam tool
      gnome-music
      gedit # text editor
      epiphany # web browser
      geary # email reader
      gnome-characters
      totem # video player
      tali # poker game
      iagno # go game
      hitori # sudoku game
      atomix # puzzle game
    ]);

  #services.openssh.enable = true;

  system.stateVersion = "22.05";
}
