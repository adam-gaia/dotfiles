{
  pkgs,
  lib,
  ...
}: {
  # DNS server
  services.bind = {
    enable = true;
    extraConfig = ''
      include "/var/lib/secrets/dnskeys.conf";
    '';
    zones = [
      rec {
        name = "gmoff.net";
        file = "/var/db/bind/${name}";
        master = true;
        extraConfig = "allow-update { key rfc2136key.gmoff.net; };";
      }
    ];
  };

  # Now we can configure ACME
  security.acme.acceptTerms = true;
  security.acme.defaults.email = "admin+acme@gmoff.net"; # TODO: read from git-crypt config file
  security.acme.certs."gmoff.net" = {
    domain = "*.gmoff.net";
    dnsProvider = "rfc2136";
    credentialsFile = "/var/lib/secrets/certs.secret";
    # We don't need to wait for propagation since this is a local DNS server
    dnsPropagationCheck = false;
  };

  # The dnskeys.conf and certs.secret must be kept secure and thus you should not keep their contents in your Nix config. Instead, generate them one time with a systemd service
  systemd.services.dns-rfc2136-conf = {
    requiredBy = ["acme-gmoff.net.service" "bind.service"];
    before = ["acme-gmoff.net.service" "bind.service"];
    unitConfig = {
      ConditionPathExists = "!/var/lib/secrets/dnskeys.conf";
    };
    serviceConfig = {
      Type = "oneshot";
      UMask = 0077;
    };
    path = [pkgs.bind];
    script = ''
      mkdir -p /var/lib/secrets
      chmod 755 /var/lib/secrets
      tsig-keygen rfc2136key.gmoff.net > /var/lib/secrets/dnskeys.conf
      chown named:root /var/lib/secrets/dnskeys.conf
      chmod 400 /var/lib/secrets/dnskeys.conf

      # extract secret value from the dnskeys.conf
      while read x y; do if [ "$x" = "secret" ]; then secret="''${y:1:''${#y}-3}"; fi; done < /var/lib/secrets/dnskeys.conf

      cat > /var/lib/secrets/certs.secret << EOF
      RFC2136_NAMESERVER='127.0.0.1:53'
      RFC2136_TSIG_ALGORITHM='hmac-sha256.'
      RFC2136_TSIG_KEY='rfc2136key.gmoff.net'
      RFC2136_TSIG_SECRET='$secret'
      EOF
      chmod 400 /var/lib/secrets/certs.secret
    '';
  };

  # services.nginx = {
  #   enable = true;
  #   virtualHosts = {
  #     "argo.gmoff.net" = {
  #       forceSSL = true;
  #       enableACME = true;
  #       # All serverAliases will be added as extra domain names on the certificate.
  #       serverAliases = [ "test1.gmoff.net" ];
  #       locations."/" = {
  #         root = "/var/www";
  #       };
  #     };
  #   };
  # };
}
