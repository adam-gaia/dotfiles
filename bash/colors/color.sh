#!/usr/bin/env bash
# Terminal with colors

# --------------------------------------------------------------------------------
# Color Vars
# Heads up: Colors are mapped to the Pywal Monokai scheme
# TODO: checkout color heading from https://github.com/dylanaraps/pure-sh-bible#get-the-directory-name-of-a-file-path
# ---------------------------------------------------------------------------------
export RED='\033[31m'
export GREEN='\033[32m'
export YELLOW='\033[33m'
export BLUE='\033[34m'
export BLACK='\033[90m'
export PURPLE='\033[35m'
export CYAN='\033[35m'
export NO_COLOR='\033[m'
export UNDERLINE_ON='\033[4m'
export UNDERLINE_OFF='\033[24m'
export BOLD_ON='\033[1m'
export BOLD_OFF='\033[21m'


# --------------------------------------------------------------------------------
# Set Prompt
#   "user@host:/current/path(gitBranch)*
#        $ "
# --------------------------------------------------------------------------------
export PS1="\n\[\033[01;32m\]\u\[\033[1m\]\[\033[00m\]@\[\033[01;32m\]\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\[\e[33m\]\[\033[1m\$(gitPromptInfo)\]\[\e[0m\]\n\$ "
# TODO: replace with color vars for readability


# --------------------------------------------------------------------------------
# Pywal theme
# --------------------------------------------------------------------------------
# Pywal cursor color may not show. Fix here: https://github.com/dylanaraps/pywal/issues/382
timeout 1 python3 -m pywal -q --theme "${DOTFILEDIR}/bash/colors/pywal_modified_monokai.json" --vte #TODO: save python location as a var, then sub here # TODO: fix highlighting issues from pywal on mac
eval "$(dircolors "${DOTFILEDIR}/bash/colors/dircolors_Monokai")" # Associate .dircolors_Monokai file with the dircolors utility


# --------------------------------------------------------------------------------
# Color Utilities
# TODO: color functions should have a newline flag
# ---------------------------------------------------------------------------------
printRed()
{
    # Use argument or standard input. Arg overrides stdin
    if [[ "$#" -eq 0 ]]; then
        while IFS= read -r line; do
            echo -en "${RED}${line}${NO_COLOR}"
        done
    else
        echo -en "${RED}${*}${NO_COLOR}"
    fi
}

printGreen()
{
    # Use argument or standard input. Arg overrides stdin
    if [[ "$#" -eq 0 ]]; then
        while IFS= read -r line; do
            echo -en "${GREEN}${line}${NO_COLOR}"
        done
    else
        echo -en "${GREEN}${*}${NO_COLOR}"
    fi
}

printYellow()
{
    # Use argument or standard input. Arg overrides stdin
    if [[ "$#" -eq 0 ]]; then
        while IFS= read -r line; do
            echo -en "${YELLOW}${line}${NO_COLOR}"
        done
    else
        echo -en "${YELLOW}${*}${NO_COLOR}"
    fi
}

printBlue()
{
    # Use argument or standard input. Arg overrides stdin
    if [[ "$#" -eq 0 ]]; then
        while IFS= read -r line; do
            echo -en "${BLUE}${line}${NO_COLOR}"
        done
    else
        echo -en "${BLUE}${*}${NO_COLOR}"
    fi
}

printBlack()
{
    # Use argument or standard input. Arg overrides stdin
    if [[ "$#" -eq 0 ]]; then
        while IFS= read -r line; do
            echo -en "${BLACK}${line}${NO_COLOR}"
        done
    else
        echo -en "${BLACK}${*}${NO_COLOR}"
    fi
}

printPurple()
{
    # Use argument or standard input. Arg overrides stdin
    if [[ "$#" -eq 0 ]]; then
        while IFS= read -r line; do
            echo -en "${PURPLE}${line}${NO_COLOR}"
        done
    else
        echo -en "${PURPLE}${*}${NO_COLOR}"
    fi
}

printCyan()
{
    # Use argument or standard input. Arg overrides stdin
    if [[ "$#" -eq 0 ]]; then
        while IFS= read -r line; do
            echo -en "${CYAN}${line}${NO_COLOR}"
        done
    else
        echo -en "${CYAN}${*}${NO_COLOR}"
    fi
}

printBold()
{
    # Use argument or standard input. Arg overrides stdin
    if [[ "$#" -eq 0 ]]; then
        while IFS= read -r line; do
            echo -en "${BOLD_ON}${line}${BOLD_OFF}"
        done
    else
        echo -en "${BOLD_ON}${*}${NO_COLOR}"
    fi
}

printUnderline()
{
     # Use argument or standard input. Arg overrides stdin
    if [[ "$#" -eq 0 ]]; then
        while IFS= read -r line; do
            echo -en "${UNDERLINE_ON}${line}${UNDERLINE_OFF}"
        done
    else
        echo -en "${UNDERLINE_ON}${*}${NO_COLOR}"
    fi
}


# --------------------------------------------------------------------------------
# Always use color arguments
# ---------------------------------------------------------------------------------
alias tree="tree -C"
cat() { src-hilite-lesspipe.sh "$@"; }


# ---------------------------------------------------------------------------------
# Set less colors
# ---------------------------------------------------------------------------------
export LESS_TERMCAP_mb=$'\e[1;32m'
export LESS_TERMCAP_md=$'\e[1;34m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;33m'
export LESS_TERMCAP_us=$'\e[1;4;31m'
export LESS_TERMCAP_ue=$'\e[0m'
# Bug: exporting 'LESS_TERMCAP_us' last with 'set -x' makes all set -x output print red



# --------------------------------------------------------------------------------
# Colorify commands - I think this was taken from Brew's color aliases
# TODO: color functions should have a newline flag
# ---------------------------------------------------------------------------------
if [[ "$(command -v grc)" ]]; then # TODO add more checks for commands before using them
    alias colorify="grc -es --colour=auto"
    alias blkid='colorify blkid'
    alias configure='colorify ./configure'
    alias df='colorify df'
    alias diff='colorify diff'
    alias docker='colorify docker'
    alias docker-machine='colorify docker-machine'
    alias du='colorify du'
    alias env='colorify env'
    alias free='colorify free'
    alias fdisk='colorify fdisk'
    alias findmnt='colorify findmnt'
    #alias make='colorify make' # Removed in favor of gmake alias
    alias gcc='colorify gcc'
    alias g++='colorify g++'
    alias id='colorify id'
    alias ip='colorify ip'
    alias iptables='colorify iptables'
    alias as='colorify as'
    alias gas='colorify gas'
    alias ld='colorify ld'
    #alias ls='colorify ls'
    alias lsof='colorify lsof'
    alias lsblk='colorify lsblk'
    alias lspci='colorify lspci'
    alias netstat='colorify netstat'
    alias ping='colorify ping'
    alias traceroute='colorify traceroute'
    alias traceroute6='colorify traceroute6'
    alias head='colorify head'
    alias tail='colorify tail'
    alias dig='colorify dig'
    alias mount='colorify mount'
    #alias ps='colorify ps'
    alias mtr='colorify mtr'
    alias semanage='colorify semanage'
    alias getsebool='colorify getsebool'
    alias ifconfig='colorify ifconfig'
fi



