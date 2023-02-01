{
  config,
  lib,
  pkgs,
  ...
}: {
  nixpkgs.system = "aarch64-linux"; # Needed to deploy from x86 host to arm host

  imports = [
    ./ssh.nix
  ];

  security = {
    sudo = {
      # Enabling passwordless sudo for nixops to work as non-root.
      # Not sure a better way to do this without enabling ssh as root
      wheelNeedsPassword = false;

      # Sudo lecture message killed initial nixops run. Disabling to prevent in the future
      extraConfig = ''
        Defaults lecture = never
      '';
    };
  };

  nix.settings.trusted-users = ["root" "agaia"];

  virtualisation = {
    docker = {
      enable = true;
    };
  };

  # Use the extlinux boot loader. (NixOS wants to enable GRUB by default)
  boot.loader.grub.enable = false;
  # Enables the generation of /boot/extlinux/extlinux.conf
  boot.loader.generic-extlinux-compatible.enable = true;

  networking = {
    firewall = {
      enable = true;
      allowPing = true;
      allowedTCPPorts = [22]; # ssh
    };
    networkmanager.enable = true;
  };

  time.timeZone = "America/Denver";

  users.users.agaia = {
    description = "Adam Gaia";
    isNormalUser = true;
    uid = 1000;
    initialPassword = "agaia";
    shell = pkgs.zsh;
    extraGroups = ["wheel" "docker"]; # 'wheel' grands sudoer permission
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
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?
}
