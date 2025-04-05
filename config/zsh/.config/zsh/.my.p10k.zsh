function prompt_show_arch() {
	if [[ "$(git rev-parse --is-inside-work-tree 2>/dev/null)" == "true" ]]; then
		p10k segment -b 2 -f 'green' -t "$(basename $(git rev-parse --show-toplevel))"
	fi
}

typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
    # =========================[ Line #1 ]=========================
    context                   # user@host
    dir                       # current directory
	show_arch
    vcs                       # git status
    command_execution_time    # previous command duration
    # =========================[ Line #2 ]=========================
    newline                   # \n
    virtualenv                # python virtual environment
    prompt_char               # prompt symbol
)

# shorten current working directory
typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=default
typeset -g POWERLEVEL9K_SHORTEN_DIR_LENGTH=3
typeset -g POWERLEVEL9K_SHORTEN_DELIMITER='..'
typeset -g POWERLEVEL9K_DIR_MAX_LENGTH=32
 
