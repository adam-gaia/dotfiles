{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.firefox = {
    enable = true;
    package = pkgs.wrapFirefox pkgs.firefox-unwrapped {
      #forceWayland = true; // Commented out for mac. Might need to reenable for linux
      extraPolicies = {
        ExtensionSettings = {};
      };
    };
    profiles.adam = {
      id = 0;
      isDefault = true;
      settings = {
        #"browser.startup.homepage" = "localhost:8080"; # TODO: use a variable to point to home service in system config
        "browser.search.region" = "US";
        "browser.search.isUS" = true;
        "browser.bookmarks.showMobileBookmarks" = true;
      };
    };
  };
}
