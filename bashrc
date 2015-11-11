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
if [[ -z $BASH_COMPLETION && -r /usr/local/etc/bash_completion ]] &&
        ! shopt -oq posix; then
    . /usr/local/etc/bash_completion
fi

# Enable fzf.
[[ -f ~/.fzf.bash ]] && . ~/.fzf.bash

# Append to the history file rather than overwriting it.
shopt -s histappend

# Check the window size after each command, updating LINES and COLUMNS.
shopt -s checkwinsize

# Expand ** for directory parsing.
shopt -s globstar

# Don't exit if there are running jobs.
shopt -s checkjobs

# Make less more friendly.
if [[ -x /usr/bin/lesspipe ]]; then
    eval "$(/usr/bin/lesspipe)"  # Seen on Debian
elif [[ -x /usr/bin/lesspipe.sh ]]; then
    eval "$(/usr/bin/lesspipe.sh)"  # Seen on Cygwin
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

if [[ -f "/usr/local/opt/bash-git-prompt/share/gitprompt.sh" ]]; then
    # Enable the fancy Git prompt if it's available, which includes printing
    # the last return code on each shell prompt too.
    #
    # @@TODO Set up custom themes a la the custom colour themes defined for PS1
    # on other systems below.
    #
    # @@TODO If possible, render the non bash-git-prompt based version
    # irrelevant by including it as standard.
    GIT_PROMPT_THEME=Default
    . "/usr/local/opt/bash-git-prompt/share/gitprompt.sh"
else
    # Determine the colour to display the hostname.  Useful for determining at
    # a glance what system I'm connected to!
    case $(hostname) in
        PC4306)
            hostname_colour=$ANSI_GREEN
            pwd_colour=$ANSI_YELLOW
            timestamp_colour=$ANSI_BLUE
            ;;
        northrend.tastycake.net)
            hostname_colour=$ANSI_CYAN
            pwd_colour=$ANSI_GREEN
            timestamp_colour=$ANSI_RED
            ;;
        Hendrix)
            hostname_colour=$ANSI_GREEN
            pwd_colour=$ANSI_MAGNETA
            timestamp_colour=$ANSI_CYAN
            ;;
        centosvm)
            hostname_colour=$ANSI_YELLOW
            pwd_colour=$ANSI_RED
            timestamp_colour=$ANSI_GREEN
            ;;
        *)
            hostname_colour=$ANSI_WHITE
            pwd_colour=$ANSI_YELLOW
            timestamp_colour=$ANSI_BLUE
            ;;
    esac

    # Set the prompt.  If __git_ps1 is available from git-prompt.sh, we want to
    # use PROMPT_COMMAND with that function, which requires separate variables
    # for the bits going before and after the Git prompt.
    ps1_pre_git="\[\e$ANSI_RESET\]"  # Start by resetting terminal colours
    ps1_pre_git="$ps1_pre_git\\[\\e]0;\\h:\\w\\a\\]"  # Terminal title
    ps1_pre_git="$ps1_pre_git\\n\[\e\$hostname_colour\]\\u@\\h "  # Host
    ps1_pre_git="$ps1_pre_git\[\e\$pwd_colour\]\\w"  # Working directory
    ps1_post_git=" \[\e\$timestamp_colour\]\\D{%a %e %b %T}"
    ps1_post_git="$ps1_post_git\[\e\$ANSI_UNCOLOUR\]\\n\\$ "  # Finish, newline, prompt

    if [[ $(type -t __git_ps1) == function ]]; then
        # Build the prompt every time using __git_ps1 per the instructions in
        # the header to git-prompt.sh.  Enable all the options; they can be
        # turned off on a per-repository basis if necessaray.
        GIT_PS1_SHOWDIRTYSTATE=yes
        GIT_PS1_SHOWSTASHSTATE=yes
        GIT_PS1_SHOWUNTRACKEDFILES=yes
        GIT_PS1_SHOWUPSTREAM='auto'
        GIT_PS1_DESCRIBE_STYLE='branch'
        GIT_PS1_SHOWCOLORHINTS=yes
        if [[ $(hostname) == northrend.tastycake.net ]]; then
            # On Tastycake, it seems using __git_ps1 in PROMPT_COMMAND doesn't
            # work.  I suspect it's something to do with the version of
            # git-prompt.sh that's being used, but I can't work out the details
            # well enough to fix it.  In the meantime, just build a regular PS1
            # and cope with the lack of colour in the Git part of the prompt.
            PS1="$ps1_pre_git\[\e\$ANSI_UNCOLOUR\]\$(__git_ps1)$ps1_post_git"
        else
            PROMPT_COMMAND="__git_ps1 '$ps1_pre_git\[\e$ANSI_UNCOLOUR\]' '$ps1_post_git'"
        fi
    else
        # No __git_ps1, so just create a regular PS1 from the variables we
        # built.
        PS1=$ps1_pre_git$ps1_post_git
    fi
    unset ps1_pre_git ps1_post_git
fi

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

# And colour the output of useful commands.  On OS X, the argument to get
# colours for `ls` is `-G`, not `--color=auto`.  No need to worry about
# commands that don't exist -- defining aliases for them doesn't cause any
# problems.
if ls --color=auto &>/dev/null; then
    alias ls='ls --color=auto'
else
    alias ls='ls -G'
fi
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

# Editor
export EDITOR=vim
export VISUAL=vim

# When calling cscope, I generally want some useful default arguments: -k
# ignores the standard include directories (I'm rarely interested in those
# anyway), -R recurses into directories, -q builds a reverse-lookup indices for
# speed, and -b stops cscope launching its interactive mode (why would I want
# that when I can launch vim directly!?).
alias cscope='cscope -kRqb'

# Simple random number generator.  Not even vaguely secure.
function rand {
    echo $(( (RANDOM % $1) + 1 ))
}

# Doge Git: https://twitter.com/chris__martin/status/420992421673988096
alias such=git
alias very=git
alias wow='git status'

# Helper functions to check the big glowing ball o'doom.
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
function doom_colour {
    if CheckBuild; then
        echo Green
    else
        echo Red
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
function cid {
    mkdir -p ~/isslocal/issue$1
    cd ~/isslocal/issue$1
    [[ -e issue$1 ]] || ln -s ~/diags/issues/issue$1
}
function csd {
    mkdir -p ~/sfrlocal/sfr$1
    cd ~/sfrlocal/sfr$1
    [[ -e sfr$1 ]] || ln -s ~/diags/sfrs/sfr$1
}
function unpack_diags {
    while (( $# > 0 )); do
        file=$1
        dir=$(basename "$file" | sed -nr 's/^([-a-zA-Z0-9_\(\)\.]*)\.tar\.gz/\1/p')
        mkdir "$dir" && tar -C "$dir" -xzf "$file" &
        shift
    done
    wait
}

function cdis {
    if (( $# != 1 )); then
        echo Incorrect number of arguments >&2
        return 1
    fi
    cd ~/diags/issues/issue"$1"
}

function cdsf {
    if (( $# != 1 )); then
        echo Incorrect number of arguments >&2
        return 1
    fi
    cd ~/diags/sfrs/sfr"$1"
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

# Helper function for markdown for Metacom articles
#
# @@TODO Definitely needs hiving off
if command -v python3 >/dev/null; then
    alias markdown='python3 -m markdown -x abbr -x def_list -x fenced_code -x "footnotes(PLACE_MARKER=+++FOOTNOTES HERE+++)" -x "headerid(forceid=False,level=1)" -x tables'
    alias metadown='python3 -m markdown -x abbr -x def_list -x fenced_code -x "footnotes(PLACE_MARKER=+++FOOTNOTES HERE+++)" -x "headerid(forceid=True,level=3)" -x tables'
elif command -v python >/dev/null; then
    alias markdown='python -m markdown -x abbr -x def_list -x fenced_code -x "footnotes(PLACE_MARKER=+++FOOTNOTES HERE+++)" -x "headerid(forceid=False,level=1)" -x tables'
    alias metadown='python -m markdown -x abbr -x def_list -x fenced_code -x "footnotes(PLACE_MARKER=+++FOOTNOTES HERE+++)" -x "headerid(forceid=True,level=3)" -x tables'
fi

# Run processes at a high priority
alias unnice='nice -n -10'

# Get the Windows-style pwd
if command -v cygpath >/dev/null; then
    alias wpwd='cygpath -w $(pwd)'
fi

alias snarf='aria2c -x16 -s16'

# Function to print a random international name.  Currently renders characters
# with accents using HTML entities, which isn't very pretty but still achieves
# its purpose.
function random_name {
    curl -s 'http://www.behindthename.com/random/random.php?number=1&gender=both&surname=&all=no&usage_afr=1&usage_alb=1&usage_ara=1&usage_arm=1&usage_bas=1&usage_bre=1&usage_bul=1&usage_cat=1&usage_chi=1&usage_cor=1&usage_cro=1&usage_cze=1&usage_dan=1&usage_dut=1&usage_eng=1&usage_esp=1&usage_est=1&usage_fin=1&usage_fre=1&usage_fri=1&usage_gal=1&usage_geo=1&usage_ger=1&usage_gre=1&usage_haw=1&usage_hun=1&usage_ice=1&usage_ind=1&usage_ins=1&usage_ira=1&usage_iri=1&usage_ita=1&usage_jap=1&usage_jew=1&usage_khm=1&usage_kor=1&usage_lat=1&usage_lim=1&usage_lth=1&usage_mac=1&usage_man=1&usage_mao=1&usage_ame=1&usage_nor=1&usage_occ=1&usage_pol=1&usage_por=1&usage_rmn=1&usage_rus=1&usage_sco=1&usage_ser=1&usage_slk=1&usage_sln=1&usage_spa=1&usage_swe=1&usage_tha=1&usage_tur=1&usage_ukr=1&usage_vie=1&usage_wel=1' | sed -rn 's!^.*<a class="plain" href="/name/.*">(.*)</a>.*!\1!p'
}

# Cygwin ssh-agent code.  This is decidedly rough, but it works.
# Based on https://www.cygwin.com/ml/cygwin/2001-06/msg00537.html
if [[ $(hostname) == PC5175 ]]; then
    function start_ssh_agent {
        # Security hole here between creating the ssh-agent file and chmodding
        # it; can maybe be fixed with a user mask?  I've never played with
        # those...
        ssh-agent | sed 's/^echo/#echo/' >~/.ssh/ssh-agent
        chmod 600 ~/.ssh/ssh-agent
        . ~/.ssh/ssh-agent
        ssh-add
    }
    if [[ -r ~/.ssh/ssh-agent ]]; then
        . ~/.ssh/ssh-agent
        if ! ps -ef |
                grep -qE '\<'"$SSH_AGENT_PID"'\>.*\> +\/usr\/bin\/ssh-agent$'
        then
            start_ssh_agent
        fi
    else
        start_ssh_agent
    fi
fi
