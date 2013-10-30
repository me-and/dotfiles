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

# ANSI escapes sequences
ANSI_RESET='[0m'
ANSI_BLINK='[5m'
ANSI_BOLD='[1m'
ANSI_UNBOLD='[22m'
ANSI_UNBLINK='[25m'
ANSI_BLACK='[30m'
ANSI_RED='[31m'
ANSI_GREEN='[32m'
ANSI_YELLOW='[33m'
ANSI_BLUE='[34m'
ANSI_MAGNETA='[35m'
ANSI_CYAN='[36m'
ANSI_WHITE='[37m'
ANSI_UNCOLOUR='[39m'
ANSI_BG_BLACK='[40m'
ANSI_BG_RED='[41m'
ANSI_BG_GREEN='[42m'
ANSI_BG_YELLOW='[43m'
ANSI_BG_BLUE='[44m'
ANSI_BG_MAGNETA='[45m'
ANSI_BG_CYAN='[46m'
ANSI_BG_WHITE='[47m'
ANSI_BG_UNCOLOUR='[49m'

# Determine the colour to display the hostname.  Useful for determining at a
# glance what system I'm connected to!
case $(hostname) in
    PC4306)
        hostname_colour=$ANSI_GREEN
        pwd_colour=$ANSI_YELLOW
        git_colour=$ANSI_RED
        timestamp_colour=$ANSI_BLUE
        ;;
    northrend.tastycake.net)
        hostname_colour=$ANSI_CYAN
        pwd_colour=$ANSI_GREEN
        git_colour=$ANSI_BLUE
        timestamp_colour=$ANSI_RED
        ;;
    Hendrix)
        hostname_colour=$ANSI_GREEN
        pwd_colour=$ANSI_MAGNETA
        git_colour=$ANSI_YELLOW
        timestamp_colour=$ANSI_CYAN
        ;;
    *)
        hostname_colour=$ANSI_WHITE
        pwd_colour=$ANSI_YELLOW
        git_colour=$ANSI_RED
        timestamp_colour=$ANSI_BLUE
        ;;
esac

# Now we can set the prompt!  Store it in OLD_PS1, too, in case I want to hack
# around with it.
PS1="\[\e$ANSI_RESET\]"  # Start by resetting terminal colours
PS1="$PS1\\[\\e]0;\\h:\\w\\a\\]"  # Terminal title
PS1="$PS1\\n\[\e\$hostname_colour\]\\u@\\h "  # Host
PS1="$PS1\[\e\$pwd_colour\]\\w"  # Working directory
if [[ $(type -t __git_ps1) == function ]]
then
    PS1="$PS1\[\e\$git_colour\]\$(__git_ps1)"
fi
PS1="$PS1 \[\e\$timestamp_colour\]\\D{%a %e %b %T}"
PS1="$PS1\[\e$ANSI_UNCOLOUR\]\\n\\$ "  # Finish, newline, prompt
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

# And pick up the tip of the Python Markdown module, assuming it exists.
#
# @@TODO Make this more friendly somehow -- it shouldn't be so dependent on the
# layout of my code trees.
if [[ -d ~/vcs/ext/Python-Markdown &&
      -r ~/vcs/ext/Python-Markdown &&
      -x ~/vcs/ext/Python-Markdown ]]; then
    export PYTHONPATH=/home/add/vcs/ext/Python-Markdown
fi

# Simple random number generator.  Not even vaguely secure.
function rand {
    echo $(( (RANDOM % $1) + 1 ))
}

# Tree grep.  The final argument should be the file glob pattern to use, as for
# use in a call to find.  Beware using wildcards, eg *; these should be quoted
# else they'll be expanded before find gets to them.
function tgrep {
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

    unset greparg
    unset glob
}

# Helper function to check the big glowing ball o'doom.
#
# @@TODO Disable this where it doesn't make sense.  Hive off into a per-PC
# script?
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
#
# @@TODO Should probably be hived off; in places where I don't regularly
# connect to new systems, I don't want this to be a trivial operation.
function ssh-cp-connect {
    ssh-copy-id "$@" && ssh "$@"
}

# Function for quick creation of an issue or SFR directory
#
# @@TODO Should definitely be hived off
function create_issue_dir {
    mkdir ~/isslocal/issue$1
    cd ~/isslocal/issue$1
    ln -s ~/issues/issue$1
}
function create_sfr_dir {
    mkdir ~/sfrlocal/sfr$1
    cd ~/sfrlocal/sfr$1
    ln -s ~/sfrs/sfr$1
}

# Set up DISPLAY so X works
#
# @@TODO This should probably test whether it's a sensible thing to do before
# doing it; I don't want to do this where any X server would actually be
# remote.
export DISPLAY=:0.0

# Helper functions to start tasks in the background
#
# @@TODO These also need hiving off
function gitk {
    command gitk "$@" &
    disown
}
function vs {
    command vs "$@" &
    disown
}

# Helper function for markdown for Metacom articles
#
# @@TODO Definitely needs hiving off
alias metadown="markdown -x 'headerid(forceid=True,level=3)'"

# Run processes at a high priority
alias unnice='nice -n -10'

# Get the Windows-style pwd
if command -v cygpath >/dev/null; then
    alias wpwd='cygpath -w $(pwd)'
fi
