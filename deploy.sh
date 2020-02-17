#!/usr/bin/env bash
set -Eeuo pipefail

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
deploy "${DOTFILEDIR}/bashrc" "${HOME}/.bashrc"
deploy "${DOTFILEDIR}/bash_profile" "${HOME}/.bash_profile"
