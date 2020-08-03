#!/usr/bin/env bash

# --------------------------------------------------
# Functions
# --------------------------------------------------
function installPackages()
{
    INSTALL_COMMAND="${1}"

}

# --------------------------------------------------
# Main
# --------------------------------------------------
unameOut="$(uname -s)"
case "${unameOut}" in

    Darwin*)
        export DOTFILEDIR='/Users/${USER}/repo/dotfiles'
        INSTALL_COMMAND='brew install'


        ;;

    Linux*)
        export DOTFILEDIR='/home/${USER}/repo/dotfiles'
        INSTALL_COMMAND='sudo apt-get install -y'


        ;;

    *)
        echo "Unknown OS type, '${unameOut}' defaulting to Linux setup"


        ;;

esac

# apt
sudo apt-get update
sudo apt-get -f install
sudo apt-get -y upgrade -y
sudo apt-get update --fix-missing

# brew
brew update
brew analytics off
#export HOMEBREW_INSTALL_BADGE="☕️ 🐸"






REPO="${HOME}/repo"


# Set up directory structure
mkdir -p "${repo}"
mkdir -p "${HOME}/tmp"


git clone 





# Install brew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"


/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
brew update
brew analytics off


