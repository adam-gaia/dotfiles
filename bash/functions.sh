#!/usr/bin/env bash
# Bash functions

# TODO: break up long lines into multi-line with \
# TODO: Move comments explaining commands from above the command declaration into the command { }
#       This way, type -a will display the comments
# TODO: Is defining functions with 'function' better?
# TODO: no hard paths to grep and other utilities aliased to color versions. Instead, make helper functions

# --------------------------------------------------------------------------------
# Misc. Utilities
# --------------------------------------------------------------------------------
function reload()
{
    # TODO: can we first unsource/clear everything? (be careful when clearing env vars. Maybe don't clear them)
    #shellcheck source=./bash/bashrc
    source "${HOME}/.bashrc"
}

function reloadInputrc()
{
    # Reload readline's inputrc
    bind -f ~/.inputrc
}

function todo()
{
    ind git -c color.grep.linenumber="green" -c color.grep.filename="magenta" grep -in --color "TODO\|FIXME\|HACK" | /usr/local/bin/ggrep -v "Binary file" || echo "No matches" # TODO only use ggrep on mac. use grep when gnu grep is default
}

# Override which to search aliases and functions
function which()
{
    if [[ "${#}" -eq 0 ]]; then
        echo "Error, no argument provided."  1>&2
        return 1
    fi

    query="$1"
    errmsg="'${query}' is not an alias, builtin, executable, keyword or function on the path."

    typesFound=$(type -at "${query}") || { echo "${errmsg}"; return 1; }
    readarray -t typesFoundArray <<<"$typesFound"
    

    if [[ ${#typesFoundArray[@]} -ge 1 ]]; then
        echo "'${query}' is"
        indent="    "
    else
        echo -n "'${query}' is "
        indent=""
    fi

    for t in "${typesFoundArray[@]}"; do

        case "${t}" in
    
            alias)
                # Grab and display what $query is aliased to
                value=$(alias "${query}" | sed "s/alias ${query}=//g") # wont work with back ticks
                printBlue "${indent}aliased "
                echo "to ${value}"
                ;;
            keyword)
                printBlue "${indent}shell keyword"; echo ""
                ;;
            function)
                # Display file with function deceleration
                shopt -s extdebug;
                info=$(declare -Ff "${query}")
                shopt -u extdebug
                fileName=$(echo "$info" | cut -f3 -d' ')
                lineNum=$(echo "$info" | cut -f2 -d' ')
                printBlue "${indent}function "
                echo "${fileName}:${lineNum}"
                ;;
            builtin)
                printBlue "${indent}shell builtin"; echo ""
                ;;
            file)
                # Files are always listed last, so it's ok to list all and return after finding the first one.
                # This was the best way I could figure to handle printing all possible matches on the path.
                
                files=$(type -af "${query}" | grep "/")
                readarray -t filesArray <<<"$files"
                for f in "${filesArray[@]}"; do
                    printBlue "${indent}file "
                    echo "${f}" | sed 's/.* is \//\//'
                done

                return 0
                ;;
        esac

    done 
}

# Override 'test' to print exit status. No more 'test <expression>; echo $?'
function test()
{
    builtin test $@ && echo 'true' || echo 'false'
}

# Create a directory and cd to it
function mkcd()
{
    mkdir "${1}" || exit 1
    cd "${1}" || { echo "${1} created, but cd failed"; exit 1; }
}

function path()
{
    # shellcheck disable=SC2001
    echo "${PATH}" |sed 's/:/\n/g'
}

# TODO
#rm()
#{
#        /bin/rm $@ || /bin/mdir $@
#}


# --------------------------------------------------------------------------------
# Navigation utilities
# --------------------------------------------------------------------------------
cd()
{
    # With shopt autocd set, we have to make this check
    if [[ $# -eq 2 && "$1" == '--' ]]; then
        input="$2"
    else
        input="$1"
    fi

    PREVIOUS_DIR="$(pwd)"
    if [[ -z "$input" ]] ; then
        builtin cd || return 1
    else
        builtin cd "$input" || return 1
    fi

    helper_lsAfterCD
}

back() # TODO: look into $OLDPWD
{
    prev_tmp="$(pwd)"
    builtin cd "$PREVIOUS_DIR" && PREVIOUS_DIR="$prev_tmp"
    helper_lsAfterCD
}

# Show directory command "back" will take us to 
back?()
{
    ind echo "Last visited dir: $PREVIOUS_DIR  (use cmd 'back' to jump here)"
}

# "Drop a pin" to remember this dir for later # TODO: come up with a way to save/get to multiple locations
# TODO: look into pushd, popd, and dirs. These probably already do what I'm looking for
dropPin()
{
        SAVE_THIS_DIR="$(pwd)"
        export SAVE_THIS_DIR
        ind echo "${SAVE_THIS_DIR} saved"
}

pin?() # Show pinned locations # TODO: add support for multiple pins
{
        ind echo "Pinned dirs: ${SAVE_THIS_DIR}"
}

goToPin()
{
        cd "$SAVE_THIS_DIR" || return 1
}

# Used to print directory contents after cd-ing to a dir
helper_lsAfterCD()
{
    unameOut="$(uname -s)"
    case "${unameOut}" in
        Darwin*) 
            /bin/ls -G # TODO: set flags for mac ls
            ;;
        Linux*)
            ind ls --color=always --group-directories-first -Cq
            ;;
        *)
            ind ls --color=always --group-directories-first -Cq
    esac
          # TODO: like with the ls alias, if ~file found, print filename(~)
    
}

?() # TODO: come up with a better name for this function. Use '?' as the name of a new function that displays a quick snapshot of intresting stuff
#               such as host name, network name, storage stuff, cpu usage and stuff like that
{
    # Display current directory, last used directory, and any pinned directories
    ind echo "Current dir: $(pwd)"
    'back?' # back ticks to allow a question mark in a command name
    'pin?'
}


# --------------------------------------------------------------------------------
# Change Color/Prompt by host
# --------------------------------------------------------------------------------
#function setPromptByHost(){

	# if $hostname contains searchstring

	#DOMAIN="$(dnsdomainname)" || 



	#if [ $HOSTNAME == *"Helix"* ]; then # Helix

	#else if [ "$HOSTNAME" == *"eng.utah.edu"* ]; then # CADE

	#else if [ "$HOSTNAME" == *"HMX"* ]; then # HMX

	#else if [ "$HOSTNAME" == *"cyrus"* || "$HOSTNAME" == *"yrusc"* ]; then # Cyrus

	#else if [ "$HOSTNAME" == *"eng.utah.edu"* ]; then # CHPC

	#else

	#fi


	# Cheyenne [ "$HOSTNAME" == *"cheyenne"* ]
	# Bridges [ "$HOSTNAME" == *"bridges"* ]
#}

# sshColor()
# {
#     tmux select-pane -t:. -P 'bg=red'
#     ssh "$1"
#     tmux select-pane -t:. -P 'bg=none'
#     clear
# }



# ssh()
# {	
# 	# If multiple args, ssh like normal.
# 	# TODO: Automatically define any new host in the ssh config, then add a case below for it
#         # TODO: setup error logging incase color change fails. Set up logs for all fnuctions too
#         # TODO figure out how to change one tab without changing all tabs. Tmux?
# 	if [[ "$#" -gt 1 ]]; then
# 		"${HOME}"/anaconda3/bin/wal -q --theme base16-codeschool
# 		/usr/bin/ssh "$@"
# 	fi


# 	# Otherwise, set colors based on machines in ssh config
#         # TODO: set favorite schemes to most used hosts
# 	host_machine="${1}"
# 	case "${host_machine}" in
	
# 		# CADE
# 		"cade*")
# 			colorscheme="sexy-material"
# 			;;
	
# 		# Work
# 		"cyrus")
# 			colorscheme="hybrid-material"
# 			;;
#                 "hmx")
# 			colorscheme="darktooth"
# 			;;
	
# 		# CHPC
# 		"notch")
# 			colorscheme="sexy-hund"
# 			;;
# 		"ember")
# 			colorscheme="gruvbox"
# 			;;
# 		"lone")
# 			colorscheme="vscode"
# 			;;
# 		"kings")
# 			colorscheme="base16-hopscotch"
# 			;;
#                 "ash")
# 			colorscheme="base16-chalk"
# 			;;

	
# 		# Cheyenne
# 		"chey")
# 			colorscheme="base16-phd"
# 			;;

# 		# Bridges
#                 "bridges")
# 			colorscheme="3024"
# 			;;

# 		# Virtual Box
# 		"cs3505")
# 			colorscheme="base16-nord"
# 			;;

# 		# Catch all else
# 		*)
# 			colorscheme="sexy-sexcolors"
# 			;;

# 	esac

	
# 	"${HOME}"/anaconda3/bin/wal -q --theme "${colorscheme}"
# 	/usr/bin/ssh "${host_machine}"


# 	# After exiting ssh, change colorscheme back to monokai
# 	"${HOME}"/anaconda3/bin/wal -q --theme monokai	
	
# }



# --------------------------------------------------------------------------------
# Indent Output
# --------------------------------------------------------------------------------
# TODO: How can we call this before every command automatically?
ind()
{
    # Stream input
    if [[ $# -eq 0 ]]; then
        while IFS= read -r line; do
            echo "    ${line}"
        done
        return
    fi

    # Parameter input
    "${@}" 2>&1 | awk  '{ print "    " $0 }'
	return "$?"
}

# Start a shell with bash |indPipe to have all output indented. 
#   TODO: figure out how to make everything play nice
#   clear is broken
#   ls is broken sometimes -- haven't figured out the condition yet
#   vim is broken
#   more and less are broken
#   pipes.sh is broken
# TODO: merge both inds into one function
indPipe()
{
    while read -r line
    do
      echo "    $line"
    done
}


# --------------------------------------------------------------------------------
# Undo/Redo Functionality # TODO: add support for arguments like mv -v and cp -R
# TODO: come up with better variable names
# --------------------------------------------------------------------------------
cp_undoable()
{
	# Check arguments
	if [[ $# != 2 ]] ; then 
		echo "Error, must input two file paths"  1>&2
		return 1
	fi

	source="$1"
	destination="$2"

	# Save variables for undoing
	UNDOABLE_FUNCTIONS_LAST_USED_SOURCE_PATH="$(realPath "$source")"
	UNDOABLE_FUNCTIONS_LAST_USED_DESTINATION_PATH="$(realPath "$destination")"
    UNDOABLE_FUNCTIONS_LAST_USED_OPERATION="cp"
    UNDOABLE="true"
    export UNDOABLE_FUNCTIONS_LAST_USED_SOURCE_PATH
    export UNDOABLE_FUNCTIONS_LAST_USED_DESTINATION_PATH
    export UNDOABLE_FUNCTIONS_LAST_USED_OPERATION
    export UNDOABLE

	# Perform action
	/bin/cp "$source" "$destination"

	return 0
}

mv_undoable()
{
	# Check arguments
	if [[ $# != 2 ]] ; then 
		echo "Error, must input two file paths"  1>&2
		return 1
	fi

	source="$1"
	destination="$2"

	# Save variables for undoing
	UNDOABLE_FUNCTIONS_LAST_USED_SOURCE_PATH="$(realPath "$source")"
	UNDOABLE_FUNCTIONS_LAST_USED_DESTINATION_PATH="$(realPath "$destination")"
	UNDOABLE_FUNCTIONS_LAST_USED_OPERATION="mv"
	UNDOABLE="true"
    export UNDOABLE_FUNCTIONS_LAST_USED_SOURCE_PATH
    export UNDOABLE_FUNCTIONS_LAST_USED_DESTINATION_PATH
    export UNDOABLE_FUNCTIONS_LAST_USED_OPERATION
    export UNDOABLE

	# Perform action
	/bin/mv "$source" "$destination"

	return 0
}

rm_undoable()
{
    # TODO: This script may break if user is removing multiple files

	# Check bash version number
	bashVersionFirstNum=$(echo "$BASH_VERSION" | head -c 1)
	if (( "$bashVersionFirstNum" < 5 )) ; then
		echo "Error: The remap rm to mv ~/.Trash function requires bash v4+ to work"  1>&2
		return 1
	fi

	# Check that realpath utility is installed (and)
	realPathUtill="$(command -v realpath)"
	if [[ ! -e "$realPathUtill" ]]; then
		echo "Error: realpath utility is not installed (or not on the path)"  1>&2
		return 1
	fi

	# Parse args # TODO: do this better
	if [[ $1 == "-rf" || $1 == "-r" || $1 == "-f" ]]; then
		flags="$1"
		fileToRemove="$2"
    else
    	fileToRemove="$1"
        # shellcheck disable=SC2034
    	flags="$2" # unused var ignored for now.
    fi

    # Remove possible trailing slash from path
    if [[ "${fileToRemove: -1}" == "/" ]] ; then
    	fileToRemove="${fileToRemove::-1}" # only works with bash v4+
	fi

	# Save time to append to trashed file name - TODO unused var ignored for now
    # shellcheck disable=SC2034
	timestamp="$(date +%d.%m.%Y_%H:%M:%S)"

	# Set destination path
	trashPath="${HOME}/.Trash/${fileToRemove}" #_${timestamp}"

	# Save variables for undoing
	UNDOABLE_FUNCTIONS_LAST_USED_SOURCE_PATH="$(realPath "${fileToRemove}")"
    UNDOABLE_FUNCTIONS_LAST_USED_DESTINATION_PATH="$trashPath"
	UNDOABLE_FUNCTIONS_LAST_USED_OPERATION="rm"
	UNDOABLE="true"
    export UNDOABLE_FUNCTIONS_LAST_USED_SOURCE_PATH
    export UNDOABLE_FUNCTIONS_LAST_USED_DESTINATION_PATH
    export UNDOABLE_FUNCTIONS_LAST_USED_OPERATION
    export UNDOABLE

	# Perform action
    /bin/mv "$fileToRemove" "$trashPath"

    return 0
}

rmdir_undoable()
{
	echo "not implemented yet"
	return 0
}

undo() # TODO: Get really clever and use a stack to keep track of undo able actions - maybe even write these functions in c
{
	if [[ "$UNDOABLE" == "false" ]] ; then
		echo "Error, nothing to undo"  1>&2
		return 1
	fi

	if [[ "$UNDOABLE_FUNCTIONS_LAST_USED_OPERATION" == "cp" ]] ; then
		# Remove copy of destination file
		/bin/rm "$UNDOABLE_FUNCTIONS_LAST_USED_DESTINATION_PATH"
		export REDOABLE_FUNCTION="cp"
		export REDO_SOURCE_PATH="$UNDOABLE_FUNCTIONS_LAST_USED_SOURCE_PATH"
		export REDO_DESTINATION_PATH="$UNDOABLE_FUNCTIONS_LAST_USED_DESTINATION_PATH"
	else # if [[ $UNDOABLE_FUNCTIONS_LAST_USED_OPERATION == "mv" ]] or [[ $UNDOABLE_FUNCTIONS_LAST_USED_OPERATION == "rm" ]; then
		# Move destination back to source
		/bin/mv "$UNDOABLE_FUNCTIONS_LAST_USED_DESTINATION_PATH" "$UNDOABLE_FUNCTIONS_LAST_USED_SOURCE_PATH"
		export REDOABLE_FUNCTION="mv"
		export REDO_SOURCE_PATH="$UNDOABLE_FUNCTIONS_LAST_USED_SOURCE_PATH"
		export REDO_DESTINATION_PATH="$UNDOABLE_FUNCTIONS_LAST_USED_DESTINATION_PATH"
	fi

	export UNDOABLE="false"
	export REDOABLE="true"

	return 0
}

redo()
{
	if [[ "$REDOABLE" == "false" ]] ; then
		echo "Error, nothing to redo"  1>&2
		return 1
	fi

	if [[ "$REDOABLE_FUNCTION" == "cp" ]] ; then
		/bin/cp "$REDO_SOURCE_PATH" "$REDO_DESTINATION_PATH"
	else # [[ REDOABLE_FUNCTION == "mv" ]] or [[ REDOABLE_FUNCTION == "rm" ]] ; then
		/bin/mv "$REDO_SOURCE_PATH" "$REDO_DESTINATION_PATH"
	fi

	#export UNDOABLE="true" # TODO: add functionality to undo and redo back and forth
	export REDOABLE="false"

	return 0
}


# --------------------------------------------------------------------------------
# Window Manager Functions
# --------------------------------------------------------------------------------
startwm() # start window manager
{
	# Run in parallel
	brew services start skhd &
	brew services start yabai &
	wait
}

stopwm() # stop window manager
{
	# Run in parallel
	brew services stop skhd &
	brew services stop yabai &
	wait
}


wm() # Toggle
{
        if [[ "$1" == "start" ]] ; then
            brew services start skhd &
            brew services start yabai &
            return 0

        elif [[ "$1" == "stop" ]] ; then
            brew services stop skhd &
            brew services stop yabai &
            return 0

        else
            echo "Error, unknown argument: ${1}"  1>&2
            echo "Valid usage: wm <start|stop>"
            return 1

        fi
}


# --------------------------------------------------------------------------------
# Git Prompt Functions
# --------------------------------------------------------------------------------

getGitBranch()
{
    gitBranch="$(git symbolic-ref --short HEAD 2> /dev/null)"
    if [[ -n $gitBranch ]]; then
        echo -n "(${gitBranch})"
        
        if [[ -n "$(git status -s 2> /dev/null)" ]]; then
            echo "*" # show uncommited changes
        fi

    fi
}



