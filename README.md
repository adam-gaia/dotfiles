# Dotfiles

## Unlock git crypt

```bash
# Save git crypt key in a file outside of the repo
KEY_FILE="~/repo/personal/git-crypt-private-key.key"
git-crypt unlock "${KEY_FILE}"
```

## Setup taskwarrior repo

```bash
KEY_FILE="${HOME}/repo/git-crypt-taskwarrior-data-key.key"

XDG_DATA_HOME="${HOME}/.local/share"
mkdir -p "${XDG_DATA_HOME}"
DATA_DIR="${XDG_DATA_HOME}/task"
git clone https://github.com/adam-gaia/taskwarrior-data.git "${DATA_DIR}"

pushd "${DATA_DIR}"
git-crypt unlock "${KEY_FILE}"
popd
```

## apply-system script

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

# Enable flakes and other nix confit settings
NIX_CONFIG_FILE="${HOME}/.config/nix.conf"
mkdir -p $(dirname "${NIX_CONFIG_FILE}")
touch "${NIX_CONFIG_FILE}"
echo "experimental-features = nix-command flakes" >> "${NIX_CONFIG_FILE}"
echo "keep-derivations = true" >> "${NIX_CONFIG_FILE}" # for dir-env later
echo "keep-outputs = true" >> "${NIX_CONFIG_FILE}" # for dir-env later


## Install nix-darwin
mkdir -p ~/tmp
pushd ~/tmp

nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A installer
./result/bin/darwin-installer

# The install script will ask for manual input
# I said no to editing the default bashrc
# I said yes to the second option, but I'm not really sure what that did

# Make sure it worked - this also bootstraps nix-darwin which is needed before we can use a nix-darwin flake
darwin-rebuild switch

popd


```

## Homelab

### Load balencing via

I picked my vip arbitraily. TODO: make sure this isn't in router's DHCP
`VIP=192.168.1.227`
K3s needs this value on startup (see references for explination)

```
# server.nix
extraFlags = "--tls-san ${VIP} ..."
```

- Set up the first node

```bash
deploy .#rpi01
ssh rpi01
```

TODO: Add a note here about grabbing the first node's key?
The first node is all we need to start running services on our "cluster".
Thus we can add the load balencer, kube-vip, manifests and have the first node pick it up.
Once more nodes are added the kubernetes will do its thing and propigate.
TODO: nix/terraform/ansible these steps

```bash
# Grab the first manifest
sudo mkdir -p /var/lib/rancher/k3s/server/manifests
curl -s https://kube-vip.io/manifests/rbac.yaml > /var/lib/rancher/k3s/server/manifests/kube-vip-rbac.yaml
export INTERFACE=end0 # ethernet interface from `ip a`
export KV_VERSION=v0.5.8
# Also export VIP from earlier
alias kube-vip="docker run --network host --rm ghcr.io/kube-vip/kube-vip:$KVVERSION"

# Running kube-vip in a docker container (with these specific flags) will generate the other manfest
kube-vip manifest daemonset \
                  --interface $INTERFACE \
                  --address $VIP \
                  --taint \
                  --controlplane \
                  --services \
                  --arp \
                  --leaderElection \
                  --inCluster | sudo tee /var/lib/rancher/k3s/server/manifests/kube-vip.yaml

ping $VIP # Validation
```

- Set up other nodes

```bash
deploy .#rpi02
deploy .#rpi03
deploy .#rpi04
```

- Update kubectl settings
  Edit `~/.kube/config` and set the cluster's server address to the VIP

```
  server: https://<VIP>:6443
```

- More setup. TODO: better document

### Refrences

- https://kube-vip.io/docs/installation/daemonset/
- https://devopstales.github.io/kubernetes/k3s-etcd-kube-vip/
- https://github.com/ebrianne/k3s-at-home/blob/master/docs/theeasyway.md

## Credits

Some code and ideas were ~~stolen~~ borrowed from [Kennan LeJeune's system config](https://github.com/kclejeune/system), which I stumbled uppon
while looking for way to merge NixOS and Darwin configs into the same flake. Note `LICENSE.md` (MIT) which attributes the original license of code I've copied.
