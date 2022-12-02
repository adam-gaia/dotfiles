{config, pkgs, lib, ...}:
{
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

  programs.git = {
    enable = true;
    lfs.enable = true;

    # Aliases moved to 'shim' utility
    #aliases = {
    #  url = "remote get-url origin";
    #  visual = "!gitk";
    #  root = "rev-parse --show-toplevel";
    #  batch = "!gitbatch";
    #  repos = "track-repos"; # Shortcut for my git-track-repos command. https://gitlab.com/adam_gaia/git-track-repos
    #};
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

      # Ignore other keys
      "*.key"

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
}
