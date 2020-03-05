#!/usr/bin/env bash
# TODO: determine scope. Where does the initial setup script end and this begin?
set -Eeuo pipefail


# TODO: Turn this into a makefile?

# --------------------------------------------------
# Functions
# --------------------------------------------------
deploy()
{
    sourceFile="$1"
    linkTarget="$2"

    # Check if target already exists
    if [[ -f "${linkTarget}" ]]; then

        # Check if target is a link
        if [[ -L "${linkTarget}" ]]; then

            # If the link points to $sourceFile we don't need to do any work
            if [[ readlink -f "${linkTarget}" == "${sourceFile}" ]]; then
                echo "${linkTarget} is linked to ${sourceFile}"
                return
            fi

            # Else, we need to back up by copying whatever the link points to and remove the link itself
            timeStamp="$(date "+%Y-%m-%d_%H:%M:%S")"
            backup="$(readlink -f "${linkTarget}")_backup_${timeStamp}"
            echo "Backed up '${linkTarget}' to '${backup}'"
            rm "${linkTarget}"
        
        else

            # Otherwise, we need to back up by moving the target file
            timeStamp="$(date "+%Y-%m-%d_%H:%M:%S")"
            backup="${linkTarget}_backup_${timeStamp}"
            mv "${linkTarget}" "${backup}"
            echo "Backed up '${linkTarget}' to '${backup}'"

        fi
    fi

    # Make a link to our sourcefile
    ln -s "${sourceFile}" "${linkTarget}" || { echo "Error linking '${sourceFile}' to '${linkTarget}'"; exit 1; }
    echo "Linked '${sourceFile}' to '${linkTarget}'"
}

# --------------------------------------------------
# Main
# --------------------------------------------------
DOTFILEDIR="$(pwd)"

# Bash
deploy "${DOTFILEDIR}/bash/bashrc" "${HOME}/.bashrc"
deploy "${DOTFILEDIR}/bash/bash_profile" "${HOME}/.bash_profile"

# Vim
mkdir -p "${HOME}/tmp/vim-backup"
mkdir -p "${HOME}/tmp/vim-backup"
mkdir -p "${HOME}/tmp/vim-backup"

deploy "${DOTFILEDIR}/vim/vimrc" "${HOME}/.vimrc"

# Install vim plugin manager if needed
if [[ ! -e "${HOME}/.vim/autoload/plug.vim" ]]; then
    curl --silent -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim || echo "Error installing vim plugin manager"
fi

# TODO: somehow configure vim plugin
# To do so, first ':PlugInstall' must be ran in vim. Can vim commands be ran programatically?

# Git
deploy "${DOTFILEDIR}/git/gitconfig" "${HOME}/.gitconfig"
deploy "${DOTFILEDIR}/git/gitignore_global" "${HOME}/.gitignore_global"


