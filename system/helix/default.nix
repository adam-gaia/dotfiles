{
  inputs,
  config,
  pkgs,
  ...
}: {
  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  imports = [ ./modules/syncthing/helix.nix ];

  environment = {
    etc = {
      darwin.source = "${inputs.darwin}";
    };
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
