#!/usr/bin/env bash

# TODO: get conda + python sorted out

# Python start up file
export PYTHONSTARTUP="${HOME}/.pythonrc.py"


# Easy access to Anaconda python
alias myAnacondaDont="/Users/adamgaia/anaconda3/bin/python"


# --------------------------------------------------------------------------------
# Auto-generated by Anaconda
# --------------------------------------------------------------------------------
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/adamgaia/anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
# shellcheck disable=SC2181
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/adamgaia/anaconda3/etc/profile.d/conda.sh" ]; then
        # shellcheck disable=SC1091
        source "/Users/adamgaia/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/adamgaia/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
