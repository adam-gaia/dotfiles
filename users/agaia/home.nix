{ config, pkgs, unstable-pkgs, git-shim, ... }:

let
  term = "xterm-256color";
  packages = with pkgs; [
    docker-compose
    bat
    neovim
    neomutt  
    python3
    jq
    lynx
    m4
    neofetch
    tree
    w3m
    htop
    unzip
    rclone
    rsync
    grc
    pigz
    git-lfs
    sshpass
    nmap
    clang
    git-crypt
    ripgrep
    lsd
    protonvpn-gui
    protonvpn-cli
    cowsay
    fortune
    gdb
    gzip
    watch
    htop
    rsync
    nmap
    bitwarden-cli
    vivid
    fd
    didyoumean
    du-dust
    nodejs
    terraform-ls
    nodePackages.bash-language-server
    nodePackages.yaml-language-server
    ansible
    commitizen
    pre-commit
    xxh
    navi
    sumneko-lua-language-server
    htmlq
    nixpkgs-fmt
    shellcheck
    glab
    git-shim.defaultPackage.${system}
    unstable-pkgs.starship
    unstable-pkgs.ctop
  ];

in
{
  imports = [ ../../modules/dconf.nix ];

  programs = {
    # Let home manager install and enable itself
    home-manager.enable = true;

    firefox = {
      enable = true;
      package = pkgs.wrapFirefox pkgs.firefox-unwrapped {
        forceWayland = true;
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

    zsh = {
      enable = true;
      enableAutosuggestions = true;
      enableCompletion = true;
      enableSyntaxHighlighting = true;
      enableVteIntegration = true;
      completionInit = "autoload -Uz compinit && compinit";
      dotDir = ".config/zsh";

      history.save = 100000;
      history.size = 100000;
      history.path = "\${XDG_CACHE_HOME}/zsh/history";
      history.ignoreDups = true;
      history.extended = true;

      plugins = [
        {
          # This plugin hijacks 'nix-shell' in order to run zsh instead of bash
          name = "zsh-nix-shell";
          file = "nix-shell.plugin.zsh";
          src = pkgs.fetchFromGitHub {
            owner = "chisui";
            repo = "zsh-nix-shell";
            rev = "v0.5.0";
            sha256 = "0za4aiwwrlawnia4f29msk822rj9bgcygw6a8a6iikiwzjjz0g91";
          };
        }
        {
          name = "zsh-autosuggestions";
          file = "zsh-autosuggestions.zsh";
          src = pkgs.fetchFromGitHub {
            owner = "zsh-users";
            repo = "zsh-autosuggestions";
            rev = "v0.7.0";
            sha256 = "sha256-KLUYpUu4DHRumQZ3w59m9aTW6TBKMCXl2UcKi4uMd7w=";
          };
        }
        {
          name = "zsh-syntax-highlighting";
          file = "zsh-syntax-highlighting.zsh";
          src = pkgs.fetchFromGitHub {
            owner = "zsh-users";
            repo = "zsh-syntax-highlighting";
            rev = "0.7.1";
            sha256 = "sha256-gOG0NLlaJfotJfs+SUhGgLTNOnGLjoqnUp54V9aFJg8=";
          };
        }
        {
          name = "zsh-completions";
          file = "zsh-completions.plugin.zsh";
          src = pkgs.fetchFromGitHub {
            owner = "zsh-users";
            repo = "zsh-completions";
            rev = "0.34.0";
            sha256 = "sha256-qSobM4PRXjfsvoXY6ENqJGI9NEAaFFzlij6MPeTfT0o=";
          }; 
        }
        {
          name = "zsh-abbr";
          file = "zsh-abbr.zsh";
          src = pkgs.fetchFromGitHub {
            owner = "olets";
            repo = "zsh-abbr";
            rev = "v4.8.0";
            sha256 = "sha256-diitszKbu530zXbJx4xmfOjLsITE9ucmWdsz9VTXsKg=";
          };
        }
      ];

      initExtraFirst = ''
        # --------------------------------------------------
        # Shell & term options
        # --------------------------------------------------
        # Disable ctrl-s freezes terminal
        stty stop undef

        # No bell beep
        unsetopt beep

        # Report background jobs at next prompt instead of immediatly
        unsetopt notify

        # Prompt to fix misspelled commands
        setopt correct
        setopt correct_all # Try to correct args too

        # Allow comments in the interactive shell (makes it ok to type '# comment')
        setopt interactive_comments

        # Disable pressing ctrl-d will exit the current shell
        setopt IGNOREEOF

        # Redirecting to an existing file will error out instead of overriding the file
        setopt NOCLOBBER

        # If a parameter is completed whose content is the name of a directory, then add a trailing slash instead of a space.
        setopt AUTO_PARAM_SLASH

        # Glob will match dot files without the explicit dot. Lets tab complete suggest dotfiles
        setopt globdots

        # Use readline keybinds even though we use vim as the default editor
        bindkey -e

        if command -v vivid &>/dev/null; then
          # Set file colors based on type
          export LS_COLORS="$(vivid --database ~/.config/vivid/filetypes.yml generate ~/.config/vivid/sonokai-theme.yml)" # TODO: we should only generate once when provisioning the machine and set to that output in here
        fi

        # Suggestion strategies
        export ZSH_AUTOSUGGEST_STRATEGY=(completion history)

        # History search with up and down arrows
        #bindkey '^[[A' history-substring-search-up
        #bindkey '^[[B' history-substring-search-down

        setopt HIST_SAVE_NO_DUPS       # Do not save duplicated command
        setopt HIST_REDUCE_BLANKS      # Remove unnecessary blanks
        setopt INC_APPEND_HISTORY_TIME # Append command to history file immediately after execution



        # --------------------------------------------------------------------------------
        # Starship prompt
        # --------------------------------------------------------------------------------
        if command -v starship &>/dev/null; then
          eval "$(starship init zsh)"
        fi
      '';

      initExtra = "source \${XDG_CONFIG_HOME}/zsh/functions.zsh";


      loginExtra = "";
      logoutExtra = "[ $SHLVL = 1 ] && [ -x /usr/bin/clear_console ] && /usr/bin/clear_console -q || clear";


      shellAliases = {
        reload = "exec zsh";

        # Zsh's 'history' builtin only shows 16 items. This alias shows all history
        history = "fc -l 1";

        grep = "grep --color=always";
        fd = "fd --color=always";

        ls = "lsd -alh --color=always"; # TODO: figure out how to use 'ind' with lsd while keeping the info we want from lsd # The only way I could get the indentation to work. If ls was already an alias, it would lose color with ind.

        vim = "nvim";
        vi = "vim";
        emacs = "vim"; # lol

        # git
        ga = "git add";
        gc = "git commit";
        gpl = "git pull";
        gps = "git push";
        gf = "git fetch";
        gb = "git branch";
        gm = "git merge";

        # cd with ease
        ".." = "cd ..";
        "..2" = "cd ../..";
        "..3" = "cd ../../..";
        "..4" = "cd ../../../..";
        "..5" = "cd ../../../../..";

        ":q" = "exit";

        # :D
        simonsays = "sudo";

        # Use htop instead of top
        top = "htop";

        colorify = "grc -es --colour=auto";
        blkid = "colorify blkid";
        df = "colorify df";
        diff = "colorify diff";
        docker = "colorify docker";
        docker-machine = "colorify docker-machine";
        du = "colorify du";
        env = "colorify env";
        free = "colorify free";
        fdisk = "colorify fdisk";
        findmnt = "colorify findmnt";
        make = "colorify make --warn-undefined-variables"; # Make make a little safer
        gcc = "colorify gcc";
        "g++" = "colorify g++";
        id = "colorify id";
        ip = "colorify ip";
        iptables = "colorify iptables";
        as = "colorify as";
        gas = "colorify gas";
        ld = "colorify ld";
        #ls = "colorify ls";
        lsof = "colorify lsof";
        lsblk = "colorify lsblk";
        lspci = "colorify lspci";
        netstat = "colorify netstat";
        ping = "colorify ping";
        traceroute = "colorify traceroute";
        traceroute6 = "colorify traceroute6";
        head = "colorify head";
        tail = "colorify tail";
        dig = "colorify dig";
        mount = "colorify mount";
        ps = "colorify ps";
        mtr = "colorify mtr";
        semanage = "colorify semanage";
        getsebool = "colorify getsebool";
        ifconfig = "colorify ifconfig";

        tree = "lsd --tree --color=always";

        # Let 'cat' invoke bat with only syntax highlighting.
        # I'll get in the habit of running 'bat' when I want a pager
        cat = "bat --plain --pager=never";
      };
    };

    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };

    tmux = {
      enable = true;
      tmuxp.enable = true; # https://github.com/tmux-python/tmuxp
      plugins = with pkgs; [
        tmuxPlugins.sensible
        {
          plugin = tmuxPlugins.resurrect;
          extraConfig = ''
            set -g @resurrect-strategy-nvim 'session'
            set -g @resurrect-strategy-vim 'session'
            set -g @resurrect-capture-pane-contents 'on'
          '';
        }
        {
          plugin = tmuxPlugins.continuum;
          extraConfig = ''
            set -g @continuum-restore 'on'
            set -g @continuum-save-interval '60' # minutes
          '';
        }
      ];
      extraConfig = ''
        # Set prefix to ctrl-space
        # unbind C-b
        # set-option -g prefix C-Space

        # Enable scrolling by default
        set -g mouse on

        # Allow vim colors to overrule tmux colors when in vim. Advised to do this to prevent color issues with vim
        set -g default-terminal "screen-256color"
        set -g terminal-overrides 'xterm:colors=256'

        # Tweaks to fix issue with tmux
        # See https://github.com/neovim/neovim/wiki/FAQ#esc-in-tmux-or-gnu-screen-is-delayed
        # and run ':checkhealth'
        set -sg escape-time 10
        set -g focus-events on
        set-option -sa terminal-overrides ',xterm-256color:RGB'


        # Highlight color
        set -g mode-style 'reverse' # TODO: alacritty's highlight inverts foreground and background color. Can this be done in tmux?

        # Border over active window
        set -g pane-border-style fg=white
        set -g pane-active-border-style fg=blue

        # Status bar on
        set -g status

        # Pane border status on too
        set -g pane-border-status  # TODO: change the info to something better

        # Grey status bar
        set -g status-bg colour8

        # Set status bar info display
        set -g status-left '[#S] '
        set -g status-right "#{?pane_synchronized,--SYNCED--,} #(is-online) #(battery -t -g black)  #(date '+%a %b%d %I:%M') "


        # --------------------------------------------------------------
        # Smart pane switching with awareness of Vim splits.
        # ctrl-h/j/k/l
        # See: https://github.com/christoomey/vim-tmux-navigator
        # --------------------------------------------------------------
        is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
            | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"
        bind-key -n 'C-h' if-shell "$is_vim" 'send-keys C-h'  'select-pane -L'
        bind-key -n 'C-j' if-shell "$is_vim" 'send-keys C-j'  'select-pane -D'
        bind-key -n 'C-k' if-shell "$is_vim" 'send-keys C-k'  'select-pane -U'
        bind-key -n 'C-l' if-shell "$is_vim" 'send-keys C-l'  'select-pane -R'
        tmux_version='$(tmux -V | sed -En "s/^tmux ([0-9]+(.[0-9]+)?).*/\1/p")'
        if-shell -b '[ "$(echo "$tmux_version < 3.0" | bc)" = 1 ]' \
            "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\'  'select-pane -l'"
        if-shell -b '[ "$(echo "$tmux_version >= 3.0" | bc)" = 1 ]' \
            "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\\\'  'select-pane -l'"

        bind-key -T copy-mode-vi 'C-h' select-pane -L
        bind-key -T copy-mode-vi 'C-j' select-pane -D
        bind-key -T copy-mode-vi 'C-k' select-pane -U
        bind-key -T copy-mode-vi 'C-l' select-pane -R
        bind-key -T copy-mode-vi 'C-\' select-pane -l # VS-code syntax highlight thinks the backslash escapes the quote. One more quote in this comment puts things back to normal '

        # Bring back clear screen under tmux prefix
        bind C-l send-keys 'C-l'


        # --------------------------------------------------------------
        # Properly display undercurls (squiggly lines under syntax errors in vim)
        # --------------------------------------------------------------
        #set -g default-terminal "${term}"
        set -as terminal-overrides ',*:Smulx=\E[4::%p1%dm'  # undercurl support
        set -as terminal-overrides ',*:Setulc=\E[58::2::%p1%{65536}%/%d::%p1%{256}%/%{255}%&%d::%p1%{255}%&%d%;m'  # underscore colours - needs tmux-3.0


        # --------------------------------------------------------------
        # Key binds
        # --------------------------------------------------------------
        bind-key j run-shell '/home/sarcos/repo/scripts/tmux-popup.sh'
      '';
    };

    #[filter "lfs"]
    #  clean = git-lfs clean -- %f
    #  smudge = git-lfs smudge -- %f
    #  process = git-lfs filter-process
    #  required = true

    #[color "grep"]
    #  linenumber = green
    #    filename = "magenta"

    #[color "diff"]
    #  meta = white
    #  frag = magenta
    #  new = green

    #[color "status"]
    #  added = green
    #  changed = yellow
    #  untracked = red

    #[diff "bin"]
    # Use `hexdump` to diff binary files.
    # From https://github.com/alrra/dotfiles/blob/main/src/git/gitconfig
    #    textconv = hexdump --canonical --no-squeezing

    git = {
      enable = true;
      lfs.enable = true;
      aliases = {
        url = "remote get-url origin";
        visual = "!gitk";
        root = "rev-parse --show-toplevel";
        batch = "!gitbatch";
        repos = "track-repos"; # Shortcut for my git-track-repos command. https://gitlab.com/adam_gaia/git-track-repos
      };
      includes = [
        {
          path = "~/.config/git/config-work";
          condition = "gitdir:~/repo/work/";
        }
        {
          path = "~/.config/git/config-personal";
          condition = "gitdir:~/repo/personal/";
        }
      ];

      #hooks = {
      #  pre-commit = "~/.config/git/pre-commit-script";
      #};

      ignores = [
        # Ignore temporary files
        "*~"

        # Ignore compiled binaries
        "*.com"
        "*.class"
        "*.dll"
        "*.exe"
        "*.o"
        "*.so"

        # Ignore OS generated files
        ".DS_Store*"
        "ehthumbs.db"
        "Icon?"
        "Thumbs.db"

        # Ignore compressed files
        "*.7z"
        "*.dmg"
        "*.gz"
        "*.iso"
        "*.jar"
        "*.rar"
        "*.tar"
        "*.zip"

        # Ignore compilation database - created by Bear for a Vim complete plugin - https://github.com/rizsotto/Bear
        "compile_commands.json"

        # Ignore special extension
        "*.nogit"

        # Ignore databases
        "*.db"

        # Ignore ssh keys TODO: is there a more standard regex for keys?
        "id_*"
        "id_rsa*"

        # Ignore pypirc. It contains api keys
        "*pypirc*"
      ];

      extraConfig = {
        credential.helper = "${
          pkgs.git.override { withLibsecret = true; }
        }/bin/git-credential-libsecret";

        core = {
          editor = "vim";
          pager = "less";
          whitespace = "fix,-indent-with-non-tab,trailing-space,cr-at-eol";
        };

        init = {
          defaultBranch = "main";
          templateDir = "~/.config/git/template-dir";
        };

        advice = {
          detachedHead = false;
        };

        merge = {
          conflictstyle = "diff3";
        };

        color = {
          ui = "auto";
        };
      };
    };

    #gl = {
    #  enable = true;
    #};

    alacritty = {
      enable = true;
      package = unstable-pkgs.alacritty;
      settings = with import ../../modules/colors/Sonokai.nix { }; {
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

    fzf = {
      enable = true;
      # Fzf keybinds (ctrl-r history, ctrl-t file paths, alt-c cd to dir)
      enableZshIntegration = true;
    };

    vscode = {
      enable = true;
      extensions = with pkgs.vscode-extensions; [
      ];
    };

    chromium = {
      enable = true;
      package = pkgs.brave;
    };

  };


  home.sessionVariables = {
    GIT_DISCOVERY_ACROSS_FILESYSTEM = "1";
    PRE_COMMIT_ALLOW_NO_CONFIG="1"; # TODO: can we configure pre-commit with a config instead of setting this?

    XDG_CONFIG_HOME = "/home/agaia/.config";
    XDG_CACHE_HOME = "/home/agaia/.cache";

    # Tell firefox to use wayland features
    MOZ_ENABLE_WAYLAND = 1;

    EDITOR = "vim";
    PAGER = "less";
    LESS = "-RF --LONG-PROMPT --mouse --wheel-lines=5";
    RIPGREP_CONFIG_PATH = "/home/agaia/.config/ripgrep/config";
    PYTHONSTARTUP = "/home/agaia/.config/python/pythonrc.py";

    # Heads up: Colors are mapped to the Pywal Monokai scheme
    # TODO: checkout color heading from https://github.com/dylanaraps/pure-sh-bible#get-the-directory-name-of-a-file-path
    RED = "\\033[31m";
    GREEN = "\\033[32m";
    YELLOW = "\\033[33m";
    BLUE = "\\033[34m";
    BLACK = "\\033[90m";
    PURPLE = "\\033[35m";
    CYAN = "\\033[36m";
    END_COLOR = "\\033[m";
    UNDERLINE_ON = "\\033[4m";
    UNDERLINE_OFF = "\\033[24m";
    BOLD_ON = "\\033[1m";
    BOLD_OFF = "\\033[21m";

    # Set less colors - Updated to use tput from https://unix.stackexchange.com/a/147
    LESS_TERMCAP_mb = "$(tput bold; tput setaf 2)"; # green
    LESS_TERMCAP_md = "$(tput bold; tput setaf 6)"; # cyan
    LESS_TERMCAP_me = "$(tput sgr0)";
    LESS_TERMCAP_so = "$(tput bold; tput setaf 3; tput setab 4)"; # yellow on blue
    LESS_TERMCAP_se = "$(tput rmso; tput sgr0)";
    LESS_TERMCAP_us = "$(tput smul; tput bold; tput setaf 7)"; # white
    LESS_TERMCAP_ue = "$(tput rmul; tput sgr0)";
    LESS_TERMCAP_mr = "$(tput rev)";
    LESS_TERMCAP_mh = "$(tput dim)";
    LESS_TERMCAP_ZN = "$(tput ssubm)";
    LESS_TERMCAP_ZV = "$(tput rsubm)";
    LESS_TERMCAP_ZO = "$(tput ssupm)";
    LESS_TERMCAP_ZW = "$(tput rsupm)";
    GROFF_NO_SGR = "1"; # For Konsole and Gnome-terminal
  };

  nixpkgs.config.allowUnfree = true;

  home.packages = packages;
  # TODO: note said not to forget this
  #environment.pathsToLink = [ "/share/zsh" ];

  xdg = {
    enable = true;
    configFile = {
      # Symlink dotfiles until I get around to nixifying them
      #nvim = {
      #  source = ../../dotfiles/nvim;
      #  recursive = true;
      #};
      astronvim = {
        source = ../../dotfiles/astronvim;
        recursive = true;
      };
      bat = {
        source = ../../dotfiles/bat;
        recursive = true;
      };
      lsd = {
        source = ../../dotfiles/lsd;
        recursive = true;
      };
      ripgrep = {
        source = ../../dotfiles/ripgrep;
        recursive = true;
      };
      vivid = {
        source = ../../dotfiles/vivid;
        recursive = true;
      };
      starship = {
        source = ../../dotfiles/starship/starship.toml;
        target = "starship.toml";
      };
      zshfunctions = {
        source = ../../dotfiles/zsh/functions.zsh;
        target = "zsh/functions.zsh";
      };
      git = {
        source = ../../dotfiles/git;
        recursive = true;
      };
      tmuxp = {
        source = ../../dotfiles/tmuxp;
        recursive = true;
      };
    };
  };
}
