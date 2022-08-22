# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{ lib, ... }:

with lib.hm.gvariant;

{
  dconf.settings = {
    "apps/seahorse/listing" = {
      keyrings-selected = [ "secret-service:///org/freedesktop/secrets/collection/login" ];
    };

    "apps/seahorse/windows/key-manager" = {
      height = 476;
      width = 1078;
    };

    "org/gnome/Console" = {
      font-scale = 1.5000000000000004;
    };

    "org/gnome/control-center" = {
      last-panel = "mouse";
      window-state = mkTuple [ 980 640 ];
    };

    "org/gnome/desktop/app-folders" = {
      folder-children = [ "Utilities" "YaST" ];
    };

    "org/gnome/desktop/app-folders/folders/Utilities" = {
      apps = [ "gnome-abrt.desktop" "gnome-system-log.desktop" "nm-connection-editor.desktop" "org.gnome.baobab.desktop" "org.gnome.Connections.desktop" "org.gnome.DejaDup.desktop" "org.gnome.Dictionary.desktop" "org.gnome.DiskUtility.desktop" "org.gnome.eog.desktop" "org.gnome.Evince.desktop" "org.gnome.FileRoller.desktop" "org.gnome.fonts.desktop" "org.gnome.seahorse.Application.desktop" "org.gnome.tweaks.desktop" "org.gnome.Usage.desktop" "vinagre.desktop" ];
      categories = [ "X-GNOME-Utilities" ];
      name = "X-GNOME-Utilities.directory";
      translate = true;
    };

    "org/gnome/desktop/app-folders/folders/YaST" = {
      categories = [ "X-SuSE-YaST" ];
      name = "suse-yast.directory";
      translate = true;
    };

    "org/gnome/desktop/background" = {
      color-shading-type = "solid";
      picture-options = "zoom";
      picture-uri = "file:///nix/store/c9syx5aik0mfi2aqkylmgly1jyp18k3p-simple-blue-2016-02-19/share/backgrounds/nixos/nix-wallpaper-simple-blue.png";
      picture-uri-dark = "file:///nix/store/bdi6pyz8ykfvk5bsjlqgys9wxnhyvibm-simple-dark-gray-2016-02-19/share/backgrounds/nixos/nix-wallpaper-simple-dark-gray.png";
      primary-color = "#3a4ba0";
      secondary-color = "#2f302f";
    };

    "org/gnome/desktop/input-sources" = {
      sources = [ (mkTuple [ "xkb" "us" ]) ];
      xkb-options = [ "caps:escape" ];
    };

    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };

    "org/gnome/desktop/notifications" = {
      application-children = [ "org-gnome-console" "gnome-power-panel" "brave-browser" ];
    };

    "org/gnome/desktop/notifications/application/brave-browser" = {
      application-id = "brave-browser.desktop";
    };

    "org/gnome/desktop/notifications/application/gnome-power-panel" = {
      application-id = "gnome-power-panel.desktop";
    };

    "org/gnome/desktop/notifications/application/org-gnome-console" = {
      application-id = "org.gnome.Console.desktop";
    };

    "org/gnome/desktop/peripherals/mouse" = {
      speed = 4.484304932735439e-3;
    };

    "org/gnome/desktop/peripherals/touchpad" = {
      speed = 0.17592592592592582;
      tap-to-click = false;
      two-finger-scrolling-enabled = true;
    };

    "org/gnome/desktop/screensaver" = {
      color-shading-type = "solid";
      picture-options = "zoom";
      picture-uri = "file:///nix/store/c9syx5aik0mfi2aqkylmgly1jyp18k3p-simple-blue-2016-02-19/share/backgrounds/nixos/nix-wallpaper-simple-blue.png";
      primary-color = "#3a4ba0";
      secondary-color = "#2f302f";
    };

    "org/gnome/desktop/session" = {
      idle-delay = mkUint32 300;
    };

    "org/gnome/evolution-data-server" = {
      migrated = true;
      network-monitor-gio-name = "";
    };

    "org/gnome/mutter" = {
      attach-modal-dialogs = true;
      dynamic-workspaces = true;
      edge-tiling = true;
      focus-change-on-pointer-rest = true;
      workspaces-only-on-primary = true;
    };

    "org/gnome/settings-daemon/plugins/power" = {
      power-button-action = "suspend";
    };

    "org/gnome/shell" = {
      disable-user-extensions = true;
      favorite-apps = [ "org.gnome.Calendar.desktop" "org.gnome.Nautilus.desktop" "Alacritty.desktop" "brave-browser.desktop" ];
      welcome-dialog-last-shown-version = "42.3.1";
    };

    "org/gnome/shell/world-clocks" = {
      locations = "@av []";
    };

    "org/gnome/software" = {
      check-timestamp = mkInt64 1661087269;
      first-run = false;
    };

    "org/gnome/terminal/legacy" = {
      default-show-menubar = true;
      schema-version = 3;
      theme-variant = "default";
    };

    "org/gnome/terminal/legacy/profiles:" = {
      default = "5ddfe964-7ee6-4131-b449-26bdd97518f7";
      list = [ "5ddfe964-7ee6-4131-b449-26bdd97518f7" ];
    };

    "org/gnome/terminal/legacy/profiles:/:5ddfe964-7ee6-4131-b449-26bdd97518f7" = {
      audible-bell = false;
      background-color = "rgb(23,20,33)";
      backspace-binding = "ascii-delete";
      cursor-blink-mode = "system";
      cursor-shape = "block";
      delete-binding = "delete-sequence";
      font = "FiraCode Nerd Font Mono 12";
      foreground-color = "rgb(208,207,204)";
      login-shell = false;
      scroll-on-output = true;
      scrollback-lines = 10000;
      scrollbar-policy = "always";
      use-custom-command = false;
      use-system-font = false;
      use-theme-colors = false;
      visible-name = "Adam Default";
    };

    "org/gtk/gtk4/settings/file-chooser" = {
      date-format = "regular";
      location-mode = "path-bar";
      show-hidden = false;
      show-size-column = true;
      show-type-column = true;
      sidebar-width = 169;
      sort-column = "name";
      sort-directories-first = false;
      sort-order = "ascending";
      type-format = "category";
      window-size = mkTuple [ 888 374 ];
    };

  };
}
