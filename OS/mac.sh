#!/usr/bin/env bash
# Mac-specific bash configuration

# Suppress Mac upgrade to zsh message
export BASH_SILENCE_DEPRECATION_WARNING=1

# --------------------------------------------------------------------------------
# Use Gnu utilities - Idea taken from https://github.com/denisidoro/dotfiles
# --------------------------------------------------------------------------------
dircolors() { gdircolors "$@"; }
sed() { gsed "$@"; }
awk() { gawk "$@"; }
find() { gfind "$@"; }
grep() { ggrep "$@"; }
head() { ghead "$@"; }
mktemp() { gmktemp "$@"; }
ls() { gls "$@"; }
date() { gdate "$@"; }
shred() { gshred "$@"; }
cut() { gcut "$@"; }
tr() { gtr "$@"; }
od() { god "$@"; }
cp() { gcp "$@"; }
cat() { gcat "$@"; }
sort() { gsort "$@"; }
kill() { gkill "$@"; }
xargs() { gxargs "$@"; }
readlink() { greadlink "$@"; }
export -f sed awk find head mktemp date shred cut tr od cp cat sort kill xargs readlink


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


