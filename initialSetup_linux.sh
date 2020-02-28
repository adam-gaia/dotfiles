#!/usr/bin/env bash

# Sudo check
if [[ $EUID -ne 0 ]]; then
  echo "You must have root privileges to run this script. Please try again with sudo"
  exit 1
fi

sudo apt-get update
sudo apt-get -f install
sudo apt-get -y upgrade -y
sudo apt-get update --fix-missing
sudo apt-get install -y \
             git \
             bash \
             gpatch \
             less \
             m4 \
             make \
             nano \
             vim \
             gcc \
             gdb



# Others - TODO: sort separate mac only. Put linux + mac compatible in a shared file
# TODO: sort by essential to non essential. Have this script take a flag to only install essentials
sudo apt-get install -y \
             tmux \
             qt \
             navi \
             tree \
             yabai \
             w3m \
             cowsay \
             fortune \
             blueutil \
             cppman \
             jq \
             lynx \
             neofetch \
             pipes-sh \
             source-highlight \
             watch \
             xmlstarlet \
             imagemagick



# Deploy dotfiles
./deploy.sh


