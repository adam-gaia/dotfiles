#!/usr/bin/env bash
# TODO: make this sh compatible instead of bash - oh jk maybe not. I like bash's 'set -Eeuo pipefail'
# TODO: make sure any sed commands are gnu and bsd sed compatible. Check other utilities that may differ
# TODO: Have input args for full install (graphical software) or small install (headless cli utilities only)

# Safety settings
set -Eeuxo pipefail

# --------------------------------------------------
# Vars
# --------------------------------------------------
REPO="${HOME}/repo"
DOTFILEDIR="${HOME}/repo/dotfiles"
THIRDPARTYCLONES="${HOME}/thirdPartyClones"
TMP="${HOME}/tmp"
MAC=0
LINUX=0


# --------------------------------------------------
# Functions
# --------------------------------------------------
function installPackages()
{
    local installCommand="$1"
    local inputList="$2"

    # Find list of packages to install
    listFile="${DOTFILEDIR}/packages/${inputList}"
    if [[ ! -f "${listFile}" ]]; then
        echo -e "\nError, package list '${listFile}' does not exist.\n"
        return 1
    fi

    # Read the file for a list of packages to install. Feed the list to the install command
    "${installCommand}" $(cat "${listFile}" | grep -v '#')
}

function cloneRepos()
{
    local parentDir="$1"
    local inputList="$2"

    # Find list of packages to install
    listFile="${DOTFILEDIR}/packages/${inputList}"
    if [[ ! -f "${listFile}" ]]; then
        echo -e "\nError, git url list '${listFile}' does not exist.\n"
        return 1
    fi

    # Move to where we want to clone the repos to
    mkdir -p "${parentDir}"
    cd "${parentDir}"

    # Clone each repo read in from the list
    for url in $(cat "${listFile}" | grep -v '#'); do
        git clone "${url}"
    done
}


# --------------------------------------------------
# Main
# --------------------------------------------------
if [[ "${EUID}" -eq '0' ]]; then
  echo 'Please run this as a user without sudo privileges.'
  exit 1
fi

# Determine OS
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
mkdir -p "${REPO}"
mkdir -p "${THIRDPARTYCLONES}"
mkdir -p "${TMP}"


# Clone my dotfile and setup repo
if [[ ! -d "${DOTFILEDIR}" ]]; then
    cd "${REPO}"
    git clone https://github.com/adam-gaia/dotfiles.git
else
    cd "${DOTFILEDIR}"
    git stash
    git fetch
    git checkout master
    git pull
fi

# Link my dotfiles
cd "${DOTFILEDIR}"
./deploy.sh

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

    # Install packages and casks
    cd "${DOTFILEDIR}"
    installPackages 'brew install' 'all.txt'
    installPackages 'brew install' 'mac.txt'
    installPackages 'brew cask install' 'brewcask.txt'

elif [[ "${LINUX}" -eq '1' ]]; then
    # Linux specific

    # TODO: Permissions will be a problem. Package manager will require
    #           sudo, but scripts in here a generate files for the regular user
    #           Maybe run an extra script in here with sudo privileges
    #           Or maybe a function is ok. See the second answer here:
    #           https://serverfault.com/questions/177699/how-can-i-execute-a-bash-function-with-sudo
    # TODO: we are going to have issues on Debian where 'sudo' isn't installed by default
    # TODO: better check linux distro to determine package manager. (Arch uses pacman, fedora uses yum(?))
    sudo apt-get update
    sudo apt-get -f install
    sudo apt-get -y upgrade -y
    sudo apt-get update --fix-missing
    installPackages 'sudo apt-get install -y' 'all.txt'
    installPackages 'sudo apt-get install -y' 'linux.txt'

fi


# Clone my other git repos
cloneRepos "${REPO}" 'myGitRepos.txt'

# Clone third party git repos
cloneRepos "${THIRDPARTYCLONES}" 'thirdPartyClones.txt'


