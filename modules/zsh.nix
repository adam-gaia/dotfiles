{pkgs, ...}: {
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

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git" # git aliases
        "docker" # docker aliases
        "git-auto-fetch"
        "mosh" # use ssh completion for mosh
        "vagrant" # vagrant aliases
      ];
    };

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
      # Start tmux with first terminal
      # --------------------------------------------------
      # Start tmux on the first terminal, but only in a graphical session
      # There is no good reason to skip starting tmux in a non-graphical session, I'm just worried that a bug in my zshrc
      # could prevent me from loggin in during an emergency
      if [[ -z ''${DISPLAY+unset} ]]; then
        # Check if we are running an interactive session and not already in tmux (or screen)
        if command -v tmux &> /dev/null && [[ -n "$PS1" ]] && [[ ! "$TERM" =~ screen\|tmux ]] && [[ -z "$TMUX" ]]; then
          exec tmux
        fi

        # Tmux sets $SHLVL somehow.
        # Tricks like 'exec env SHLVL=0 tmux' (from https://stackoverflow.com/a/22869763) do not work
        # To get around this, check if we are the first shell (spawned by tmux) and set SHLVL manually
        if [[ -z ''${FIX_SHLVL+unset} ]]; then
          echo "fixing shlvl" >> ~/.zsh.log
          export FIX_SHLVL=1
          export SHLVL=1
        fi
      fi



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

      # Push the previous directory onto the stack when using cd
      setopt AUTO_PUSHD

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

      setopt HIST_SAVE_NO_DUPS       # Do not save duplicated command
      setopt HIST_REDUCE_BLANKS      # Remove unnecessary blanks
      setopt INC_APPEND_HISTORY_TIME # Append command to history file immediately after execution

      # Disable 'r' builtin. I have an exec that is also called 'r'
      disable r

      # --------------------------------------------------
      # Alias listing plugin
      # --------------------------------------------------
      if command -v format-aliases &>/dev/null; then
        eval "$(format-aliases init zsh)"
      fi

      # --------------------------------------------------
      # Plugin Overrides
      # --------------------------------------------------
      GIT_AUTO_FETCH_INTERVAL=3600 # 1 hour in seconds

      # Stop forgit from creating aliases. We create our own later
      # (https://github.com/wfxr/forgit#shell-aliases)
      FORGIT_NO_ALIASES=1
    '';

    initExtra = ''
      source ''${XDG_CONFIG_HOME}/zsh/functions.zsh

      # --------------------------------------------------------------------------------
      # Starship prompt
      # --------------------------------------------------------------------------------
      if command -v starship &>/dev/null; then
        eval "$(starship init zsh)"
      fi
    '';

    loginExtra = "";
    logoutExtra = "[ $SHLVL = 1 ] && [ -x /usr/bin/clear_console ] && /usr/bin/clear_console -q || clear";

    shellAliases = {
      reload = "exec zsh";
      mail = "neomutt";
      wiki = "nvim +VimwikiIndex";

      # Zsh's 'history' builtin only shows 16 items. This alias shows all history
      history = "fc -l 1";

      grep = "grep --color=always";
      fd = "fd --color=always";
      ls = "ind -- lsd -alh --color=always";

      vim = "nvim";
      vi = "vim";
      emacs = "vim"; # lol

      # cd with ease
      ".." = "cd ..";
      "..2" = "cd ../..";
      "..3" = "cd ../../..";
      "..4" = "cd ../../../..";
      "..5" = "cd ../../../../..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      "....." = "cd ../../../..";
      "......" = "cd ../../../../..";

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
      compose = "docker compose";

      iga = "git forgit add";
      igbl = "git forgit blame";
      igcb = "git forgit checkout_branch";
      igbd = "git forgit branch_delete";
      igcc = "git forgit checkout_commit";
      igcf = "git forgit checkout_file";
      igct = "git forgit checkout_tag";
      igcp = "git forgit cherry_pick";
      igcpb = "git forgit cherry_pick_from_branch";
      igclean = "git forgit clean";
      igd = "git forgit diff";
      igfix = "git forgit fixup";
      igignore = "git forgit ignore";
      iglog = "git forgit log";
      igrebase = "git forgit rebase";
      igreset = "git forgit reset_head";
      igrevert = "git forgit revert_commit";
      igstashshow = "git forgit stash_show";
      igstash = "git forgit stash_push";

      dps = "docker ps";
      dpsa = "docker ps --all";

      # Let 'cat' invoke bat with only syntax highlighting.
      # I'll get in the habit of running 'bat' when I want a pager
      cat = "bat --plain --pager=never";
    };
  };
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    options = ["--cmd" "j"]; # Use 'j' to jump instead of 'z'
  };
}
