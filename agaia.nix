{
  config,
  pkgs,
  fortune-quotes,
  homePrefix,
  inputs,
  nixpkgs,
  system,
  term,
  nur,
  ...
}: let
  username = "agaia";
  homeDir = "${homePrefix system}/${username}";

  nur-no-pkgs = import nur {
    inherit pkgs; # well I had to add a pkgs so its not nur-no-pkgs anymore. I guess it makes sense why I had to add that, since my nur repo takes pkgs an input, but why do all examples use no pkgs?
    nurpkgs = import nixpkgs {inherit system;};
  };
in {
  home-manager.useGlobalPkgs = true;

  nixpkgs = {
    config = {
      allowBroken = false;
      allowUnfree = true;

      packageOverrides = pkgs: {
        nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
          inherit pkgs;
        };
      };
    };
  };

  home-manager.users.agaia = {
    imports = [
      ./modules/neovim.nix
      ./modules/alacritty.nix
      ./modules/foot.nix
      ./modules/bat.nix
      ./modules/direnv.nix
      ./modules/tmux.nix
      ./modules/git.nix
      ./modules/neomutt.nix
      ./modules/fzf.nix
      #./modules/vscode.nix  # TODO: reenable - only works on linux
      ./modules/zsh.nix
      ./modules/zoxide.nix
      ./modules/starship.nix
      ./modules/nushell.nix
      ./modules/atuin.nix
      ./modules/taskwarrior.nix
      ./modules/ssh.nix
      ./modules/gtk.nix
      ./modules/less.nix
      ./modules/systemd-user-services.nix
      ./modules/proton-packages.nix
      #./modules/conda-flake.nix
      # ./modules/git-track-repos.nix
      #./modules/ind.nix
      #./modules/ide.nix
      #./modules/cbtr.nix
      #./modules/shim.nix
      #./modules/new-stow.nix
      ./modules/firefox.nix
      ./modules/chromium.nix
      #./modules/dconf.nix
      ./modules/ansible.nix
      #./modules/rofi.nix TODO
      ./modules/navi.nix
      #./modules/text-art.nix
      #./modules/format-aliases.nix
      ./modules/newsboat.nix
    ];

    accounts.email = {
      maildirBasePath = "/${homeDir}/mailbox";
      accounts = with import ./modules/email/main.nix {}; {
        "main" = main;
      };
    };

    home = {
      stateVersion = "23.05"; # TODO: make a variable to follow system state version

      sessionPath = [
        "$HOME/.local/bin"
      ];

      sessionVariables = {
        #NIX_PATH = "nixpkgs=${nixpkgs}:stable=${stable}\${NIX_PATH:+:}$NIX_PATH";
        NIX_PATH = "nixpkgs=${nixpkgs}";

        GIT_DISCOVERY_ACROSS_FILESYSTEM = "1";
        PRE_COMMIT_ALLOW_NO_CONFIG = "1"; # TODO: can we configure pre-commit with a config instead of setting this?

        # Tell firefox to use wayland features
        MOZ_ENABLE_WAYLAND = 1;

        EDITOR = "vim";
        PAGER = "less";
        LESS = "-RF --LONG-PROMPT --mouse --wheel-lines=5";
        RUSTC_WRAPPER = "sccache";
        RIPGREP_CONFIG_PATH = "${homeDir}/.config/ripgrep/config";
        PYTHONSTARTUP = "${homeDir}/python/pythonrc.py";

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

      packages = with pkgs; [
        python3
        jq
        lynx
        m4
        neofetch
        tree
        w3m
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
        #lsd # Replaced by my build from git main source while we wait for the 1.0.0 release
        cowsay
        gdb
        gzip
        watch
        htop
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
        #ansible # Unable to compile a dependency of ansible on mac, which is under python 3.10
        commitizen
        pre-commit
        xxh
        sumneko-lua-language-server
        htmlq
        nixpkgs-fmt
        nixfmt # TODO: which nix formatter should I use?
        alejandra # Another nix formatter - I think I like this one
        treefmt
        shellcheck
        onefetch
        tealdeer
        ctop
        stylua
        ranger # TUI file navigator
        tasksh # Repl for taskwarrior
        sccache # Rust compiler cache
        lazydocker
        lazygit
        lnav # Log viewer
        trash-cli
        zsh-forgit
        dig # also contains nslookup
        traceroute
        tcpdump
        netcat-gnu
        comma # automatically run 'nix-shell -p <program>' with `, <program>`
        fortune-quotes.defaultPackage.${system}
        git-annex
        #obsidian
        nurl # Generate Nix fetcher calls from repo urls
        ripgrep-all # Use ripgrep on PDFs, zip files, Office docs, etc
        procs # ps replacement

        nur-no-pkgs.repos.agaia.rusty-rain
        nur-no-pkgs.repos.agaia.shinydir
        nur-no-pkgs.repos.agaia.lsd-git
        nur-no-pkgs.repos.agaia.ind
        nur-no-pkgs.repos.agaia.cbtr
        nur-no-pkgs.repos.agaia.git-track-repos
        nur-no-pkgs.repos.agaia.shim
        nur-no-pkgs.repos.agaia.new-stow
        nur-no-pkgs.repos.agaia.ide
      ];
    };

    xdg = {
      enable = true;
      configFile = {
        # Symlink dotfiles until I get around to nixifying them
        astronvim = {
          source = ./dotfiles/astronvim;
          recursive = true;
        };

        nvim = {
          # "clone" astronvim repo into ~/.config/nvim
          source = pkgs.fetchFromGitHub {
            owner = "AstroNvim";
            repo = "AstroNvim";
            rev = "v3.36.2";
            sha256 = "sha256-0mV11UNP6iOF5p3VFetUcbZvcTgrf7hEXbzbaR4OlMM=";
          };
          recursive = true;
        };

        sway = {
          source = ./dotfiles/sway;
          recursive = true;
        };
        cbtr = {
          source = ./dotfiles/cbtr;
          recursive = true;
        };
        lsd = {
          source = ./dotfiles/lsd;
          recursive = true;
        };
        ripgrep = {
          source = ./dotfiles/ripgrep;
          recursive = true;
        };
        vivid = {
          source = ./dotfiles/vivid;
          recursive = true;
        };
        starship = {
          source = ./dotfiles/starship/starship.toml;
          target = "starship.toml";
        };
        zshfunctions = {
          source = ./dotfiles/zsh/functions.zsh;
          target = "zsh/functions.zsh";
        };
        git = {
          source = ./dotfiles/git;
          recursive = true;
        };
        pre-commit = {
          source = ./dotfiles/pre-commit;
          recursive = true;
        };
        tmuxp = {
          source = ./dotfiles/tmuxp;
          recursive = true;
        };
        shim = {
          source = ./dotfiles/shim;
          recursive = true;
        };
        #offlineimap = {
        #  source = ./dotfiles/offlineimap;
        #  recursive = true;
        #};
        #neomutt = {
        #  source = ./dotfiles/neomutt;
        #  recursive = true;
        #};
        "nixpkgs/config.nix" = {
          source = ./modules/nix-config.nix;
        };
      };
      userDirs = {
        enable = true;
        createDirectories = true;
        extraConfig = {
          XDG_CONFIG_HOME = "${homeDir}/.config";
          XDG_CACHE_HOME = "${homeDir}/.cache";
        };
      };
    };

    #environment.pathsToLink = ["/share/zsh"]; # TODO: figure out where this goes

    programs = {
      home-manager = {
        enable = true; # Allow home-manager to manage itself
      };
      command-not-found.enable = true;
      htop.enable = true;
      jq.enable = true;
      man.enable = true;
      #gl = {
      #  enable = true;
      #};
    };
  };
}
