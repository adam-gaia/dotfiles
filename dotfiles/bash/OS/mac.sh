#!/usr/bin/env bash
# Mac-specific bash configuration

# Suppress Mac upgrade to zsh message
export BASH_SILENCE_DEPRECATION_WARNING=1

# --------------------------------------------------------------------------------
# Use Gnu utilities - Taken from https://github.com/denisidoro/dotfiles
# --------------------------------------------------------------------------------
function dircolors() { gdircolors "$@"; }
function make()      { gmake "$@"; }
function mv()        { gmv "$@"; }
function sed()       { gsed "$@"; }
function awk()       { gawk "$@"; }
function find()      { gfind "$@"; }
function grep()      { ggrep "$@"; }
function head()      { ghead "$@"; }
function mktemp()    { gmktemp "$@"; }
function ls()        { gls "$@"; }
function date()      { gdate "$@"; }
function shred()     { gshred "$@"; }
function cut()       { gcut "$@"; }
function tr()        { gtr "$@"; }
function od()        { god "$@"; }
function cp()        { gcp "$@"; }
function cat()       { gcat "$@"; }
function sort()      { gsort "$@"; }
function kill()      { gkill "$@"; }
function xargs()     { gxargs "$@"; }
function readlink()  { greadlink "$@"; }
function stat()      { gstat "$@"; }
function patch()    { gpatch "$@"; }

# TODO: should I export these or not?
# TODO: where did the idea to export these come from?
#        Do I export other stuff? Why export functions?
# export -f sed awk find head mktemp date shred cut tr od cp cat sort kill xargs readlink


# --------------------------------------------------------------------------------
# Set Mac specific paths
# --------------------------------------------------------------------------------
# Python3
PATH="${PATH}:/Library/Frameworks/Python.framework/Versions/3.6/bin:/Users/adamgaia/Library/Python/3.6/bin"

# Brew
PATH="${PATH}:/usr/local/bin"

# MacOS
PATH="${PATH}/bin:/sbin:/sbin:/usr/bin:/usr/sbin/:/opt/X11/bin:"

# Mac Ports
PATH="${PATH}:/opt/local/bin:/opt/local/sbin"

# Mac GPG
PATH="${PATH}:/usr/local/MacGPG2/bin"

# LaTeX
PATH="${PATH}:/Library/TeX/texbin:/usr/local/opt/texinfo/bin"

# Microsoft
PATH="${PATH}:/Library/Frameworks/Mono.framework/Versions/Current/Commands:/usr/local/share/dotnet"

export PATH

# --------------------------------------------------------------------------------
# Configure Homebrew
# --------------------------------------------------------------------------------
eval $(/usr/local/bin/brew shellenv)


# Git auto-complete
if [ -f /usr/local/share/bash-completion/bash_completion ]; then
    source /usr/local/share/bash-completion/bash_completion
fi
