#!/usr/bin/env bash



# TODO: save mac defaults before and after running this ('defaults' command)
# Compare differences in case user wants to keep something they have set

mkdir -p "${HOME}/tmp"

brew update
brew analytics off




# TODO: gdb initial setup


# Others - TODO: sort separate mac only. Put linux + mac compatible in a shared file
# TODO: sort by essential to non essential. Have this script take a flag to only install essentials




# TODO: install gdb. Requires extra steps to make work
# TODO: sort out brew ruby vs mac ruby

# Deploy dotfiles
./deploy.sh


# Mac SIP gdb fix
echo "set startup-with-shell off" >> ~/.gdbinit



