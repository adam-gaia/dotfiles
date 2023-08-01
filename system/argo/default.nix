{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./modules/nginx.nix
    #./modules/wireguard.nix
  ];

  # Disable sudo password for remove deployment with deploy-rs
  security.sudo.wheelNeedsPassword = false;

  nixpkgs.system = "x86_64-linux";

  nix.settings.trusted-users = ["root" "agaia"];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "argo";
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Denver";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.agaia = {
    description = "Adam Gaia";
    isNormalUser = true;
    uid = 1000;
    initialPassword = "agaia";
    shell = pkgs.zsh;
    extraGroups = ["networkmanager" "wheel" "docker"]; # 'wheel' grands sudoer permission
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDCzbPCWRK+1Zd2EMzjEOn7cjMJ+QksEtGKGvJ/3zwP2UkJk417IP3THACSzDUBSZ4i4XpFcXxLeUwQMHNFfq+6ZRdeahG5Z7YfT0LTLaS4uzYmrEoz7ZHwMzjSbIvYhntfR6OAprq0iG4rhjSy6laiFF+6tEkLtJ3GmPpjT3z2P5hFmm49pdBYLNmZPpfofUykRbF+5NQK6enf35l4l4+ctKEhrW7Q1OAgvkXFa6qBBAHWNlQDeiUSQG1wRKbslg97WZk/ElJP7eMf8drSbCJ6Wj2fciGZUw5kFX+3GRBMK8JjcfidFjpEsMWRLG5QAzeUujrNkKqs3LP2vr+9SLReX2GarUK55WXkkB3ZPnggSwGwDGXY/XHKmHtJN9EvZeCnT7l/R+yneu6FlJ7Rio56L6PXwx6sbes5EGlkYzIExn1SgPTB15XEZgt9qYQf9+LESUm0DxbYNaJOPB0hb42X/ZNtaYjdIGRiouktNwU3yl3H2VpCRtUdtVlDya9DRYlyd+Cp0lYdcFix/2bVDxsdkk/gTymB8XkZNSEHGfi0lYs6DUXThJHVtm/bUcM34whebnKUzBx786UnwX72DcFEV9t5HRCJLoZCtN188DFE4S9Yze3AeHhnvpj0H/+wFIYwsvIXoI7aMOvj2D3IxDHuxTMIdCwCSJ9+ldhmr/CDOQ== agaia@orion Generated Mon Sep 19 12:28:08 PM MDT 2022"
    ];
  };
  users.mutableUsers = true;

  environment = {
    systemPackages = with pkgs; [
      bash
      zsh
      vim
      git
      htop
      less
      curl
      wget
      file
    ];
    # Shells for /etc/shells
    shells = with pkgs; [bash zsh];
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableBashCompletion = true;
    autosuggestions.enable = true;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings.permitRootLogin = "no";
  };
  # OpenSSH is forced to have an empty `wantedBy` on the installer system[1], this won't allow it
  # to be automatically started. Override it with the normal value.
  # [1] https://github.com/NixOS/nixpkgs/blob/9e5aa25/nixos/modules/profiles/installation-device.nix#L76
  systemd.services.sshd.wantedBy = lib.mkOverride 40 ["multi-user.target"];

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [3000]; # TODO: make adguardhome port a variable
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

  virtualisation = {
    podman.enable = true;
  };
}
