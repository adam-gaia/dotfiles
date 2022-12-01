# Dotfiles

## Unlock git crypt

```bash
# Save git crypt key in a file outside of the repo
KEY_FILE="~/repo/personal/git-crypt-private-key.key"
git-crypt unlock "${KEY_FILE}"
```

## Usage

```bash
# Apply system configuration
./apply-system.sh


# Apply user configuration
./apply-user.sh && reload

```

### Install (astro)nvim lsp servers

```vim
:LspInstall pyright
:LspInstall clangd
:LspInstall cmake
:LspInstall dockerls
:LspInstall rust-analyzer
:LspInstall terraform-ls
:LspInstall bash-language-server
:LspInstall yaml-language-server
:LspInstall ansiblels
:LspInstall ltex # LaTeX and markdown
```

## Todo

- Automate astronvim install
  - Must be manually installed
  - Instructions here: https://github.com/AstroNvim/AstroNvim

## Troubleshooting

- Keymap changes weren't getting picked up on 'nixos-rebuild switch'
  Needed to run

```bash
gsettings reset org.gnome.desktop.input-sources xkb-options
gsettings reset org.gnome.desktop.input-sources sources
```

and logout+login

## Notes

- dconf2nix (gnome settings)
  - https://github.com/gvolpe/dconf2nix

### MacOS

Hit some issues installing nix on mac

```bash
## Install Nix
# Nix installer would fail because /nix/store DNE so make that first
sudo mkdir -p /nix/store

# Install Nix as per instructions on [](nixos.org/download.html#nix-install-macos)
sh <(curl -L https://nixos.org/nix/install)
# The install script will ask for some manual input

# After installing nix profiles and channels were messed up
# The error message (from running nix-shell -p <anything>) was something along the lines of 'nix <nixpkgs> was not found in the nix search path'
# This is because the installed bash/zshrc was not setting env var NIX_PATH or adding any channels
nix-channel --add "https://nixos.org/channels/nixos-unstable" unstable # Note this is the unstable repo, not a set version
nix-channel --update

# And the same for root user
sudo -i nix-channel --add "https://nixos.org/channels/nixos-unstable" unstable # Note this is the unstable repo, not a set version
sudo -i nix-channel --update

export NIX_PATH="${HOME}/.nix-defexpr/channels:nixpkgs=${HOME}/.nix-defexpr/channels/unstable" # Again, unstable repo

# Check that everything worked (from nix manual's validation notes)
nix-shell -p nix-info --run "nix-info -m"
# And same for root again
sudo -i nix-shell -p nix-info --run "nix-info -m"

# TODO: set NIX_PATH in bash/zshrc


## Install nix-darwin
mkdir -p ~/tmp
pushd ~/tmp

nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A installer
./result/bin/darwin-installer

# The install script will ask for manual input
# I said no to editing the default bashrc
# I said yes to the second option, but I'm not really sure what that did

# Make sure it worked
darwin-rebuild switch

popd

```
