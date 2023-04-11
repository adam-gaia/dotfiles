{pkgs, ...}: {
  environment.systemPackages = with pkgs; [protonvpn-gui];

  networking.wg-quick.interfaces = {
    # "proton-us" is the network interface name. You can name the interface arbitrarily.
    proton-us = {
      address = ["10.2.0.2/32"];
      privateKeyFile = "/home/agaia/repo/personal/dotfiles/modules/wireguard/proton-us.key"; # TODO: relative paths for string?
      peers = [
        {
          # peer0
          publicKey = "fM5t18SNQhPw5zXr/6crLPu9KseB3/BeDF+McXoclmg=";
          allowedIPs = ["0.0.0.0/0"];
          endpoint = "107.181.245.74:51820";
        }
      ];
    };
    #proton-ca = {
    #  address = [ "10.2.0.2/32" ];
    #  privateKeyFile = "/home/agaia/repo/personal/dotfiles/modules/wireguard/proton-ca.key"; # TODO: relative paths for string?
    #  peers = [
    #    {
    #      # peer0
    #      publicKey = "5YxjJV/w2nIQHnh80py03qkUIWafadRqrnG72NzfMkE=";
    #      allowedIPs = [ "0.0.0.0/0" ];
    #      endpoint = "37.120.205.82:51820";
    #    }
    #  ];
    #};
    #proton-fi = {
    #  address = [ "10.2.0.2/32" ];
    #  privateKeyFile = "/home/agaia/repo/personal/dotfiles/modules/wireguard/proton-fi.key"; # TODO: relative paths for string?
    #  peers = [
    #    {
    #      # peer0
    #      publicKey = "cdx8bADYVWBlHkg6Ekl6k2y0kjkYNFagN2ttPC128HU=";
    #      allowedIPs = [ "0.0.0.0/0" ];
    #      endpoint = "37.120.205.82:51820";
    #    }
    #  ];
    #};
    sharper = {
      address = ["172.28.3.22/32"];
      privateKeyFile = "/home/agaia/repo/personal/dotfiles/modules/wireguard/private_key.key";
      peers = [
        {
          publicKey = "8vmTQMKzPBUiyVY9uEroOCOAd007M5Jft59RjXjBIEQ=";
          allowedIPs = ["10.242.0.0/16" "172.28.0.0/18" "172.17.200.0/24" "10.6.10.0/24" "10.8.10.0/24" "10.7.10.0/24" "10.2.10.0/24" "10.3.10.0/24" "10.4.10.0/24" "10.5.10.0/24"];
          endpoint = "18.236.122.199:51820"; # TODO: route to endpoint not automatically configured https://wiki.archlinux.org/index.php/WireGuard#Loop_routing https://discourse.nixos.org/t/solved-minimal-firewall-setup-for-wireguard-client/7577
          persistentKeepalive = 25;
        }
      ];
    };
  };
}
