#!/usr/bin/env bash
# Main bash environment setup file

# TODO: 
#   organize and cleanup
#   Change any instances of my username
# TODO: set CDPATH
#       see 'builtin cd --help for more'
# TODO: use 'bash --rcfile file' to force bash to only source specific files at startup
# TODO: set settings based on login shell and/or interactive shell

# Source order: OS, aliases, functions, color utilities


# --------------------------------------------------------------------------------
# OS specific config
# --------------------------------------------------------------------------------
unameOut="$(uname -s)"
case "${unameOut}" in
    Darwin*) 
        export DOTFILEDIR="/Users/${USER}/repo/dotfiles"
        source "${DOTFILEDIR}/OS/mac.sh"
        ;;
    Linux*)
        export DOTFILEDIR="/home/${USER}/repo/dotfiles"
        source "${DOTFILEDIR}/OS/linux.sh"
        ;;
    *)
        echo "Unknown OS type, defaulting to Linux setup"
        export DOTFILEDIR="/home/${USER}/repo/dotfiles"
        source "${DOTFILEDIR}/OS/linux.sh"
esac


# --------------------------------------------------------------------------------
# Source external files
# --------------------------------------------------------------------------------
#TODO: always source aliases first or remove anything that is an alias from bash_functions
# shellcheck source=aliases.sh
source "${DOTFILEDIR}/aliases.sh"
# shellcheck source=functions.sh
source "${DOTFILEDIR}/functions.sh"
# shellcheck source=python.sh
source "${DOTFILEDIR}/python.sh" # Python paths


# --------------------------------------------------------------------------------
# Colors - prompt, dir colors, 
# --------------------------------------------------------------------------------
if [ "$TERM" != dumb ]; then
    # shellcheck source=color.sh
    source "${DOTFILEDIR}/colors/color.sh"
else
    export PS1="$ "
fi


# --------------------------------------------------
# Pager & Editor
# --------------------------------------------------
export PAGER="less" # Set less as the default pager (like when reading man pages)
export EDITOR='nvim' # Default editor

# --------------------------------------------------
# History
# --------------------------------------------------
# Store 5000 commands in history buffer
export HISTSIZE=5000

# Store 5000 commands in history FILE 
export HISTFILESIZE=5000      

# Avoid duplicates in history when the same command is ran multiple times in a row
export HISTIGNORE='&:[ ]*'


# --------------------------------------------------
# Shopt & Set
# --------------------------------------------------
# Manually toggled
set -o vi # Vi key-binds
set -o pipefail # Pipes will fail if any fail, instead of just the last one 
shopt -s autocd # If command is the name of a directory, cd to it
shopt -s histappend # Append session history  to the history file when shell exits

# TODO: where is tab auto-complete coming from? Do we want to turn on cdspell?

# Default on
set -hmBH
shopt -s checkwinsize \
         cmdhist \
         complete_fullquote \
         expand_aliases \
         extquote \
         force_fignore \
         globasciiranges \
         hostcomplete \
         interactive_comments \
         login_shell \
         progcomp \
         promptvars \
         sourcepath

# Default off
set +abefknptuvxC # TODO: according to set's doc, "$-" shows all currently set options. Why then does it eval to 'himBHs'? The 'i' is interactive shell. Where do the 's' come from? 
shopt -u assoc_expand_once \
         cdable_vars \
         cdspell \
         checkhash \
         checkjobs \
         compat31 \
         compat32 \
         compat40 \
         compat41 \
         compat42 \
         compat43 \
         compat44 \
         direxpand \
         dirspell \
         dotglob \
         execfail \
         extdebug \
         extglob \
         failglob \
         globstar \
         gnu_errfmt \
         histreedit \
         histverify \
         huponexit \
         inherit_errexit \
         lastpipe \
         lithist \
         localvar_inherit \
         localvar_unset \
         mailwarn \
         no_empty_cmd_completion \
         nocaseglob \
         nocasematch \
         nullglob \
         progcomp_alias \
         restricted_shell \
         shift_verbose \
         xpg_echo


