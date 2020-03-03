#!/usr/bin/env bash
# TODO: determine scope. Where does the initial setup script end and this begin?
set -Eeuo pipefail


# TODO: Turn this into a makefile?

# --------------------------------------------------
# Functions
# --------------------------------------------------
deploy()
{
    file="$1"
    linkTarget="$2"

    # If already exists
    if [[ -e "${linkTarget}" ]]; then
        timeStamp="$(date "+%Y-%m-%d_%H:%M:%S")"
        backup="${linkTarget}_backup_${timeStamp}"
        mv "${linkTarget}" "${linkTarget}_backup_${timeStamp}"
        echo "Backed up '${linkTarget}' to '${backup}'"
    fi

    ln -s "${file}" "${linkTarget}" || { echo "Error linking '${file}' to '${linkTarget}'"; exit 1; }
    echo "Linked '${file}' to '${linkTarget}'"
}

# --------------------------------------------------
# Main
# --------------------------------------------------
DOTFILEDIR="$(pwd)"

# Bash
deploy "${DOTFILEDIR}/bashrc" "${HOME}/.bashrc"
deploy "${DOTFILEDIR}/bash_profile" "${HOME}/.bash_profile"

# Vim
deploy "${DOTFILEDIR}/vim/vimrc" "${HOME}/.vimrc"

# Install vim plugin manager if needed
if [[ ! -e "${HOME}/.vim/autoload/plug.vim" ]]; then
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim || echo "Error installing vim plugin manager"
fi

