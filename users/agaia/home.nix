{ config, pkgs, ... }:

{
  programs.zsh = {
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
				export LS_COLORS="$(vivid generate monokai)" # TODO: we should only generate once when provisioning the machine and set to that output in here
		  fi

      # Install antibody (plugin manager)
      # curl -sfL git.io/antibody | sh -s - -b /usr/local/bin
      # Source antibody plugins
      # TODO: drop antibody and manage plugins manually
			source <(antibody init)
		  antibody bundle zsh-users/zsh-autosuggestions
		  antibody bundle zsh-users/zsh-syntax-highlighting
			antibody bundle zsh-users/zsh-completions
			antibody bundle olets/zsh-abbr # Expands aliases as abbrs instead


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


    loginExtra = "fortune | cowsay";
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
      cat = "bat";
    };
    
    

  };
 

 #[filter "lfs"]
#	clean = git-lfs clean -- %f
#	smudge = git-lfs smudge -- %f
#	process = git-lfs filter-process
#	required = true

#[color "grep"]
#	linenumber = green
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


  programs.git = {
    enable = true;
    lfs.enable = true;
    aliases = {
	url = "remote get-url origin";
	visual = "!gitk";
	root = "rev-parse --show-toplevel";
	# Use commitizen to commit
	cz = "!cz commit";
	batch = "!gitbatch";
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
	#TODO templateDir = /home/sarcos/repo/dotfiles/git/git-template-dir;
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

  programs.alacritty = {
    enable = true;
    settings = {
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

      use_thin_strokes = true;
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

      #key_bindings = {
       # - { key: N, mods: Control|Shift, action: SpawnNewInstance }
        # TODO: Because I set tmux as my login shell and then run zsh as a subshell,
        # creating a new window will not open the with working directory the same as the previous window
      # See https://github.com/alacritty/alacritty/issues/2155
      #};
    };
  };

  programs.fzf = {
    enable = true;
    # Fzf keybinds (ctrl-r history, ctrl-t file paths, alt-c cd to dir)	
    enableZshIntegration = true;
  };

  programs = {

    # Let home manager install and enable itself
    home-manager.enable = true;

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

      XDG_CONFIG_HOME = "/home/agaia/.config";
      XDG_CACHE_HOME = "/home/agaia/.cache";

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
    CYAN = "\\033[35m";
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

  home.packages = with pkgs; [
    docker-compose
    bat	
    rustc
    cargo
    neovim
    #make
    neomutt
    starship
    podman
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
    #didyoumean
    nodejs
  ];

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
      tmux = {
        source = ../../dotfiles/tmux;
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
    };
  };
}

