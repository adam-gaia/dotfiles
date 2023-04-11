{
  config,
  lib,
  pkgs,
  ...
}: let
  colors = (import ./colors/Sonokai.nix) {};
in {
  # Modified from Aditya Shakya's dotfiles
  # https://github.com/Aspectsides/dotfiles/blob/96b1bb2367cf1a6afe4a5bc3a363d248d570e9c6/dot_config/rofi/config.rasi
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    plugins = with pkgs; [rofi-calc];
    theme = let
      inherit (config.lib.formats.rasi) mkLiteral;
    in {
      "configuration" = {
        modi = "drun,run,filebrowser,calc"; #,window
        show-icons = false;
        display-drun = " Apps";
        display-run = " Run";
        display-filebrowser = " Files";
        display-window = " Windows";
        display-calc = " Calc";
        drun-display-format = "{name}";
        window-format = "{w} · {c} · {t}";
      };

      "*" = {
        foreground = mkLiteral colors.colors.primary.foreground;
        background = mkLiteral colors.colors.primary.background;
        background-alt = mkLiteral colors.colors.normal.black;
        selected = mkLiteral colors.colors.normal.blue;
        active = mkLiteral colors.colors.normal.green;
        urgent = mkLiteral colors.colors.normal.red;

        border-colour = mkLiteral "var(selected)";
        handle-colour = mkLiteral "var(selected)";
        background-colour = mkLiteral "var(background)";
        foreground-colour = mkLiteral "var(foreground)";
        alternate-background = mkLiteral "var(background-alt)";
        normal-background = mkLiteral "var(background)";
        normal-foreground = mkLiteral "var(foreground)";
        urgent-background = mkLiteral "var(urgent)";
        urgent-foreground = mkLiteral "var(background)";
        active-background = mkLiteral "var(active)";
        active-foreground = mkLiteral "var(background)";
        selected-normal-background = mkLiteral "var(selected)";
        selected-normal-foreground = mkLiteral "var(background)";
        selected-urgent-background = mkLiteral "var(active)";
        selected-urgent-foreground = mkLiteral "var(background)";
        selected-active-background = mkLiteral "var(urgent)";
        selected-active-foreground = mkLiteral "var(background)";
        alternate-normal-background = mkLiteral "var(background)";
        alternate-normal-foreground = mkLiteral "var(foreground)";
        alternate-urgent-background = mkLiteral "var(urgent)";
        alternate-urgent-foreground = mkLiteral "var(background)";
        alternate-active-background = mkLiteral "var(active)";
        alternate-active-foreground = mkLiteral "var(background)";
      };

      "window" = {
        # properties for window widget
        transparency = "real";
        location = mkLiteral "center";
        anchor = mkLiteral "center";
        fullscreen = false;
        width = mkLiteral "800px";
        x-offset = mkLiteral "0px";
        y-offset = mkLiteral "0px";
        # properties for all widgets
        enabled = true;
        margin = mkLiteral "0px";
        padding = mkLiteral "0px";
        border = mkLiteral "0px solid";
        border-radius = mkLiteral "10px";
        border-color = mkLiteral "@border-colour";
        cursor = "default";
        # Backgroud Colors
        background-color = mkLiteral "@background-colour";
        # Backgroud Image
        #background-image = mkLiteral "url(\"/path/to/image.png\", none)";
        # Simple Linear Gradient
        #background-image = mkLiteral "linear-gradient(red, orange, pink, purple)";
        # Directional Linear Gradient
        #background-image = mkLiteral "linear-gradient(to bottom, pink, yellow, magenta)";
        # Angle Linear Gradient
        #background-image = mkLiteral "linear-gradient(45, cyan, purple, indigo)";
      };

      "mainbox" = {
        enabled = true;
        spacing = mkLiteral "10px";
        margin = mkLiteral "0px";
        padding = mkLiteral "20px";
        border = mkLiteral "0px solid";
        border-radius = mkLiteral "0px 0px 0px 0px";
        border-color = mkLiteral "@border-colour";
        background-color = mkLiteral "transparent";
        children = mkLiteral "[\"inputbar\", \"mode-switcher\", \"message\", \"listview\"]";
      };

      "inputbar" = {
        enabled = true;
        spacing = mkLiteral "10 px";
        margin = mkLiteral "0 px";
        padding = mkLiteral "0 px";
        border = mkLiteral "0 px solid";
        border-radius = mkLiteral "0 px";
        border-color = mkLiteral "@border-colour";
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "@foreground-colour";
        children = mkLiteral "[ \"textbox-prompt-colon\", \"entry\" ]";
      };

      "prompt" = {
        enable = true;
        background-color = mkLiteral "inherit";
        text-color = mkLiteral "inherit";
      };

      "textbox-prompt-colon" = {
        enabled = true;
        padding = mkLiteral "5px 0px";
        expand = true;
        str = "";
        background-color = mkLiteral "inherit";
        text-color = mkLiteral "inherit";
      };

      "entry" = {
        enable = true;
        padding = mkLiteral "5px 0px";
        background-color = mkLiteral "inherit";
        text-color = mkLiteral "inherit";
        cursor = mkLiteral "text";
        placeholder = "Search...";
        palceholder-color = mkLiteral "inherit";
      };

      "num-filtered-rows" = {
        enabled = true;
        expand = false;
        background-color = mkLiteral "inherit";
        text-color = mkLiteral "inherit";
      };

      "textbox-num-sep" = {
        enabled = true;
        expand = false;
        str = "/";
        background-color = mkLiteral "inherit";
        text-color = mkLiteral "inherit";
      };

      "num-rows" = {
        enabled = true;
        expand = false;
        background-color = mkLiteral "inherit";
        text-color = mkLiteral "inherit";
      };

      "case-indicator" = {
        enabled = true;
        background-color = mkLiteral "inherit";
        text-color = mkLiteral "inherit";
      };

      "listview" = {
        enabled = true;
        columns = 1;
        lines = 8;
        cycle = true;
        dynamic = true;
        scrollbar = false;
        layout = mkLiteral "vertical";
        reverse = false;
        fixed-height = true;
        fixed-columns = true;
        spacing = mkLiteral "5px";
        margin = mkLiteral "0px";
        padding = mkLiteral "0px";
        border = mkLiteral "0px solid";
        border-radius = mkLiteral "0px";
        border-color = mkLiteral "@border-colour";
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "@foreground-colour";
        cursor = mkLiteral "default";
      };

      "scrollbar" = {
        handle-width = mkLiteral "5px";
        handle-color = mkLiteral "@handle-colour";
        border-radius = mkLiteral "10px";
        background-color = mkLiteral "@alternate-background";
      };

      "element" = {
        enabled = true;
        spacing = mkLiteral "10 px";
        margin = mkLiteral "0 px";
        padding = mkLiteral "10 px";
        border = mkLiteral "0 px solid";
        border-radius = mkLiteral "8 px";
        border-color = mkLiteral "@border-colour";
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "@foreground-colour";
        cursor = mkLiteral "pointer";
      };

      "element normal.normal" = {
        background-color = mkLiteral "var (normal-background)";
        text-color = mkLiteral "var (normal-foreground)";
      };

      "element normal.urgent" = {
        background-color = mkLiteral "var (urgent-background)";
        text-color = mkLiteral "var (urgent-foreground)";
      };

      "element normal.active" = {
        background-color = mkLiteral "var (active-background)";
        text-color = mkLiteral "var (active-foreground)";
      };

      "element selected.normal" = {
        background-color = mkLiteral "var (selected-normal-background)";
        text-color = mkLiteral "var (selected-normal-foreground)";
      };

      "element selected.urgent" = {
        background-color = mkLiteral "var (selected-urgent-background)";
        text-color = mkLiteral "var (selected-urgent-foreground)";
      };

      "element selected.active" = {
        background-color = mkLiteral "var (selected-active-background)";
        text-color = mkLiteral "var (selected-active-foreground)";
      };

      "element alternate.normal" = {
        background-color = mkLiteral "var (alternate-normal-background)";
        text-color = mkLiteral "var (alternate-normal-foreground)";
      };

      "element alternate.urgent" = {
        background-color = mkLiteral "var (alternate-urgent-background)";
        text-color = mkLiteral "var (alternate-urgent-foreground)";
      };

      "element alternate.active" = {
        background-color = mkLiteral "var (alternate-active-background)";
        text-color = mkLiteral "var (alternate-active-foreground)";
      };

      "element-icon" = {
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "inherit";
        size = mkLiteral "24px";
        cursor = mkLiteral "inherit";
      };

      "element-text" = {
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "inherit";
        highlight = mkLiteral "inherit";
        cursor = mkLiteral "inherit";
        vertical-align = mkLiteral "0.5";
        horizontal-align = mkLiteral "0.0";
      };

      "mode-switcher" = {
        enabled = true;
        expand = false;
        spacing = mkLiteral "10px";
        margin = mkLiteral "0px";
        padding = mkLiteral "0px";
        border = mkLiteral "0px solid";
        border-radius = mkLiteral "0px";
        border-color = mkLiteral "@border-colour";
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "@foreground-colour";
      };

      "button" = {
        padding = mkLiteral "12px";
        border = mkLiteral "0px solid";
        border-radius = mkLiteral "8px";
        border-color = mkLiteral "@border-colour";
        background-color = mkLiteral "@alternate-background";
        text-color = mkLiteral "inherit";
        cursor = mkLiteral "pointer";
      };

      "button selected" = {
        background-color = mkLiteral "var (selected-normal-background)";
        text-color = mkLiteral "var (selected-normal-foreground)";
      };

      "message" = {
        enabled = true;
        margin = mkLiteral "0 px";
        padding = mkLiteral "0 px";
        border = mkLiteral "0 px solid";
        border-radius = mkLiteral "0 px 0 px 0 px 0 px";
        border-color = mkLiteral "@border-colour";
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "@foreground-colour";
      };

      "textbox" = {
        padding = mkLiteral "12 px";
        border = mkLiteral "0 px solid";
        border-radius = mkLiteral "8 px";
        border-color = mkLiteral "@border-colour";
        background-color = mkLiteral "@alternate-background";
        text-color = mkLiteral "@foreground-colour";
        vertical-align = mkLiteral "0.5";
        horizontal-align = mkLiteral "0.0";
        highlight = mkLiteral "none";
        placeholder-color = mkLiteral "@foreground-colour";
        blink = true;
        markup = true;
      };

      "error-message" = {
        padding = mkLiteral "0 px";
        border = mkLiteral "2 px solid";
        border-radius = mkLiteral "8 px";
        border-color = mkLiteral "@border-colour";
        background-color = mkLiteral "@background-colour";
        text-color = mkLiteral "@foreground-colour";
      };
    };
  };
}
