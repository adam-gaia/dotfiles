#!/usr/bin/env bash
set -Eeuo pipefail

THIS_PROGRAM_NAME="$(basename "$0")"

function print_help_message()
{
  echo "Usage:"
  echo "    ${THIS_PROGRAM_NAME} <system|user>"
}

if [[ "$#" -eq 0 ]]; then
  echo "Input arg template required"
  print_help_message
  exit 2
fi

while [[ "$#" -gt 0 ]]; do
  arg="$1"
  case "${arg}" in
  '--help' | '-h')
    print_help_message
    exit 0
    ;;

    'user')
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
      ;;

    'system')
      sudo nixos-rebuild switch --flake .#
      systemctl -t service --state=running --no-legend --no-pager | grep -E --color=never 'podman|docker'
      ;;

    *)
      echo "${THIS_PROGRAM_NAME} error: unknown arg '${arg}'"
      exit 2
    ;;
  esac
  shift # Move to next arg
done
