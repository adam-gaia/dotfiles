{
  config,
  pkgs,
  lib,
  ...
}: {
  services.syncthing = {
    enable = true;
    guiAddress = "localhost:8384";

    dataDir = "/home/agaia/Documents";
    # TODO: the config dir must persist or this device will regen an ID. Find a way to do that better
    configDir = "/home/agaia/.config/syncthing";

    user = "agaia";
    group = "users";

    # Ignore settings set in the web UI - this file is the only source of truth
    overrideDevices = true;
    overrideFolders = true;

    devices = {
      "helix" = {
        name = "helix";
        id = lib.strings.removeSuffix "\n" (builtins.readFile ./helix.id);
        autoAcceptFolders = true; # Auto accept folders from this device
      };
    };

    folders = {
      "Documents" = {
        path = "/home/agaia/Documents";
        ignorePerms = false;
        devices = ["helix"];
      };
      "Desktop" = {
        path = "/home/agaia/Desktop";
        ignorePerms = false;
        devices = ["helix"];
      };
      "repo" = {
        path = "/home/agaia/repo";
        ignorePerms = false;
        devices = ["helix"];
        versioning = {
          # See https://wes.today/nixos-syncthing/ for notes on staggered versioning
          type = "staggered";
          params = {
            cleanInterval = "3600"; # 1 hour
            maxAge = "15552000"; # 180 days in seconds
          };
        };
      };
    };
  };

  # Open ports for syncthing
  networking.firewall.allowedTCPPorts = [8384 22000];
  networking.firewall.allowedUDPPorts = [22000 21027];
}
