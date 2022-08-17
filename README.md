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

