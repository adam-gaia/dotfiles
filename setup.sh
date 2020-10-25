#!/usr/bin/env bash
# TODO: make this sh compatible instead of bash - oh jk maybe not. I like bash's 'set -Eeuo pipefail'
# TODO: make sure any sed commands are gnu and bsd sed compatible. Check other utilities that may differ
# TODO: Have input args for full install (graphical software) or small install (headless cli utilities only)
# TODO: need to output all brew caveats at the end. This could get ugly. See https://stackoverflow.com/questions/13333585/how-do-i-replay-the-caveats-section-from-a-homebrew-recipe
# TODO: credit https://github.com/MarioCatuogno/Clean-macOS/blob/master/bin/install.sh


# Safety settings
set -Eeuxo pipefail


# --------------------------------------------------
# Vars
# --------------------------------------------------
REPO="${HOME}/repo"
DOTFILEDIR="${HOME}/repo/dotfiles"
MANUALS="${HOME}/manuals"
THIRDPARTYCLONES="${HOME}/thirdPartyClones"
TMP="${HOME}/tmp"
MAC=0
LINUX=0


# --------------------------------------------------
# Functions
# --------------------------------------------------
function installPackages()
{
    local inputList="$1"
    shift
    local installCommand="$@"

    # Find list of packages to install
    listFile="${DOTFILEDIR}/packages/${inputList}"
    if [[ ! -f "${listFile}" ]]; then
        echo -e "\nError, package list '${listFile}' does not exist.\n"
        return 1
    fi

    # Read the file for a list of packages to install. Feed the list to the install command
    ${installCommand} $(cat "${listFile}" | grep -v '#')
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
        cloneDirName="${url##*/}" # extract basename from url
        if [[ ! -d "./${cloneDirName}" ]]; then
            git clone "${url}"
        fi
    done
}


# --------------------------------------------------
# Main
# --------------------------------------------------
# Keep sudo privileges alive while this script runs
printf "Enter root password...\n"
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Parse args
if [[ "$#" -eq '0' ]]; then
    # No arg provided, ask user for the new host name
    echo 'Please enter desired host name'
    read -t 100 newHostName
elif [[ "$#" -eq '1' ]]
    newHostName="$1"
else
    echo 'Error parsing args'
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
mkdir -p "${MANUALS}"


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



# If mac, install xcode first
if [[ "${MAC}" -eq '1' ]]; then
    xcode-select --install
fi


# Install brew regardless of OS
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
brew analytics off
brew -v
sudo chown -R $USER /usr/local/Cellar
brew doctor && brew update && brew upgrade
#export HOMEBREW_INSTALL_BADGE="☕️ 🐸" # TODO: Pick a good emoji

if [[ "${MAC}" -eq '1' ]]; then
    # Mac specific

    # TODO: save mac defaults before and after running this ('defaults' command)
    # Compare differences in case user wants to keep something they have set
    # TODO: gdb initial setup

    # Install packages and casks
    cd "${DOTFILEDIR}"
    brew install mas
    installPackages all.txt brew install
    
    mas upgrade
    


elif [[ "${LINUX}" -eq '1' ]]; then
    # Linux specific

    # TODO: Permissions will be a problem. Package manager will require
    #           sudo, but scripts in here a generate files for the regular user
    #           Maybe run an extra script in here with sudo privileges
    #           Or maybe a function is ok. See the second answer here:
    #           https://serverfault.com/questions/177699/how-can-i-execute-a-bash-function-with-sudo
    # TODO: we are going to have issues on Debian where 'sudo' isn't installed by default
    # TODO: better check linux distro to determine package manager. (Arch uses pacman, fedora uses yum(?))
    #sudo apt-get update
    #sudo apt-get -f install
    #sudo apt-get -y upgrade -y
    #sudo apt-get update --fix-missing
    #installPackages all.txt sudo apt-get install -y
    #installPackages linux.txt sudo apt-get install -y
    
    # Fuck it, I can use any package manager I want. TODO: simplify this script to only use brew
    installPackages all.txt brew install
    installPackages linux.txt brew install

fi

# Brew house keeping
brew -v update && brew -v upgrade && brew cask upgrade && brew -v cleanup --prune=5 && brew doctor

# Install pywal - TODO: make python pip packages install via text list + parsing function like the other packages
python3 -m pip install pywal

# Install via brewfile - TODO: pull out all the mas and cask packages
brew bundle --file="${DOTFILEDIR}/packages/Brewfile"

# Clone my other git repos
cloneRepos "${REPO}" 'myGitRepos.txt'

# Clone third party git repos
cloneRepos "${THIRDPARTYCLONES}" 'thirdPartyGitRepos.txt'

# Change default shell to homebrew installed bash
sudo echo "/usr/local/bin/bash" | sudo tee -a /etc/shells
chsh -s /usr/local/bin/bash # TODO: make sure linux homebrew installs to the same place

# Patch pywal by running my script - temporary until the pip pywal package is updated
"${REPO}/scripts/fix_pywal_cursor.sh"

# Install alfred prefrenecs # TODO: edit my git clone function to name a git clone dir
git clone https://github.com/adam-gaia/Alfred.git Alfred.alfredpreferences


# Create a manual for each builtin
