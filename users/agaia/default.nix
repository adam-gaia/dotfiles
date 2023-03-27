{ self
, inputs
, config
, pkgs
, system
, nixpkgs
, nixpkgs-unstable
, term
, ...
}:
let
  homeDir = config.home.homeDirectory;
in
{
  imports = [
    ../../modules/neovim.nix
    ../../modules/alacritty.nix
    ../../modules/bat.nix
    ../../modules/direnv.nix
    ../../modules/tmux.nix
    ../../modules/git.nix
    ../../modules/neomutt.nix
    ../../modules/fzf.nix
    #../../modules/vscode.nix  # TODO: reenable - only works on linux
    ../../modules/zsh.nix
    ../../modules/taskwarrior.nix
    ../../modules/ssh.nix
  ];

  accounts.email = {
    maildirBasePath = "/${homeDir}/mailbox";
    accounts = with import ../../modules/email/main.nix { }; {
      "main" = main;
    };
  };

  home = {
    sessionVariables = {
      GIT_DISCOVERY_ACROSS_FILESYSTEM = "1";
      PRE_COMMIT_ALLOW_NO_CONFIG = "1"; # TODO: can we configure pre-commit with a config instead of setting this?

      XDG_CONFIG_HOME = "${homeDir}/.config";
      XDG_CACHE_HOME = "${homeDir}/.cache";

      # Tell firefox to use wayland features
      MOZ_ENABLE_WAYLAND = 1;

      EDITOR = "vim";
      PAGER = "less";
      LESS = "-RF --LONG-PROMPT --mouse --wheel-lines=5";
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
      docker-compose
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
      lsd
      cowsay
      fortune
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
      navi
      sumneko-lua-language-server
      htmlq
      nixpkgs-fmt
      nixfmt # TODO: which nix formatter should I use?
      alejandra # Another nix formatter - I think I like this one
      treefmt
      shellcheck
      glab
      onefetch
      tealdeer
      starship
      ctop
      ranger # TUI file navigator
      tasksh # Repl for taskwarrior
    ];
  };

  xdg = {
    enable = true;
    configFile = {
      # Symlink dotfiles until I get around to nixifying them
      astronvim = {
        source = ../../dotfiles/astronvim;
        recursive = true;
      };
      sway = {
        source = ../../dotfiles/sway;
        recursive = true;
      };
      cbtr = {
        source = ../../dotfiles/cbtr;
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
      pre-commit = {
        source = ../../dotfiles/pre-commit;
        recursive = true;
      };
      tmuxp = {
        source = ../../dotfiles/tmuxp;
        recursive = true;
      };
      shim = {
        source = ../../dotfiles/shim;
        recursive = true;
      };
      #offlineimap = {
      #  source = ../../dotfiles/offlineimap;
      #  recursive = true;
      #};
      #neomutt = {
      #  source = ../../dotfiles/neomutt;
      #  recursive = true;
      #};
    };
  };

  #environment.pathsToLink = ["/share/zsh"]; # TODO: figure out where this goes

  programs = {
    command-not-found.enable = true;
    htop.enable = true;
    jq.enable = true;
    man.enable = true;
    #gl = {
    #  enable = true;
    #};
  };
}
