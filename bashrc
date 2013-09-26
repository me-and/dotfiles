# This script based in part on the one that was distributed with Debian

# Bail out if we're not running interactively.
if [[ $- != *i* ]]; then
    return
fi

# Don't add lines that start with a space or which duplicate the previous line
# to the bash history.
HISTCONTROL=ignoreboth

# Enable bash completion, but only if it hasn't been enabled already -- it's
# done automatically in Cygwin and is slow, so we don't want it twice!
if [[ -z $BASH_COMPLETION && -r /etc/bash_completion ]] && ! shopt -oq posix
then
    . /etc/bash_completion
fi

# Append to the history file rather than overwriting it.
shopt -s histappend

# Check the window size after each command, updating LINES and COLUMNS.
shopt -s checkwinsize

# Expand ** for directory parsing
shopt -s globstar

# Make less more friendly
if [[ -x /usr/bin/lesspipe ]]; then
    eval "$(lesspipe)"
fi

# ANSI escapes for prompts
PROMPT_RESET='\[\e[0m\]'
PROMPT_BLINK='\[\e[5m\]'
PROMPT_BOLD='\[\e[1m\]'
PROMPT_UNBOLD='\[\e[22m\]'
PROMPT_UNBLINK='\[\e[25m\]'
PROMPT_BLACK='\[\e[30m\]'
PROMPT_RED='\[\e[31m\]'
PROMPT_GREEN='\[\e[32m\]'
PROMPT_YELLOW='\[\e[33m\]'
PROMPT_BLUE='\[\e[34m\]'
PROMPT_MAGNETA='\[\e[35m\]'
PROMPT_CYAN='\[\e[36m\]'
PROMPT_WHITE='\[\e[37m\]'
PROMPT_UNCOLOUR='\[\e[39m\]'
PROMPT_BG_BLACK='\[\e[40m\]'
PROMPT_BG_RED='\[\e[41m\]'
PROMPT_BG_GREEN='\[\e[42m\]'
PROMPT_BG_YELLOW='\[\e[43m\]'
PROMPT_BG_BLUE='\[\e[44m\]'
PROMPT_BG_MAGNETA='\[\e[45m\]'
PROMPT_BG_CYAN='\[\e[46m\]'
PROMPT_BG_WHITE='\[\e[47m\]'
PROMPT_BG_UNCOLOUR='\[\e[49m\]'

# Now we can set the prompt!  Store it in OLD_PS1, too, in case I want to hack
# around with it.
PS1="$PROMPT_RESET"  # Start by resetting terminal colours
PS1="$PS1\\[\\e]0;\\h:\\w\\a\\]"  # Terminal title
PS1="$PS1\\n$PROMPT_GREEN\\u@\\h $PROMPT_YELLOW\\w"  # Host and path
if [[ $(type -t __git_ps1) == function ]]; then
    PS1="$PS1$PROMPT_RED\$(__git_ps1)"
fi
PS1="$PS1 $PROMPT_BLUE\\D{%a %e %b %T}"
PS1="$PS1$PROMPT_UNCOLOUR\\n\\$ "  # Finish, newline, prompt
OLD_PS1=$PS1

# For good measure, a function for setting the terminal emulator title.
set_terminal_title () {
    echo -e '\e]0;'"$@"'\a'
}

# Colours for ls
if [[ -x /usr/bin/dircolors ]]; then
    if [[ -r ~/.dircolors ]]; then
        eval "$(dircolors -b ~/.dircolors)"
    else
        eval "$(dircolors -b)"
    fi
fi

# And colour the output of useful commands
alias ls='ls --color=auto'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

# Editor
export VISUAL=/usr/bin/vim

# And pick up the tip of the Python Markdown module
export PYTHONPATH=/home/add/vcs/ext/Python-Markdown

# Simple random number generator.  Not even vaguely secure.
function rand {
    echo $(( (RANDOM % $1) + 1 ))
}

# Tree grep.  The final argument should be the file glob pattern to use, as for
# use in a call to find.  Beware using wildcards, eg *; these should be quoted
# else they'll be expanded before find gets to them.
function tgrep {
    # Clear out variables from previous invocations
    unset greparg
    unset glob

    # Check there's at least two arguments (term to search for and file glob)
    if (( $# < 2 ))
    then
        echo 'Insufficient arguments to tgrep' >&2
        return 1
    fi

    # All bar the last argument will be passed to grep.
    for (( ii=0 ; $# > 1 ; ii++ ))
    do
        greparg[ii]="$1"
        shift
    done

    # The last argument is the file glob for find to use.
    glob="$1"

    # And run the command
    find * -type f -name "$glob" -exec grep "${greparg[@]}" {} +
}

# Helper function to check the big glowing ball o'doom
alias CheckBuild="curl -sS http://tamvmcc1:8080/cruisecontrol/rss | grep -q '^<title>perimeta passed .*</title>\$'"
function check_doom {
    CheckBuild && echo "Ball o'doom's happy." >&2 && return 0

    echo "The big glowing ball o'doom says no." >&2
    echo -n "Continue anyway? [y/N] " >&2

    read resp
    [[ ($resp == y) || ($resp == Y) ]] && return 0

    return 1
}
function git {
    if [[ (($1 == svn) && ($2 == dcommit)) || ($1 == sci) ]]; then
        check_doom && command git "$@"
    else
        command git "$@"
    fi
}
function svn {
    if [[ ($1 == ci) || ($1 == commit) ]]; then
        check_doom && command svn "$@"
    else
        command svn "$@"
    fi
}

# Helper function for copying ID to a remote system then connecting to it.
function ssh-cp-connect {
    ssh-copy-id "$@" && ssh "$@"
}

# Function for quick creation of an issue directory
function create_issue_dir {
    mkdir ~/isslocal/issue$1
    cd ~/isslocal/issue$1
    ln -s ~/issues/issue$1
}

# Set up DISPLAY so X works
export DISPLAY=:0.0

# Helper functions to start tasks in the background
function gitk {
    command gitk "$@" &
    disown
}
function vs {
    command vs "$@" &
    disown
}

# Helper function for markdown for Metacom articles
alias metadown="markdown -x 'headerid(forceid=True,level=3)'"

# Run processes at a high priority
alias unnice='nice -n -10'

# Get the Windows-style pwd
alias wpwd='cygpath -w $(pwd)'
