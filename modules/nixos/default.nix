{
  config,
  pkgs,
  home-manager,
  ...
}: {
  imports = [
    ../common.nix
  ];

  # Enable flakes
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  console = {
    # font = "Lat2-Terminus16";
    useXkbConfig = true; # use xkbOptions in tty (allows us to have our remap of caps to escape).
  };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    # Configure keymap in X11
    layout = "us";
    xkbOptions = "caps:escape"; # map caps to escape.
  };

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  users.users.agaia = {
    description = "Adam Gaia";
    isNormalUser = true;
    uid = 1000;
    initialPassword = "agaia";
    shell = pkgs.zsh;
    extraGroups = ["wheel" "docker"]; # 'wheel' grants sudoer permission.
  };
  users.mutableUsers = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?
}
