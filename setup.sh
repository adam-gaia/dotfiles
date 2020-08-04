#!/usr/bin/env bash
# TODO: make this sh compatible instead of bash
# TODO: make sure any sed commands are gnu and bsd sed compatible. Check other utilities that may differ
# TODO: Have input args for full install (graphical software) or small install (headless cli utilities only)

# --------------------------------------------------
# Functions
# --------------------------------------------------
function cdThrowError()
{
    inputDir="$1"
    cd "${inputDir}" || { echo "Error cd'ing to '${inputDir}'"; exit 1; }
}


# --------------------------------------------------
# Main
# --------------------------------------------------
if [[ "${EUID}" -eq '1' ]]; then
  echo 'Please run this as a user without sudo privileges.'
  exit 1
fi


unameOut="$(uname -s)"
case "${unameOut}" in

    Darwin*)
        MAC=1
        ;;

    Linux*)
        LINUX=1
        ;;

    *)
        echo "Unknown OS type, '${unameOut}' defaulting to Debian-based Linux setup"
        LINUX=1
        ;;

    # TODO: check for raspberry pi. Do a lighter install

esac


# Set up directory structure
REPO="${HOME}/repo"
mkdir -p "${REPO}"
DOTFILEDIR='${HOME}/repo/dotfiles'
mkdir -p "${DOTFILEDIR}"
mkdir -p "${HOME}/tmp"


# Install brew regardless of OS
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
brew update
brew analytics off
#export HOMEBREW_INSTALL_BADGE="☕️ 🐸" # TODO: Pick a good emoji


if [[ "${MAC}" -eq '1' ]]; then
    # Mac specific

    # TODO: save mac defaults before and after running this ('defaults' command)
    # Compare differences in case user wants to keep something they have set
    # TODO: gdb initial setup

    # Brew packages
    brew install ${packages}

    # Brew cask
    brew cask install ${packages}


elif [[ "${LINUX}" -eq '1' ]]; then
    # Linux specific

    # TODO: Permissions will be a problem. Package manager will require
    #           sudo, but scripts in here a generate files for the regular user
    #           Maybe run an extra script in here with sudo privileges
    # TODO: we are going to have issues on Debian where 'sudo' isn't installed by default
    # TODO: better check linux distro to determine package manager. (Arch uses pacman, fedora uses yum(?))
    sudo apt-get update
    sudo apt-get -f install
    sudo apt-get -y upgrade -y
    sudo apt-get update --fix-missing

fi



# Clone my dotfile repo, then link my dot files
cdThrowError "${REPO}"
git clone 
./deploy.sh


# Clone my other repos


