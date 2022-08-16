# NixOS Setup
Instructions stolen from https://mt-caret.github.io/blog/posts/2020-06-29-optin-state.html

## Inital setup

### Find disk to partition
```bash
lsblk
```

### Setup
```bash
sudo ./setup.sh --git git@agaia.dev 'Adam Gaia' <disk>
```


### Modify Hardware Config
Sudo edit `/mnt/etc/nixos/hardware-configuration.nix`
* Modify all mount options to include `"compress=zstd" "noatime"`
`options = [ "subvol=root" ];` should become `options = [ "subvol=root" "compress=zstd" "noatime" ];`

* Fix boot order with `/var/log` by adding `neededForBoot = true;`


### Install
```bash
sudo nixos-install
# This will propmpt to set the root password
```

### Reboot
```bash
sudo reboot
```


## Post-reboot

### Mount
```bash
sudo mkdir /mnt
sudo mount -o subvol=/ /dev/mapper/enc /mnt
# TODO if we change '/dev/mapper/enc' in 'setup.sh' make sure to change here too
```


### Swap in updated config
```bash
sudo cp ./second-configuration.nix /etc/nixos/configuration.nix
```

### Rebuild
```bash
sudo nixos-rebuild boot

sudo mkdir -p /persist/etc/NetworkManager
sudo cp -r {,/persist}/etc/NetworkManager/system-connections
sudo mkdir -p /persist/var/lib/NetworkManager
sudo cp -r /var/lib/NetworkManager/{secret_key,seen-bssids,timestamps} /persist/var/lib/NetworkManager/

sudo cp -r {,/persist}/etc/nixos
sudo cp -r {,/persist}/etc/adjtime
sudo cp -r {,/persist}/etc/NIXOS
```

### Reboot
```bash
sudo reboot
```


## Setup Docker persist
### Install docker
```bash
sudo cp ./third-configuration.nix /etc/nixos/configuration.nix
sudo nixos-rebuild-switch
```

### Rebuild with docker and setup persist links
```bash
sudo cp ./configuration.nix /etc/nixos/configuration.nix
sudo nixos-rebuild switch
sudo mkdir -p /persist/var/lib/

sudo systemctl stop docker
sudo cp -r {,/persist}/var/lib/docker

sudo nixos-rebuild boot
```

### Reboot
```bash
sudo reboot
```


