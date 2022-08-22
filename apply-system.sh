#!/usr/bin/env bash
set -e

if [[ "${EUID}" -ne 0 ]]; then
	echo 'This script must be ran as root (use sudo).'
        exit 1
fi

sudo nixos-rebuild switch --flake .#

systemctl -t service --state=running --no-legend --no-pager | grep -E --color=never 'podman|docker'

