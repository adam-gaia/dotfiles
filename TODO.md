# TODO

## General

- [ ] Make nixos config modular
- [ ] Enable [Clair](https://github.com/quay/clair) in locally hosted [reg](https://github.com/genuinetools/reg) server for static analysis

## Homer Browser landing page

- [ ] Find a way to swap out the background periodically. Maybe fork it
- [ ] Make icons
- [ ] Bring config into this repo instead of external repo

## Local docker registry

- [ ] Mark registry as insecure via nix config in `/etc/containers/registeries.conf`
  - [ ] Mark in docker's settings `/etc/docker/daemon.json`
  * Or get a cert
- [ ] Enable my local registry as a pull-through cache
  - for docker
  - and podman

## Create a nix package for

- [ ] [Homer](https://github.com/bastienwirtz/homer)

## Create a nix home-manager thing for

- [ ] [Vivid](https://github.com/sharkdp/vivid)
  - I think I can look at the [bat entry](https://github.com/nix-community/home-manager/blob/master/modules/programs/bat.nix) as an example
