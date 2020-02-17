#!/usr/bin/env bash

# Install brew
if [[ ! "$(command -v brew)" ]]; then 
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

brew update
brew analytics off

# Install updated versions of core software
brew install git \
             bash \
             gpatch \
             less \
             m4 \
             make \
             nano \
             vim \
             gcc


# GNU Utilities
brew install coreutils \
             binutils \
             diffutils \
             ed \
             findutils \
             gawk \
             gnuplot \
             gnutls \
             gnu-getopt \
             gnu-indent \
             gnu-sed \
             gnu-tar \
             gnu-which \
             gnutls \
             grep \
             gzip \
             screen \
             watch \
             wdiff \
             wget

# Others - TODO: sort separate mac only. Put linux + mac compatible in a shared file
# TODO: sort by essential to non essential. Have this script take a flag to only install essentials
brew install tmux \
             qt \
             navi \
             tree \
             yabai \
             w3m \
             cowsay \
             fortune \
             blueutil \
             cppman \
             jq \
             lynx \
             neofetch \
             pipes-sh \
             source-highlight \
             watch \
             xmlstarlet \
             imagemagick

# LaTeX
brew cask install basicte

# TODO: install gdb. Requires extra steps to make work
# TODO: sort out brew ruby vs mac ruby

# Deploy dotfiles
./deploy.sh


