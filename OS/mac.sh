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
# Set Mac specific path
# --------------------------------------------------------------------------------
export PATH="/Users/adamgaia/anaconda3/condabin:/Users/adamgaia/.local/bin:.:/usr/local/opt/texinfo/bin:/Users/adamgaia/Library/Python/3.6/bin:/opt/local/bin:/opt/local/sbin:/Library/Frameworks/Python.framework/Versions/3.6/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/local/bin:/opt/local/sbin:/Library/TeX/texbin:/usr/local/MacGPG2/bin:/usr/local/share/dotnet:/opt/X11/bin:~/.dotnet/tools:/Library/Frameworks/Mono.framework/Versions/Current/Commands:/Applications/Xamarin Workbooks.app/Contents/SharedSupport/path-bin:/Users/adamgaia/.vimpkg/bin"

# Setting PATH for Python 3.6
# The original version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.6/bin:${PATH}"
export PATH

##
# Your previous /Users/adamgaia/.bash_profile file was backed up as /Users/adamgaia/.bash_profile.macports-saved_2018-02-27_at_17:03:39
##

# MacPorts Installer addition on 2018-02-27_at_17:03:39: adding an appropriate PATH variable for use with MacPorts.
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
# Finished adapting your PATH environment variable for use with MacPorts.

# added by Anaconda3 5.1.0 installer
# export PATH="/Users/adamgaia/anaconda3/bin:$PATH"  # commented out by conda initialize

# Add path to globus installed via pip3
export PATH="/Users/adamgaia/Library/Python/3.6/bin:$PATH"

# Add makeinfo installed via 'brew install texinfo' to the path. The default makeinfo is out of date (/usr/local/bin/makeinfo)
export PATH=/usr/local/opt/texinfo/bin:$PATH

# add current directory to the path
export PATH=".:$PATH"


# --------------------------------------------------------------------------------
# Anaconda
# --------------------------------------------------------------------------------
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/adamgaia/anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/adamgaia/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/adamgaia/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/adamgaia/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

export PATH="/Users/adamgaia/anaconda3/condabin:.:/usr/local/opt/texinfo/bin:/Users/adamgaia/Library/Python/3.6/bin:/opt/local/bin:/opt/local/sbin:/Library/Frameworks/Python.framework/Versions/3.6/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/local/bin:/opt/local/sbin:/Library/TeX/texbin:/usr/local/MacGPG2/bin:/usr/local/share/dotnet:/opt/X11/bin:~/.dotnet/tools:/Library/Frameworks/Mono.framework/Versions/Current/Commands:/Applications/Xamarin Workbooks.app/Contents/SharedSupport/path-bin:/Users/adamgaia/.vimpkg/bin" # TODO: change this to be export $PATH:whatever_conda_needs




