#!/usr/bin/env bash

# Sudo check
if [[ $EUID -ne 0 ]]; then
  echo "You must have root privileges to run this script. Please try again with sudo"
  exit 1
fi

mkdir -p "${HOME}/tmp"





# Others - TODO: sort separate mac only. Put linux + mac compatible in a shared file
# TODO: sort by essential to non essential. Have this script take a flag to only install essentials







# Deploy dotfiles
./deploy.sh

