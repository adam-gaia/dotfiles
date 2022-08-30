# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix 
    ];

  # Enable flakes
  nix.package = pkgs.nixFlakes;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.supportedFilesystems = [ "btrfs" ];
  hardware.enableAllFirmware = true;
  nixpkgs.config.allowUnfree = true;

  networking.hostName = "orion"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "America/Denver";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

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

    # Enable Gnome, but exclude some apps
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  
    # Enable touchpad support (enabled default in most desktopManager).
    libinput.enable = true;
  };

  # dconf and gnome-settings-daemon needed to set settings with home manager's dconf module
  services.dbus.packages = [ pkgs.dconf ];
  services.udev.packages = [ pkgs.gnome3.gnome-settings-daemon ];

  environment.gnome.excludePackages = (with pkgs; [
    gnome-photos
    gnome-tour
  ]) ++ (with pkgs.gnome; [
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
  
  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;
 
  # Persist network settings and nixos configuration
  environment.etc = {
    nixos.source = "/persist/etc/nixos";
    "NetworkManager/system-connections".source = "/persist/etc/NetworkManager/system-connections";
    adjtime.source = "/persist/etc/adjtime";
    NIXOS.source = "/persist/etc/NIXOS";
    machine-id.source = "/persist/etc/machine-id";
  };
  security.sudo.extraConfig = ''
    # rollback results in sudo lectures after each reboot
    Defaults lecture = never
  '';  


  # Rollback on reboot
  # Note `lib.mkBefore` is used instead of `lib.mkAfter` here.
  boot.initrd.postDeviceCommands = pkgs.lib.mkBefore ''
    mkdir -p /mnt
    # We first mount the btrfs root to /mnt
    # so we can manipulate btrfs subvolumes.
    mount -o subvol=/ /dev/mapper/enc /mnt
    # While we're tempted to just delete /root and create
    # a new snapshot from /root-blank, /root is already
    # populated at this point with a number of subvolumes,
    # which makes `btrfs subvolume delete` fail.
    # So, we remove them first.
    #
    # /root contains subvolumes:
    # - /root/var/lib/portables
    # - /root/var/lib/machines
    #
    # I suspect these are related to systemd-nspawn, but
    # since I don't use it I'm not 100% sure.
    # Anyhow, deleting these subvolumes hasn't resulted
    # in any issues so far, except for fairly
    # benign-looking errors from systemd-tmpfiles.
    btrfs subvolume list -o /mnt/root |
    cut -f9 -d' ' |
    while read subvolume; do
      echo "deleting /$subvolume subvolume..."
      btrfs subvolume delete "/mnt/$subvolume"
    done &&
    echo "deleting /root subvolume..." &&
    btrfs subvolume delete /mnt/root
    echo "restoring blank /root subvolume..."
    btrfs subvolume snapshot /mnt/root-blank /mnt/root
    # Once we're done rolling back to a blank snapshot,
    # we can unmount /mnt and continue on the boot process.
    umount /mnt
  '';

  systemd.tmpfiles.rules = [
    "L /var/lib/NetworkManager/secret_key - - - - /persist/var/lib/NetworkManager/secret_key"
    "L /var/lib/NetworkManager/seen-bssids - - - - /persist/var/lib/NetworkManager/seen-bssids"
    "L /var/lib/NetworkManager/timestamps - - - - /persist/var/lib/NetworkManager/timestamps"
    "L /var/lib/docker - - - - /persist/var/lib/docker"
    # TODO: Unable to set "/var/lib/docker-registry - - - - /persist/var/lib/docker".
    # Not sure why. Spend too long debugging. Ended up just settings services.docker.registry.storagePath=/persis/var/lib/docker-registry
  ];
 
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.agaia = {
    description = "Adam Gaia";
    isNormalUser = true;
    uid = 1000;
    initialPassword = "agaia";
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "docker"]; # 'wheel' grants sudoer permission.
  };
  users.mutableUsers = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    bash
    vim  
    zsh
    tmux
    gnumake
    git
    gcc
    htop
    less
    curl
    wget
    parted
    neovim
    firefox
    file
    watch
  ];


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  #programs.mtr.enable = true;
  #programs.gnupg.agent = {
  #  enable = true;
  #  enableSSHSupport = true;
  #};

  services.dockerRegistry = {
    enable = true;
    enableDelete = true;
    enableGarbageCollect = true;
    listenAddress = "127.0.0.1";
    port = 5000;
    storagePath = "/persist/var/lib/docker-registry";
  };

  virtualisation = {
    docker.enable = true;
    podman.enable = true;

    # TODO: need to figure out where to configure /etc/containers/registries.conf

    oci-containers = {
      # After trying to set up services from containers on a local registry which is also a service declared here,
      # I see why side effects are bad
      backend = "podman";
      containers = {
        # TODO: set a variable for the local registry '127.0.0.1:5000'
        # Troubleshooting:
        #   * If host-side volume mount does not exist, registry will fail
        #   * TODO: how can we create these directories as part of nixos configuration?
        #"registry" = { 
        #  image = "docker.io/library/registry:2.8.1";
        #  ports = [
        #    "127.0.0.1:5000:5000"
        #  ];
        #  autoStart = true;
        #  volumes = [
        #    "/home/agaia/Data/registry:/var/lib/registry"
        #  ];
        #};

        "reg" = {
          # Troubleshooting:
          #  * Is the registry running? (sudo systemctl status podman.registry)
          #  * Does the registry have an image for reg?
          #  * Registry is insecure. The address must match /etc/containers/registries.conf. If 'localhost' here, then cant be '127.0.0.1' in that file
          image = "127.0.0.1:5000/reg-docker-server:latest";
          #ports = [ 
          #  "127.0.0.1:5001:8080"
          #];
          # Had to use host network to point the --registry option to the host to get the registry.
          # Couldn't figure out podman's equlivalent of docker's '--add-host=host.docker.internal:host-gateway' (172.x.y.z)
          extraOptions = [ "--network=host" ];
          autoStart = true;
          #dependsOn = [ "registry" ];
          cmd = [ "reg" "server" "--listen-address" "127.0.0.1" "--port" "5001" "--registry" "localhost:5000" "--force-non-ssl" ];
        };

        "gitea" = {
          image = "docker.io/gitea/gitea:1.17.1";
          environment = {
            USER_ID = "1000";
            USER_GUID = "1000";
          };
          ports = [
            "127.0.0.1:3000:3000"
            "127.0.0.1:2222:22"
          ];
          volumes = [
            "/home/agaia/Data/gitea:/data"
          ];
          autoStart = true;
        };
        
        #"shsh-jc-cyl" = {
        #  # Work shsh-jc-cyl container
        #  # Troubleshooting:
        #  #  * Is the registry running? (sudo systemctl status podman.registry)
        #  #  * Does the registry have an image for reg?
        #  #  * Registry is insecure. The address must match /etc/containers/registries.conf. If 'localhost' here, then cant be '127.0.0.1' in that file 
        #  image = "127.0.0.1:5000/shsh-jc-cyl:latest"; 
        #  dependsOn = [ "registry" ];
        #  autoStart = true;
        #  extraOptions = [
        #    "--hostname"
        #    "agaia-sharper"
        #    "--cap-add"
        #    "SYS_ADMIN"
        #    "--volume"
        #    "/sys/fs/cgroup:/sys/fs/cgroup:ro"
        #  ];
        #};

        "homer" = {
          image = "docker.io/b4bz/homer:v22.07.2";
          autoStart = true;
          ports = [
            "127.0.0.1:8080:8080"
          ];
          volumes = [
            "/home/agaia/Data/homer:/www/assets"
          ];
        };
      };
    };
  };

  # XDG standard - improces communication between bundled flatpak apps and Wayland
  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
        #xdg-desktop-portal-gtk # I think this is already set with sway or gnome
      ];
    };
  };
  services.flatpak.enable = true;
  

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # TODO: I think there is a bug causing systemd to hang on boot with my dell XPS. Need to investigate
  #services.openssh.enable = false; # DO NOT ENABLE

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?

}

