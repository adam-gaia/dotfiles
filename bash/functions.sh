#!/usr/bin/env bash
# Bash functions

# TODO: break up long lines into multi-line with \
# TODO: Move comments explaining commands from above the command declaration into the command { }
#       This way, type -a will display the comments
# TODO: Is defining functions with 'function' better?
# TODO: no hard paths to grep and other utilities aliased to color versions. Instead, make helper functions
# TODO: Try to minimize using subshells. They add too much overhead
# TODO: Use local variables inside functions


# --------------------------------------------------------------------------------
# DOCSTRING notes and helper functions
# --------------------------------------------------------------------------------
function docstring_example()
{
    local DOCSTRING=("This is an example function to demonstrative docstring functionality."
                     "Simply add the contents of this function to your functions."
                     "The 'which' function will read these docstrings and print them."
                     "I recommend adding a usage section like this:"
                     ""
                     "Usage:"
                     "    docstring_example <arg1> <arg2> ..."
                     ""
                     "Now try running 'which docstring_example' or 'which which'")

    if [[ "$#" -eq 0 ]]; then
        errprint "${DOCSTRING[@]}" # Note: errprint is another function in this file
        return 0
    fi
}

function errprint()
{
     local DOCSTRING=("Print to stderr."
                      ""
                      "Usage:"
                      "    errprint <message1> <message2> ..."
                      ""
                      "Note: each argument is printed on a new line."
                      "Please encapsulate the entire message in quotes to print it all on a single line."
                      "Additionally, be careful with 'errprint \${array[@]}' and 'errprint \${array[*]}'")

    if [[ "$#" -eq 0 ]]; then
        errprint "${DOCSTRING[@]}"
        return 0
    fi
    # Note: The choice of '$@' instead of '$*' was intentional here.
    # Calling 'errprint ${arrayVar[@]}' will print each index of 'arrayVar' on a new line.
    # Our DOCSTRING functionality depends on this.
    printf "%s\n" "$@" >&2
}


# --------------------------------------------------------------------------------
# Git Shortcuts
# --------------------------------------------------------------------------------
function gcm()
{
    git commit -m "${*}"
}


# --------------------------------------------------------------------------------
# Misc. Utilities
# --------------------------------------------------------------------------------


function reload()
{
    local rcFile="${HOME}/.bashrc"

    # Sometimes I accidentally write 'exit' instead of 'return' in bash functions.
    # When that function is called, it kills my bash session.
    # As a safety check, we need to lint all files sourced so that no functions can exit.
    # TODO: lint all sourced files. For now we only lint this file. I don't declare any functions elsewhere anyways.
    # TODO: we could make a standalone bash linter out of this part. Not to replace a general linter like 'shellcheck', but to look for user specific things, like this exit problem
    #               grep for 'source', whole words only             | remove leading spaces       |remove commented lines| remove trailing comments      | remove leading 'source' and whitespace
    sourcedFiles="$( /bin/grep --color=never -w 'source' "${rcFile}" |  sed -e 's/^[[:space:]]*//' | /bin/grep -vE '^#' | sed -e 's/[[:space:]]\?#.*//' | sed -e 's/source[[:space:]]\?//' )"
    # Oh fk we need to evaluate variables in sourced file paths (which implies we need to find the variable definition)

    # Loop over sourced files
    # readarray -t filesArray <<<"${sourcedFiles}"
    # while [[ "${filesArray[#]}" -ne '0' ]]; do
    #     # TODO: finish
    # done

    # TODO: can we first unsource/clear everything? (be careful when clearing env vars. Maybe don't clear them)
    #shellcheck source=./bash/bashrc
    source "${rcFile}"
    fixPathBloat
}

function reloadInputrc()
{
    # Reload readline's inputrc
    bind -f ~/.inputrc
}

function todo()
{
    ind git -c color.grep.linenumber="green" -c color.grep.filename="magenta" grep -inI --color "TODO\|FIXME\|HACK\|WIP" || echo "No matches" # TODO only use ggrep on mac. use grep when gnu grep is default
}

function tally()
{
    echo "not yet implemented"
    # Counts keystrokes entered while running.
    # Used to keep a tally for the user
    # TODO: have a while read loop running.
    #   Increment a var each iteration. Print tally when done
    # input args:
    #   help for help message
    #   -n<int> start on some number
}

# 
function which()
{
    # TODO: take a look at appros and whereis
    # TODO: the is a bug in recursive alias lookup
    # TODO: look into bash's command hashing
    local DOCSTRING=("This function overrides 'which' and 'type' to search aliases, builtins, executables, and functions on the \$PATH"
                     "Usage:"
                     "    which <query>")

    if [[ "${#}" -eq 0 ]]; then
        errprint "${DOCSTRING[@]}"
        return 0
    fi

    local query="${1}"
    local recursionIndent=''
    local recursionCheck=''

    # Args 2 and 3 are for recursion. Can't have only two args. Only 1 or 3 args are acceptable
    if [[ "${#}" -eq 2 ]]; then
        errprint "Error, invalid number of args."
        return 1
    else
        recursionCheck="${2}"
        recursionIndent="${3}"
    fi

    # Check query using 'type'
    if ! typesFound=$(type -at "${query}"); then # TODO: there is a bug here
        
        # If not found, try to use 'file'
        if fileOutput=$(file -E "${query}" 2> /dev/null); then # TODO: 'file' utility on debian seems to always returns 0
            echo "${fileOutput}"
            return 0
        else
            # Otherwise query doesn't exist
            echo "'${query}' is not an alias, builtin, executable, keyword or function on the path."
            return 1
        fi
    fi

    readarray -t typesFoundArray <<<"$typesFound"
    
    # Print "'query' is" with any necessary indentation (Recursion indentation done separately)
    echo -n "${recursionIndent}" # Print indentation from recursion
    if [[ ${#typesFoundArray[@]} -ge 1 ]]; then
        echo "'${query}' is"
        indent="  "
    else
        echo -n "'${query}' is "
        indent=""
    fi

    local filesAlreadyFound='0'

    for t in "${typesFoundArray[@]}"; do

        case "${t}" in

            alias)
                # TODO: can we find where aliases are defined? - like how we show where functions are defined
                # Grab and display what $query is aliased to
                target=$(alias "${query}" | sed "s/alias ${query}=//g") # wont work with back ticks
                echo -n "${recursionIndent}"
                printBlue "${indent}alias "
                echo "${query}=${target}"

                # Recursively check what the target is aliased to
                newQueryNotFixed="${target:1:${#target}-2}" # ${target} is encased in single quotes that we must remove
                newQueryWithPossibleSpace="${newQueryNotFixed/*;/}" # HACK: Remove any chars before ';'. Partial bulletproofing for multi-word aliases
                newQuery="${newQueryWithPossibleSpace/ /}" # Remove space

                # Check for a loop where a -> b -> c -> a. This should never happen in real life
                # TODO: This check will fail if $newquery is a substring of any command in $recursionCheck
                if [[ "${recursionCheck}" == *"${newQuery}"* ]]; then
                    echo -n "${recursionIndent}"
                    printYellow "    WARNING:"
                    echo " circular alias or aliased to something of the same name:"
                    echo -n "${recursionIndent}"
                    echo "    ${recursionCheck//:/ -> } -> ${newQuery}" # print a -> b -> c -> a
                    echo ''
                else
                    # Append to the list that keeps track of the alias chain
                    if [[ -z "${recursionCheck}" ]]; then
                        recursionCheck="${query}:${newQuery}"
                    else
                        recursionCheck="${recursionCheck}:${newQuery}"
                    fi
                    recursionIndent+='    ' # If this changes, be sure to change the decrement too!
                    
                    # Recursively make the check
                    which "${newQuery/ /}" "${recursionCheck}" "${recursionIndent}" # Remove whitespace from first arg 
                fi
                # Reset the variables that keep track of recursion
                    recursionCheck=''
                    recursionIndent="${recursionIndent::-4}" # Decrease indentation level
                ;;
    
            keyword)
                echo -n "${recursionIndent}"
                printBlue "${indent}shell keyword"; echo ""
                ;;

            function)
                # First, the initial type print out
                echo -n "${recursionIndent}"
                printBlue "${indent}function "
                echo -n "${query}()"

                # Next, grab some basic info about the query
                shopt -s extdebug # turn on to allow declare to show file name and line number
                info=$(declare -Ff "${query}")
                shopt -u extdebug # turn back off # TODO: we should check the state of this shopt setting first. Then only turn off if it was off to begin with
                fileName=$(echo "$info" | cut -f3 -d' ')
                lineNum=$(echo "$info" | cut -f2 -d' ')

                # Not going to lie, this is about to get wacky. Ready? Here goes:
                # Each function's documentation is defined by a variable (local to the function) called 'DOCSTRING'.
                # We read the function's definition (declare -f $query), and search for the line that declares the DOCSTRING.
                # Note: 'declare' automatically merges multiline lines into one line. This saves us the work of having to determine where the DOCSTRING ends.
                # The line we grep for contains the entire definition 'local DOCSTRING="foo bar...";'
                # If we find a DOCSTRING, we can pull it into our local scope by 'eval'-ing the output of our grep filter.
                # As soon as we leave the scope containing the 'eval', we blow away the DOCSTRING thanks to the 'local' keyword.        
                if docstringDeclerationLine="$(declare -f "${query}" | /bin/grep -m1 'local DOCSTRING')"; then
                    # Print the file name + line num
                    echo ":${fileName}:${lineNum}"
                    # Add the DOCSTRING to the local scope by 'eval'-ing as is.
                    eval "${docstringDeclerationLine}"
                    # And print. We need printf and 'DOCSTRING[@]' (as opposed to 'DOCSTRING[*]') to print multiline
                    echo -n "${recursionIndent}${indent}"
                    echo '{' # This brace was almost invisible in the line above, so I've put it on its own line
                    printf "${recursionIndent}${indent}${indent}%s\n" "${DOCSTRING[@]}"
                    echo -n "${recursionIndent}${indent}"
                    echo '}' # This brace was almost invisible in the line above, so I've put it on its own line
                else
                    # This function does not have a DOCSTRING
                    # Display only the name of the file that contains the function deceleration
                    echo " is defined in ${fileName}:${lineNum}"
                fi
                ;;

            builtin)
                echo -n "${recursionIndent}"
                printBlue "${indent}shell builtin"; echo ''
                ;;

            file)
                # All the files are listed together. Once we find one, print them all.
                # Any subsequent times through the loop, skip printing any files
                if [[ $filesAlreadyFound -ne 1 ]]; then
                    files=$(type -af "${query}" | grep --color=never '/')
                    readarray -t filesArray <<<"$files"
                    for f in "${filesArray[@]}"; do
                        echo -n "${recursionIndent}"
                        printBlue "${indent}file "
                        echo "${f/*is /}" # Remove prefix when printing
                    done
                    filesAlreadyFound='1'
                fi
                ;;

            *) # Default - should never happen
                printRed "Error,"
                echo " unknown type: ${t}"
                return 1
                ;;
        esac

    done
}

# Override 'test' to print exit status. No more 'test <expression>; echo $?'
function test()
{
    builtin test "$@" && echo 'true' || echo 'false'
}

# Create a directory and cd to it
function mkcd()
{
    mkdir "${1}" || return 1
    cd "${1}" || { echo "${1} created, but cd failed"; return 1; }
}

function path()
{
    local SORT='0'
    local TREE='0'

    # Loop over args
    while (( "$#" ));
    do
        arg="$1"
        case "$arg" in
        's'|'-s'|'sort'|'--sort')
            SORT=1
            ;;

        't'|'-t'|'tree'|'--tree')
            TREE=1
            ;;

        '+'*)
            # Add to path
            inputDir="${arg/+}"
            if [[ -d "${inputDir}" ]]; then
                export PATH="${PATH}:${inputDir}"
            else
                errprint "Error, '${inputDir}' is not a directory."
                return 1
            fi
            ;;

        '-'*)
            # Remove from path
            inputDir="${arg/-}"
            if [[ "${PATH}" -eq *"${inputDir}"* ]]; then
                local tmp="${PATH/${inputDir}}"
                export PATH="${tmp/::/:}" # Remove possible double colon
            else
                errprint "Error, '${inputDir}' was not on the path."
                return 1
            fi
            ;;

        *) # Default case; unknown argument
            errprint "Error, unknown argument '${arg}'."
            return 1
            ;;

        esac
        shift # move on to next arg
    done

    if [[ "${SORT}" -eq 1 && "${TREE}" -eq 1 ]]; then
        errprint "Error, 'sort' and 'tree' options are mutually exclusive."
        return 1
    fi

    if [[ "${SORT}" -eq '1' ]]; then
        # shellcheck disable=SC2001
        echo -e "${PATH//:/\\n}" | sort
    else
        if [[ "${TREE}" -eq 1 ]]; then
            # shellcheck disable=SC2001
            # Echo new line separated paths | replace '.' representation of pwd with actual pwd | display with tree reading from stdin | remove the '.' on first line, replace with '/'
            echo -e "${PATH//:/\\n}" | sed "s|^\.$|$PWD|" | tree -C -F --fromfile . | sed '1s/\./\//'
        else
            # shellcheck disable=SC2001
            echo -e "${PATH//:/\\n}"
        fi
    fi
}
alias spath='path --sort'
alias tpath='path --tree'

function uniqNoSort()
{
    # The default 'uniq' utility only checks adjacent lines and thus is useless with unsorted data.
    # Automatically reads from stream input
    # With help from https://unix.stackexchange.com/questions/11939/how-to-get-only-the-unique-results-without-having-to-sort-data
    awk '!seen[$0]++'
}

function fixPathBloat()
{
    # As of 05/22/2020 the 'reload' command causes the path to be appended to with each reload
    # This function removes duplicates from the path
    fixedPath=''
    for p in $(path | uniqNoSort); do
        fixedPath+="${p}:"
    done
    export PATH="${fixedPath::-1}" # Remove the extra ':' from $fixedPath
}

function ascii()
{
    # Print the ascii table
    # Stolen from github.com/nibalizer/bash-tricks
    ascii | /bin/grep -m1 -A63 --color=never Oct
}

function unicode()
{
    # Print favorite unicode characters
    # Stolen from github.com/nibalizer/bash-tricks
    echo '✓ ™  ♪ ♫ ☃ ° Ɵ ∫'
}

function lintJson()
{
    # Validate json syntax by piping to jq
    # Note: this function is used by ~/scripts/lint.sh to validate json files
    /bin/cat "$1" | jq '.'
}

function findFileOnPath()
{
    # TODO: my 'which' function should make this obsolete
    input="$1"
    for p in ${PATH//:/ }; do
        if [[ -f "${p}/${input}" ]]; then
            echo "${p}/${input}"
            return 0
        fi
    done
    echo "Couldn't find '${input}' on the \$PATH"
    return 1
}

function hist()
{
    # Search history
    history | grep "$1" | /bin/grep -vi "hist\|history" | awk '{printf"%4d  ",$1;for(i=4;i<NF;i++)printf"%s",$i OFS;if(NF)printf"%s",$NF;printf ORS}'
}

# TODO
#rm()
#{
#        /bin/rm $@ || /bin/mdir $@
#}

function uz()
{
    fileName="$1"
    if [[ ! -f "${fileName}" ]]; then
        echo "Error, input file '${fileName}' is not a regular file. Cannot extract" # TODO: send to stderr
        return 1
    fi

    case $1 in
        *.tar.bz2)   tar xjf "${fileName}"   ;;
        *.tar.gz)    tar xzf "${fileName}"   ;;
        *.bz2)       bunzip2 "${fileName}"   ;;
        *.rar)       unrar x "${fileName}"   ;;
        *.gz)        gunzip "${fileName}"    ;;
        *.tar)       tar xf "${fileName}"    ;;
        *.tbz2)      tar xjf "${fileName}"   ;;
        *.tgz)       tar xzf "${fileName}"   ;;
        *.zip)       unzip "${fileName}"     ;;
        *.Z)         uncompress "${fileName}";;
        *.7z)        7z x "${fileName}"      ;;
        *)
            echo "Error, '${fileName}' is of unknown type. Cannot extract" # TODO: send to stderr
            return 1
            ;;
    esac
}
alias unzip='uz'
alias extract='uz'

function diff()
{
    local DOCSTRING="Use git's colored diff"
    if [[ "$#" -eq 0 ]]; then
        errprint "${DOCSTRING[@]}"
        return 0
    fi
    git diff --no-index --color-words "$@"
}

function symlink()
{
    # TODO: add a docstring to each function. The 'which' function should print these when a function is found.
    # TODO: and we should save a database of all docstrings. Then the which function can just read the database.
    #    The 'reload' function could update the database
    local DOCSTRING=("This is a wrapper for 'ln -s' that automatically fills in absolute paths."
                     "Usage:"
                     "    simlink  <take this>  <make link here>")

    # Parse inputs
    if [[ "$#" -eq 0 ]]; then
        errprint "${DOCSTRING[@]}"
        return 0
    fi
    sourcePath="$(realpath "$1")"
    targetPath=$(realpath "$2")

    # Verify source file exists
    builtin test -e "${sourcePath}" || { errprint "Error, '${sourcePath}' DNE"; return -1; }

    # # Verify target's parent dir exists
    # targetDir="$(realpath "$(dirname "${targetPath}")")"
    # builtin test -e "$targetDirr" || errprint ""; return -2; }
    
    # # Link
    # ln -s "${sourcePath}" "${targetPath}"
    # return "$?"
}


# --------------------------------------------------------------------------------
# Math
# --------------------------------------------------------------------------------
# The alias first turns globbing off, then calls the 'math' function. 
# This way, expressions such as '5 * 5' may be entered without '*' being 
# expanded. The function turns globbing back on before exiting.
# Unfortunately, quotation marks or escapes are needed when using parenthesis\
# TODO: before we turn globing off, should we verify it was on? And only turn back on if it was originally on - These functions are all about "can it be done?" instead of "should it be done?" lol
alias math='set -o noglob; math'
function math()
{

    local DOCSTRING=("This is a wrapper for 'ln -s' that automatically fills in absolute paths."
                     "Usage:"
                     "    simlink  <take this>  <make link here>")

    if [[ "$#" -eq 0 ]]; then
        errprint "${DOCSTRING[@]}"
        return 0
    fi

    # Evaluate expressions using the 'bc' utility
    echo "${@}" | bc
    
    # Turn globbing back on 
    set +o noglob
}
alias calculator='math'
alias calc='math'


# --------------------------------------------------------------------------------
# Navigation utilities - I really should look into pushd and popd
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

    # Git fetch if we are in the root of a git repo
    # TODO
    #if [[ -d ./.git ]]; then
    #    expectGitFetchHelper
    #fi
}

function expectGitFetchHelper()
{
    # Send garbage info to 'git fetch' if prompted.
    /usr/bin/expect <<EOD
        set timeout 1
        spawn git fetch
        expect "Username for 'https://github.com': "
        send -- "user\r"
        expect "Password for 'https://user@github.com': "
        send -- "pass\r"
        expect eof 
EOD
        # My syntax highlight doesn't register EOD with any indentation

}




back() # TODO: look into $OLDPWD
{
    prev_tmp="$(pwd)"
    builtin cd "$PREVIOUS_DIR" && PREVIOUS_DIR="$prev_tmp"
    helper_lsAfterCD
}

# Show directory command "back" will take us to 
# back?()
# {
#     ind echo "Last visited dir: $PREVIOUS_DIR  (use cmd 'back' to jump here)"
# }

# "Drop a pin" to remember this dir for later # TODO: come up with a way to save/get to multiple locations
# TODO: look into pushd, popd, and dirs. These probably already do what I'm looking for
dropPin()
{
        SAVE_THIS_DIR="$(pwd)"
        export SAVE_THIS_DIR
        ind echo "${SAVE_THIS_DIR} saved"
}

# pin?() # Show pinned locations # TODO: add support for multiple pins
# {
#         ind echo "Pinned dirs: ${SAVE_THIS_DIR}"
# }

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
            ind ls --color=always --group-directories-first -Cqa
            ;;
        *)
            ind ls --color=always --group-directories-first -Cqa
    esac
          # TODO: like with the ls alias, if ~file found, print filename(~)
    
}

# ?() # TODO: come up with a better name for this function. Use '?' as the name of a new function that displays a quick snapshot of intresting stuff
# #               such as host name, network name, storage stuff, cpu usage and stuff like that
# {
#     # Display current directory, last used directory, and any pinned directories
#     ind echo "Current dir: $(pwd)"
#     'back?' # back ticks to allow a question mark in a command name
#     'pin?'
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
    # TODO: This function may break if user is removing multiple files

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
# Mac Window Manager Functions
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
# Used in bash var PS1
# TODO: pull prompt stuff into its own file
gitPromptInfo()
{
    # As a way to minimize overhead from subshells, it would be cool to 
    #   run all subshells first before anything else.
    #   Run them in parallel with '&', then use 'wait'
    #
    # This could be an issue when the computer is under a heavy load
    # but otherwise would be good

    status="$(git status 2> /dev/null)"

    # Only echo info if we are in a git repo
    if [[ -n "${status}" ]]; then
        readarray -t statusArray <<<"${status}"
        prompt='('

        # Add the branch name
        prompt+="${statusArray[0]//On branch /}|"

        # Check the second line of status message for commit diff with origin
        # TODO: handle the cases that don't do anything
        case "${statusArray[1]}" in
            '')
                # No commits yet
                ;;

            'nothing to commit, working tree clean')
                # No remote branch associated with this local branch
                prompt+='L'
                prompt+='|'
                ;;

            'Your branch is up to date with'*)
                ;;

            'Changes not staged for commit:'|'Changes to be committed:')
                ;;

            *'have diverged,')
                # Take the third line, replace all non-numbers with whitespace
                nums="${statusArray[2]//[^[:digit:]]/ }"
                # Turn into whitespace-separated array
                read -ra commitDiffs <<<"$nums"
                prompt+='↑'
                prompt+="${commitDiffs[0]}"
                prompt+='↓'
                prompt+="${commitDiffs[1]}"
                prompt+='|'
                ;;

            'Your branch is ahead of'*)
                prompt+='↑'
                # Take the second line and remove all non-digits
                prompt+="${statusArray[1]//[^[:digit:]]/}"
                prompt+='|'
                ;;

            'Your branch is behind'*)
                prompt+='↓'
                # Take the second line and remove all non-digits
                prompt+="${statusArray[1]//[^[:digit:]]/}"
                prompt+='|'
                ;;

            *) # Default
                echo 'There is an error with your gitPromptInfo function'
                return 1
                ;;
        esac

        # Check for uncommitted changes
        if [[ "${statusArray[-1]}" != 'nothing to commit, working tree clean' ]]; then
            prompt+='*'
        else
            prompt+='✔'
        fi

        prompt+=')'
        echo "$prompt"

    fi
}
