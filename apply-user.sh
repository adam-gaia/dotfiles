#!/usr/bin/env bash
set -e
nix build .#homeManagerConfigurations.agaia.activationPackage
./result/activate


## Install things not yet in Nixpkgs
# AstroNvim
NVIM_CONFIG_DIR=${XDG_CONFIG_HOME}/nvim
ASTRONVIM_VERSION="v1.8.0"
if [[ ! -d "${NVIM_CONFIG_DIR}" ]]; then
	mkdir -p "${NVIM_CONFIG_DIR}"
	git clone https://github.com/AstroNvim/AstroNvim "${NVIM_CONFIG_DIR}"
	pushd "${NVIM_CONFIG_DIR}"
	git checkout "${ASTRONVIM_VERSION}"
	popd
	nvim +PackerSync
fi


