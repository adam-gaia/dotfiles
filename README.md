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
