{
  pkgs,
  lib,
  ...
}: {
  # Keycloak expects X libs
  environment.noXlibs = false;
}
