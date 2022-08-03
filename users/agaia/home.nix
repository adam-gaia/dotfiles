{ config, pkgs, ... }:

{

  programs = {

    # Let home manager install and enable itself
    home-manager.enable = true;

    vscode = {
      enable = true;
      extensions = with pkgs.vscode-extensions; [
      ];
    };
  };
 
   

  home.sessionVariables = {
    EDITOR = "nvim";
    PAGER = "LESS";
    LESS = "-RF --LONG-PROMPT --mouse --wheel-lines=5";
  };


  nixpkgs.config.allowUnfree = true;
  #nixpkgs.config.brave.commandLineArgs = "--enable-features=UseOzonePlatform --ozone-platform=wayland";

  home.packages = with pkgs; [
    docker-compose
    bat	
    rustc
    cargo
    neovim
    #make
    neomutt
    podman
    python3
    jq
    lynx
    m4
    neofetch
    tree
    w3m
    fzf
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
  ];
      

  # Symlink dotfiles until I get around to nixifying them
  xdg.configFile.nvim = {
    source = ./dotfiles/neovim;
    recursive = true;
  };  
  xdg.configFile.bat = {
    source = ./dotfiles/bat;
    recursive = true;
  };
  xdg.configFile.lsd = {
    source = ./dotfiles/lsd;
    recursive = true;
  };
  xdg.configFile.ripgrep = {
    source = ./dotfiles/ripgrep;
    recursive = true;
  };
  xdg.configFile.vivid = {
    source = ./dotfiles/vivid;
    recursive = true;
  };
  xdg.configFile.zsh = {
    source = ./dotfiles/zsh;
    recursive = true;
  };
  xdg.configFile.tmux = {
    source = ./dotfiles/tmux;
    recursive = true;
  };

}

