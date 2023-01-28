# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.supportedFilesystems = ["btrfs"];
  hardware.enableAllFirmware = true;
  nixpkgs.config.allowUnfree = true;

  # Emulate arm for cross compiling raspberry pi ISO
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  networking = {
    hostName = "orion"; # Define your hostname.
    # Pick only one of the below networking options.
    # wireless.enable = true;  # Enables wireless support via wpa_supplicant.
    networkmanager.enable = true; # Easiest to use and most distros use this by default.

    # Open ports in the firewall.
    # firewall.allowedTCPPorts = [ ... ];
    firewall.allowedUDPPorts = [51820]; # Wireguard uses port 51820
    # Or disable the firewall altogether.
    firewall.enable = false;

    #wireguard.interfaces = {
    #  wg0 = {
    #    ips = [ "10.2.0.2/32" ];
    #    listenPort = 51820;
    #    privateKeyFile = "/home/agaia/repo/personal/dotfiles/modules/wireguard/proton-ca.key";
    #    peers = [
    #      {
    #        publicKey = "5YxjJV/w2nIQHnh80py03qkUIWafadRqrnG72NzfMkE=";
    #        allowedIPs = [ "0.0.0.0/0" ];
    #        endpoint = "37.120.205.82:51820";
    #        persistentKeepalive = 25;
    #      }
    #    ];
    #  };
    # "wg_sharper" is the network interface name. You can name the interface arbitrarily.
    #wg_sharper = {
    # Determines the IP address and subnet of the client's end of the tunnel interface.
    #  ips = [ "172.28.3.22/32" ];
    #  listenPort = 51820; # to match firewall allowedUDPPorts (without this wg uses random port numbers)

    # Path to the private key file.
    #
    # Note: The private key can also be included inline via the privateKey option,
    # but this makes the private key world-readable; thus, using privateKeyFile is
    # recommended.
    #  privateKeyFile = "/home/agaia/repo/personal/dotfiles/modules/wireguard/private_key.key";

    #  peers = [
    # For a client configuration, one peer entry for the server will suffice.
    #    {
    # Public key of the server (not a file path).
    #      publicKey = "8vmTQMKzPBUiyVY9uEroOCOAd007M5Jft59RjXjBIEQ=";

    # Forward all the traffic via VPN.
    #      allowedIPs = [ "172.28.0.0/18" "172.17.200.0/24" "10.6.10.0/24" "10.8.10.0/24" "10.7.10.0/24" "10.2.10.0/24" "10.3.10.0/24" "10.4.10.0/24" "10.5.10.0/24" ];

    # Set this to the server IP and port.
    #      endpoint = "18.236.122.199:51820"; # TODO: route to endpoint not automatically configured https://wiki.archlinux.org/index.php/WireGuard#Loop_routing https://discourse.nixos.org/t/solved-minimal-firewall-setup-for-wireguard-client/7577

    # Send keepalives every 25 seconds. Important to keep NAT tables alive.
    #      persistentKeepalive = 25;
    #    }
    #  ];
    #};
    #};
  };

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  services.xserver = {
    # Enable touchpad support (enabled default in most desktopManager).
    libinput.enable = true;
  };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  #programs.mtr.enable = true;
  #programs.gnupg.agent = {
  #  enable = true;
  #  enableSSHSupport = true;
  #};

  services.opensnitch = {
    enable = false; # Enabling froze system, not sure why yet
  };

  services.dockerRegistry = {
    enable = false; # TODO
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

        #"reg" = {
        # Troubleshooting:
        #  * Is the registry running? (sudo systemctl status podman.registry)
        #  * Does the registry have an image for reg?
        #  * Registry is insecure. The address must match /etc/containers/registries.conf. If 'localhost' here, then cant be '127.0.0.1' in that file
        #  image = "127.0.0.1:5000/reg-docker-server:latest";
        #ports = [
        #  "127.0.0.1:5001:8080"
        #];
        # Had to use host network to point the --registry option to the host to get the registry.
        # Couldn't figure out podman's equlivalent of docker's '--add-host=host.docker.internal:host-gateway' (172.x.y.z)
        #  extraOptions = [ "--network=host" ];
        #  autoStart = true;
        #dependsOn = [ "registry" ];
        #  cmd = [ "reg" "server" "--listen-address" "127.0.0.1" "--port" "5001" "--registry" "localhost:5000" "--force-non-ssl" ];
        #};

        #"gitea" = {
        #  image = "docker.io/gitea/gitea:1.17.1";
        #  environment = {
        #    USER_ID = "1000";
        #    USER_GUID = "1000";
        #  };
        #  ports = [
        #    "127.0.0.1:3000:3000"
        #    "127.0.0.1:2222:22"
        #  ];
        #  volumes = [
        #    "/home/agaia/Data/gitea:/data"
        #  ];
        #  autoStart = true;
        #};

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

        #"homer" = {
        #  image = "docker.io/b4bz/homer:v22.07.2";
        #  autoStart = true;
        #  ports = [
        #    "127.0.0.1:8080:8080"
        #  ];
        #  volumes = [
        #    "/home/agaia/Data/homer:/www/assets"
        #  ];
        #};
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

  # Enable the OpenSSH daemon.
  # TODO: I think there is a bug causing systemd to hang on boot with my dell XPS. Need to investigate
  #services.openssh.enable = false; # DO NOT ENABLE

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?
}
