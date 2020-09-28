#!/usr/bin/env bash
# Bash aliases


# grep alias - use gnu grep + color
alias grep='ind grep --color=always' # loses color with ind


# ls with color - pulls from gnuCoreUtils dircolors
alias ls='ind ls --color=always --group-directories-first -alh' # The only way I could get the indentation to work. If ls was already an alias, it would lose color with ind.
# TODO: Create a function that shows when a file has a complimenting 'file~'  Example: if 'fileName' and 'fileName~', output 'fileName(~)'

# Tree with indentation and color
alias tree="ind tree"

# NeoVim
alias vi="vim"
alias emacs="vim" # lol

# git
alias ga="git add"
alias gc="git commit"
alias gcm="git commit -m"
alias gpl="git pull"
alias gps="git push"
alias gf="git fetch"
alias gb="git branch"
alias gm="git merge"

# Force mkdir to make intermediate directories
alias mkdir="mkdir -pv" # TODO: make this a function that will print a message if an intermediate dir was created

# cd with ease
alias ..="cd .."
alias ..2="cd ../.."
alias ..3="cd ../../.."
alias ..4="cd ../../../.."
alias ..5="cd ../../../../.." # TODO: be clever about this with a function that can take in any number

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."

# :D
alias simonsays='sudo'

# Vim commands
alias :q='exit'

# Use htop instead of top
alias top='htop'


# Catch common misspellings and mistypings
alias sl='ls'
alias Grep='grep'

# Always use pip from the latest python
alias pip='python3 -m pip'


