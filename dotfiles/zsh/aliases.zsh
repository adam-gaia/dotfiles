# zsh aliases

alias reload='exec zsh'

# Zsh's 'history' builtin only shows 16 items. This alias shows all history
alias history='fc -l 1'

# Issues with alacritty title bar on wayland. See https://wiki.archlinux.org/title/Alacritty#No_title_bar_on_Wayland_GNOME
alias alacritty='WAYLAND_DISPLAY="" alacritty'

alias grep='grep --color=always'

alias ls='lsd -alh --color=always' # TODO: figure out how to use 'ind' with lsd while keeping the info we want from lsd # The only way I could get the indentation to work. If ls was already an alias, it would lose color with ind.

alias fd='fd --color=always'


# NeoVim
alias vim='nvim'
alias vi="vim"
alias emacs="vim" # lol

# git
alias ga="git add"
alias gc="git commit"
alias gpl="git pull"
alias gps="git push"
alias gf="git fetch"
alias gb="git branch"
alias gm="git merge"

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
alias Grep='grep'

# Make make a little safer
alias make='make --warn-undefined-variables'

# --------------------------------------------------------------------------------
# Colorify commands - I think this was taken from Brew's color aliases
# TODO: color functions should have a newline flag
# ---------------------------------------------------------------------------------
if [[ "$(command -v grc)" ]]; then # TODO add more checks for commands before using them. And add 'grc' to packges to install
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
    alias make='colorify make'
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
    alias ps='colorify ps'
    alias mtr='colorify mtr'
    alias semanage='colorify semanage'
    alias getsebool='colorify getsebool'
    alias ifconfig='colorify ifconfig'
fi
alias tree='lsd --tree --color=always'
alias bat='batcat'
