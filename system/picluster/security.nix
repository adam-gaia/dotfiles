{
  config,
  pkgs,
  lib,
  ...
}: {
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
}
