{
  config,
  pkgs,
  lib,
  term,
  ...
}: {
  programs.alacritty = {
    enable = true;
    package = pkgs.alacritty;
    settings = with import ./colors/Sonokai.nix {}; {
      env = {
        TERM = "${term}"; # Defaults to 'alacritty' which breaks tmux's handling of color codes
      };
      dynamic_title = true;

      font = {
        normal = {
          family = "FiraCode Nerd Font";
          style = "Regular";
          #family: monospace
          #style: Regular
        };

        bold = {
          family = "FiraCode Nerd Font";
          style = "Bold";
          # family: monospace
          # style: Bold
        };

        italic = {
          family = "FiraCode Nerd Font";
          style = "Light";
          # family: monospace
          # style: Italic
        };

        bold_italic = {
          family = "FiraCode Nerd Font";
          style = "Regular";
          # family: monospace
          # style: Bold Italic
        };

        size = 14;
        #use_thin_strokes = true;
      };

      draw_bold_text_with_bright_colors = false;

      cursor = {
        style = {
          shape = "Block";
        };
        blinking = "On";
        vi_mode_style = "Beam";
        blink_interval = 750;
        unfocused_hollow = true;
        thickness = 0.15;
      };

      colors = colors;

      key_bindings = [
        {
          key = "N";
          mods = "Control|Shift";
          action = "SpawnNewInstance";
        }
      ];
      # TODO: Because I set tmux as my login shell and then run zsh as a subshell,
      # creating a new window will not open the with working directory the same as the previous window
      # See https://github.com/alacritty/alacritty/issues/2155
    };
  };
}
