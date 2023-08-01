# zsh and bash functions

# --------------------------------------------------------------------------------
# Safety Settings
# --------------------------------------------------------------------------------
alias rm='echo "Use \"trash\" instead (or \"\\\rm\" to force)"; false'
# function rm()
# {
#     local DOCSTRING=("Back up before rm'ing"
#                       ""
#                       "Usage:"
#                       "    rm <file1> <file2> ..."
#                       ""
#                       "Files are backed up to the env's \$TRASHCAN var or ~/.trash if it doesn't exist"
#                       "Use the real rm (/bin/rm) for anything more advanced"
#     )
#     if [[ "$#" -eq 0 ]]; then
#         errprint "${DOCSTRING[@]}"
#         return 0
#     fi
#
#     if [[ -z "${TRASHCAN}" ]]; then
#         export TRASHCAN="${HOME}/.trash"
#     fi
#
#
#     if [[ ! -d "${TRASHCAN}" ]]; then
#         mkdir -p "${TRASHCAN}"
#     fi
#
#     # Parse args
#     args=("${@}")
#     for arg in "${args[@]}"; do
#         case "$arg" in
#             -*)
#                 # Ignore flags. Habbit to call '-rf' from standard rm
#                 ;;
#             *)
#                 # mv files
#                 timestamp="$(date +%d-%m-%Y_%H-%M-%S)"
#                 original="${arg}"
#                 new="${TRASHCAN}/$(basename "${original}")_${timestamp}"
#                 echo "Moving trash can..."
# 		# '-n' flag is mac and linux compatible and stops clobbering
#                 $(which mv) -n "${original}" "${new}"
#                 ;;
#         esac
#         shift
#     done
#
# }

# function cp()
# {
#     local DOCSTRING=("cp but throws error if target exists"
#                         ""
#                         "Usage:"
#                         "    cp <source> <target>"
#                         "Use the real cp (/bin/cp) for anything more advanced"
#     )
#     if [[ "$#" -eq 0 ]]; then
#         errprint "${DOCSTRING[@]}"
#         return 0
#     fi

#     if [[ "${#}" -ne "2" ]]; then
#         echo "Arg error"
#         echo "${DOCSTRING}"
#     fi

#     source="${1}"
#     target="${2}"

#     realtargetpath="$(realpath "${target}")"
#     if [[ -e "${realtargetpath}" ]]; then
#         echo "Error, target (${realtargetpath}) exists"
#         return 1
#     fi

#     eval "/bin/cp --no-clobber ${source} ${target}"
# }

# function mv()
# {
#     if [[ "${#}" -ne "2" ]]; then
#         echo "Arg error"
#         echo "Usage:"
#         echo "    mv <source> <target>"
#         "Use the real mv (/bin/mv) for anything more advanced"
#     fi
#     source="${1}"
#     target="${2}"

#     realtargetpath="$(realpath "${target}")"
#     if [[ -e "${realtargetpath}" ]]; then
#         echo "Error, target (${realtargetpath}) exists"
#         return 1
#     fi

#     /bin/mv --no-clobber "${source}" "${target}"
# }

# --------------------------------------------------------------------------------
# Color Utilities
# TODO: color functions should have a newline flag
# ---------------------------------------------------------------------------------
printRed() {
	# Use argument or standard input. Reads from stdin unless an arg is given
	if [[ $# -eq 0 ]]; then
		while IFS= read -r line; do
			echo -en "${RED}${line}${END_COLOR}"
		done
	else
		echo -en "${RED}${*}${END_COLOR}"
	fi
}

printGreen() {
	# Use argument or standard input. Reads from stdin unless an arg is given
	if [[ $# -eq 0 ]]; then
		while IFS= read -r line; do
			echo -en "${GREEN}${line}${END_COLOR}"
		done
	else
		echo -en "${GREEN}${*}${END_COLOR}"
	fi
}

printYellow() {
	# Use argument or standard input. Reads from stdin unless an arg is given
	if [[ $# -eq 0 ]]; then
		while IFS= read -r line; do
			echo -en "${YELLOW}${line}${END_COLOR}"
		done
	else
		echo -en "${YELLOW}${*}${END_COLOR}"
	fi
}

printBlue() {
	# Use argument or standard input. Reads from stdin unless an arg is given
	if [[ $# -eq 0 ]]; then
		while IFS= read -r line; do
			echo -en "${BLUE}${line}${END_COLOR}"
		done
	else
		echo -en "${BLUE}${*}${END_COLOR}"
	fi
}

printBlack() {
	# Use argument or standard input. Reads from stdin unless an arg is given
	if [[ $# -eq 0 ]]; then
		while IFS= read -r line; do
			echo -en "${BLACK}${line}${END_COLOR}"
		done
	else
		echo -en "${BLACK}${*}${END_COLOR}"
	fi
}

printPurple() {
	# Use argument or standard input. Reads from stdin unless an arg is given
	if [[ $# -eq 0 ]]; then
		while IFS= read -r line; do
			echo -en "${PURPLE}${line}${END_COLOR}"
		done
	else
		echo -en "${PURPLE}${*}${END_COLOR}"
	fi
}

printCyan() {
	# Use argument or standard input. Reads from stdin unless an arg is given
	if [[ $# -eq 0 ]]; then
		while IFS= read -r line; do
			echo -en "${CYAN}${line}${END_COLOR}"
		done
	else
		echo -en "${CYAN}${*}${END_COLOR}"
	fi
}

printBold() {
	# Use argument or standard input. Reads from stdin unless an arg is given
	if [[ $# -eq 0 ]]; then
		while IFS= read -r line; do
			echo -en "${BOLD_ON}${line}${BOLD_OFF}"
		done
	else
		echo -en "${BOLD_ON}${*}${END_COLOR}"
	fi
}

printUnderline() {
	# Use argument or standard input. Reads from stdin unless an arg is given
	if [[ $# -eq 0 ]]; then
		while IFS= read -r line; do
			echo -en "${UNDERLINE_ON}${line}${UNDERLINE_OFF}"
		done
	else
		echo -en "${UNDERLINE_ON}${*}${END_COLOR}"
	fi
}

# --------------------------------------------------------------------------------
# Misc Utilities
# --------------------------------------------------------------------------------
function tree() {
	if [[ $# -eq 0 ]]; then
		lsd --tree
	else
		lsd --tree --depth "${@}"
	fi
}

function web-search() {
	if [[ $# -eq 0 ]]; then
		echo "Usage: web-search <search term>"
		return 1
	fi
	local search_term="${*}"
	# Replace spaces
	local search_term="${search_term// /+}"
	local search_url="https://www.duckduckgo.com/?q=${search_term}"
	xdg-open "${search_url}"
}
alias web='web-search'

function wireguard() {
	local error_msg=("Usage:" "wireguard <start|stop|status")
	if [[ $# -eq 0 ]]; then
		sudo systemctl status --no-pager wireguard-wg_sharper
		return 0
	elif [[ $# -gt 1 ]]; then
		echo "${error_msg[@]}"
		return 2
	fi

	case "$1" in
	'--help' | 'help')
		echo "${error_msg[@]}"
		return 0
		;;
	'start')
		sudo systemctl start wireguard-wg_sharper.service
		;;

	'stop')
		sudo systemctl stop wireguard-wg_sharper.service
		;;

	'status')
		sudo systemctl status --no-pager wireguard-wg_sharper.service
		return 0
		;;

	*)
		echo "${error_msg[@]}"
		return 2
		;;
	esac
	# Show status after operation
	sudo systemctl status --no-pager wireguard-wg_sharper
}

# function which()
# {
#     # TODO: fix for zsh
#     # TODO: its time to re-write this in a language that is easier to maintain. But then we will lose functions and aliases :/
#     # TODO: take a look at appros and whereis
#     # TODO: look into bash's command hashing
#     local DOCSTRING=("This function overrides 'which' and 'type' to search aliases, builtins, executables, and functions on the \$PATH"
#                         "Usage:"
#                         "    which <query>")

#     if [[ "${#}" -eq 0 ]]; then
#         errprint "${DOCSTRING[@]}"
#         return 0
#     fi

#     query="${1}"
#     recursionIndent=''
#     recursionCheck=''

#     # Args 2 and 3 are for recursion. Can't have only two args. Only 1 or 3 args are acceptable
#     if [[ "${#}" -eq 2 ]]; then
#         errprint "Error, invalid number of args."
#         return 1
#     else
#         recursionCheck="${2}"
#         recursionIndent="${3}"
#     fi

#     # Check query using 'type'
#     # TODO: zsh's type is different than bash's
#     if ! typesFound=$(type -at "${query}"); then # TODO: there is a bug here

#         # If not found, try to use 'file'
#         if fileOutput=$(file -E "${query}" 2> /dev/null); then # TODO: 'file' utility on debian seems to always returns 0
#             echo "${fileOutput}"
#             return 0
#         else
#             # Otherwise query doesn't exist

#             if [[ -n "${recursionIndent}" ]]; then
#                 # Do not print error message if got here through recursion
#                 return 1
#             fi

#             echo "${recursionIndent}'${query}' is not an alias, builtin, executable, keyword or function on the path."

#             quotes=("It looks like the command you're searching for does not exist."
#                     "Impossible. Perhapses the archives are incomplete?"
#                     "If an item does not appear in our records it does not exist!")
#             index="$((RANDOM % 3))"
#             echo "${recursionIndent}    ${quotes[${index}]}"

#             return 1
#         fi
#     fi

#     readarray -t typesFoundArray <<<"$typesFound"

#     # Print "'query' is" with any necessary indentation (Recursion indentation done separately)
#     echo -n "${recursionIndent}" # Print indentation from recursion
#     if [[ ${#typesFoundArray[@]} -ge 1 ]]; then
#         echo "'${query}' is"
#         indent="  "
#     else
#         echo -n "'${query}' is "
#         indent=""
#     fi

#     filesAlreadyFound='0'

#     for t in "${typesFoundArray[@]}"; do

#         case "${t}" in

#             alias)
#                 # TODO: can we find where aliases are defined? - like how we show where functions are defined
#                 # Grab and display what $query is aliased to
#                 target=$(alias "${query}" | sed "s/alias ${query}=//g") # wont work with back ticks
#                 echo -n "${recursionIndent}"
#                 printBlue "${indent}alias "
#                 echo "${query}=${target}"

#                 # Recursively check what the target is aliased to
#                 newQuery="${target:1:${#target}-2}" # ${target} is encased in single quotes that we must remove

#                 # Check for a loop where a -> b -> c -> a. This should never happen in real life
#                 # TODO: This check will fail if $newquery is a substring of any command in $recursionCheck
#                 if [[ "${recursionCheck}" == *"${newQuery}"* ]]; then
#                     echo -n "${recursionIndent}"
#                     printYellow "    WARNING:"
#                     echo " circular alias or aliased to something of the same name:"
#                     echo -n "${recursionIndent}"
#                     echo "    '${recursionCheck//:/\' -> \'}' -> '${newQuery}'" # print 'a' -> 'b' -> 'c' -> 'a'
#                     echo ''
#                 else
#                     # Append to the list that keeps track of the alias chain
#                     if [[ -z "${recursionCheck}" ]]; then
#                         recursionCheck="${query}:${newQuery}"
#                     else
#                         recursionCheck="${recursionCheck}:${newQuery}"
#                     fi
#                     recursionIndent+='    ' # If you ever change this be sure to change the decrement level as well!

#                     # Replace any '|' or ';' with spaces. This way, these chars become a part separator and aren't
#                     newQuery="${newQuery//;/' '}"
#                     newQuery="${newQuery//\|/' '}"

#                     # Recursively check each part
#                     readarray -t newQueryArray <<<"${newQuery// /$'\n'}"
#                     for q in "${newQueryArray[@]}"; do

#                         # Skip any empty strings
#                         if [[ -z "${q}" || "${q}" == ' ' ]]; then
#                             continue
#                         fi

#                         # Skip any parts starting with a dash. 'type' tries to read these as flags
#                         if [[ "${q:0:1}" == '-' ]]; then
#                             continue
#                         fi

#                         # Stop a false positive circular dependency check that occurred when
#                         #    alias a="x --flag a" and we parse the 'a' at the end
#                         if [[ "${q}" == "${query}" ]]; then
#                             continue
#                         fi

#                         which "${q}" "${recursionCheck}" "${recursionIndent}" # Remove whitespace from first arg
#                     done

#                 fi
#                 # Reset the variables that keep track of recursion
#                     recursionCheck=''
#                     recursionIndent="${recursionIndent::-4}" # Decrease indentation level
#                 ;;

#             keyword)
#                 echo -n "${recursionIndent}"
#                 printBlue "${indent}shell keyword"; echo ""
#                 ;;

#             function)
#                 # First, the initial type print out
#                 echo -n "${recursionIndent}"
#                 printBlue "${indent}function "
#                 echo -n "${query}()"

#                 # Next, grab some basic info about the query
#                 extdebugInitialState="$(shopt -p extdebug)" # Save the initial state of shopt setting
#                 shopt -s extdebug # turn on to allow declare to show file name and line number
#                 info=$(declare -Ff "${query}")
#                 eval "${extdebugInitialState}" # Revert shopt setting back to initial state
#                 fileName=$(echo "$info" | cut -f3 -d' ')
#                 lineNum=$(echo "$info" | cut -f2 -d' ')

#                 # Not going to lie, this is about to get wacky. Ready? Here goes:
#                 # Each function's documentation is defined by a variable (to the function) called 'DOCSTRING'.
#                 # We read the function's definition (declare -f $query), and search for the line that declares the DOCSTRING.
#                 # Note: 'declare' automatically merges multiline lines into one line. This saves us the work of having to determine where the DOCSTRING ends.
#                 # The line we grep for contains the entire definition 'DOCSTRING="foo bar...";'
#                 # If we find a DOCSTRING, we can pull it into our scope by 'eval'-ing the output of our grep filter.
#                 # As soon as we leave the scope containing the 'eval', we blow away the DOCSTRING thanks to the 'local' keyword (thats the wacky part)
#                 if docstringDeclerationLine="$(declare -f "${query}" | /bin/grep -m1 'DOCSTRING')"; then
#                     # Print the file name + line num
#                     echo ":${fileName}:${lineNum}"
#                     # Add the DOCSTRING to the scope by 'eval'-ing as is.
#                     eval "${docstringDeclerationLine}"
#                     # And print. We need printf and 'DOCSTRING[@]' (as opposed to 'DOCSTRING[*]') to print multiline
#                     echo -n "${recursionIndent}${indent}"
#                     echo '{' # This brace was almost invisible in the line above, so I've put it on its own line
#                     printf "${recursionIndent}${indent}${indent}%s\n" "${DOCSTRING[@]}"
#                     echo -n "${recursionIndent}${indent}"
#                     echo '}' # This brace was almost invisible in the line above, so I've put it on its own line
#                 else
#                     # This function does not have a DOCSTRING
#                     # Display only the name of the file that contains the function deceleration
#                     echo " is defined in ${fileName}:${lineNum}"
#                 fi
#                 ;;

#             builtin)
#                 echo -n "${recursionIndent}"
#                 printBlue "${indent}shell builtin"; echo ''
#                 ;;

#             file)
#                 # All the files are listed together. Once we find one, print them all.
#                 # Any subsequent times through the loop, skip printing any files
#                 if [[ $filesAlreadyFound -ne 1 ]]; then
#                     # TODO: zsh's type is different than bash's
#                     files=$(type -af "${query}" | grep --color=never '/')
#                     readarray -t filesArray <<<"$files"
#                     for f in "${filesArray[@]}"; do
#                         echo -n "${recursionIndent}"
#                         printBlue "${indent}file "
#                         echo "${f/*is /}" # Remove prefix when printing
#                     done
#                     filesAlreadyFound='1'
#                 fi
#                 ;;

#             *) # Default - should never happen
#                 printRed "Error,"
#                 echo " unknown type: ${t}"
#                 return 1
#                 ;;
#         esac

#     done
# }

function barfix() {
	# TODO: once I've figured out why waybar runs a second time on startup reove this function
	local num_bars="$(pgrep waybar | wc -l)"
	if [[ ${num_bars} -gt 1 ]]; then
		kill "$(pgrep waybar | tail -n 1)"
	else
		echo "There is not a redundant waybar running"
		return 1
	fi
}

function page() {
	# Run input command piped to a pager
	# Must use 'eval' so that aliases are expanded
	eval "$@ | ${PAGER}"
}

function hist() {
	# Search input in history. Show all history if no input arg provided
	# Must use 'eval' so that the 'history' alias is expanded
	if [[ -z ${@} ]]; then
		eval 'history'
	else
		eval "history | grep $@"
	fi
}

function phist() {
	# View shell history in a pager, but start at bottom
	# Must use 'eval' so that the 'history' alias is expanded
	eval "history | less +G"
}

function cht() {
	curl "cht.sh/${1}" 2>/dev/null | less --RAW-CONTROL-CHARS
}

function todo() {
	ind /usr/bin/git -c color.grep.linenumber="green" -c color.grep.filename="magenta" grep -inI --color "TODO\|FIXME\|HACK\|WIP" || echo "No matches" # TODO only use ggrep on mac. use grep when gnu grep is default
}

function cat() {
	case "$#" in
	0 | 1)
		bat "${@}"
		;;

	*)
		# Fall back to default cat if more than 1 arg passed
		# TODO: this function should take '--help and expline how it works'
		/bin/cat $@
		;;
	esac
}

function ascii() {
	# Print the ascii table
	# Stolen from github.com/nibalizer/bash-tricks
	ascii | /bin/grep -m1 -A63 --color=never Oct
}

# Overide cd
function cd() {
	if [[ $# -eq '0' ]]; then
		builtin cd
	else
		builtin cd "$*" && ind -- sh -c 'lsd | column' # TODO: figure out why lsd ran under 'ind' is not automatically doing its own columns
	fi
}

# Create a directory and cd to it
function mkcd() {
	# TODO: take mkdir args like '-p'
	mkdir "${1}" || {
		echo "mkdir ${1} failed"
		return 1
	}
	cd "${1}" || {
		echo "${1} created, but cd failed"
		return 1
	}
}

function path() {
	local SORT='0'
	local TREE='0'

	# Loop over args
	while (("$#")); do
		arg="$1"
		case "$arg" in
		's' | '-s' | 'sort' | '--sort')
			SORT=1
			;;

		't' | '-t' | 'tree' | '--tree')
			TREE=1
			;;

		'+'*)
			# Add to path
			inputDir="${arg/+/}"
			if [[ -d ${inputDir} ]]; then
				export PATH="${PATH}:${inputDir}"
			else
				errprint "Error, '${inputDir}' is not a directory."
				return 1
			fi
			;;

		'-'*)
			# Remove from path
			inputDir="${arg/-/}"
			if [[ ${PATH} -eq *"${inputDir}"* ]]; then
				local tmp="${PATH/${inputDir}/}"
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

	if [[ ${SORT} -eq 1 && ${TREE} -eq 1 ]]; then
		errprint "Error, 'sort' and 'tree' options are mutually exclusive."
		return 1
	fi

	if [[ ${SORT} -eq '1' ]]; then
		# shellcheck disable=SC2001
		echo -e "${PATH//:/\\n}" | sort
	else
		if [[ ${TREE} -eq 1 ]]; then
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

function uz() {
	fileName="$1"
	if [[ ! -f ${fileName} ]]; then
		echo "Error, input file '${fileName}' is not a regular file. Cannot extract" # TODO: send to stderr
		return 1
	fi

	case $1 in
	*.tar.bz2) tar xjf "${fileName}" ;;
	*.tar.gz) tar xzf "${fileName}" ;;
	*.bz2) bunzip2 "${fileName}" ;;
	*.rar) unrar x "${fileName}" ;;
	*.gz) gunzip "${fileName}" ;;
	*.tar) tar xf "${fileName}" ;;
	*.tbz2) tar xjf "${fileName}" ;;
	*.tgz) tar xzf "${fileName}" ;;
	*.zip) unzip "${fileName}" ;;
	*.Z) uncompress "${fileName}" ;;
	*.7z) 7z x "${fileName}" ;;
	*)
		echo "Error, '${fileName}' is of unknown type. Cannot extract" # TODO: send to stderr
		return 1
		;;
	esac
}
alias extract='uz'

# ----------------
# Git
# ----------------
function igit() {
	# Use fzf to pick from a list of forgit options
	local option="$(git-forgit | sed '1,3d' | fzf -1 -q "$1" | awk '{print $1}')"
	[ -n "${option}" ] && git-forgit "${option}"
}
alias ig='igit'

# ---------------
# Zsh Hooks
# https://zsh.sourceforge.io/Doc/Release/Functions.html#Special-Functions
# ---------------
function precmd() {
	# Echo a newline after every command, before the next prompt is rendered
	# By defining this function withing this function, the very first prompt will not have a pre-pended newline
	function precmd() {
		echo ''
	}
}

function clear() {
	# This discusting function is needed to prevend a newline before the prompt immediatly after the screen is cleared
	function precmd() {
		function precmd() {
			# Echo a newline after every command, before the next prompt is rendered
			echo ''
		}
	}
	command clear
}

# ---------------
# Shims
# ---------------
# TODO: fix
#function git(){
# Shim for git
# Created automatically by /home/agaia/repo/personal/org/shim/target/debug/shim
#    from config file /home/agaia/.config/shim/shims/git.yaml
#    at 2023-01-01 10:11:27
#    shim exec -- git "$@"
#}
#function task(){
# Shim for task
# Created automatically by /home/agaia/repo/personal/org/shim/target/debug/shim
#    from config file /home/agaia/.config/shim/shims/task.yaml
#    at 2023-01-01 10:11:27
#    shim exec -- task "$@"
#}
