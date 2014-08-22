# .bashrc

# User specific aliases and functions

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias ll='ll -h'
alias cdb='cd /data/codebase'
alias cdd='cd /data'
alias grep='grep --color -I'
get_diags() {
  if [[ (-n $1) && (-n $2) ]]
  then
    scp "${1}:/var/opt/MetaSwitch/craft/ftp/msdiags_${3:-'*'}_${2}_*.tar.gz" ~ && rename msdiags ${1}_msdiags ~/msdiags_*_${2}_*.tar.gz
  else
    echo 'Usage: get_diags box trap (A/B)'
  fi
}

# Restart the clipboard, when it stops working.
alias noclip='killall VBoxClient; VBoxClient-all'

# Start up cacti, for SMNP stat tracking.
alias cacti='for service in mysqld httpd sendmail; do sudo service $service start; done'

# Useful paths to use in Bash scripts.
export CB_ROOT='/data/codebase'
export BUILD_ROOT='/data/codebase/output/jobs/lnx64/'
export SLOTH='/data/codebase/orlando/test/sloth2'

# How many cores to use when compiling the codebase?
export DMAKE_MAX_JOBS='4'

# Places to look for libraries.  Multiple places to find these.
# Important ones are the general output directories from compiling the
# codebase.  Chase these with various libraries hidden around the codebase.
export LD_LIBRARY_PATH="${CB_ROOT}/output/jobs/lnx64/fv/debug:${CB_ROOT}/output/lnx64/debug:${CB_ROOT}/output/jobs/lnx64/fv/release:${CB_ROOT}/output/lnx64/release:${CB_ROOT}/orlando/code/jobs/gnu/libs/intel:${CB_ROOT}/orlando/code/tools/ipp/lib/lnx64"

# Default programs.
export EDITOR=vim
export DIFFCMD="vimdiff"

# Go.
export GOROOT=/usr/local/go
export GOPATH=/data/go

# Paths.
export PATH="${PATH}:/opt/CollabNet_Subversion/bin:${GOROOT}/bin:${GOPATH}/bin:/dcl-svn/client"
export PYTHONPATH="${CB_ROOT}/orlando/python/legacy:${CB_ROOT}/orlando/python/packages"

# Pretty prompt.  
function parse_git_dirty {
  [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit, working directory clean" ]] && echo "*"
}
function parse_git_branch {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/[\1$(parse_git_dirty)] /"
}
export PS1='$(parse_git_branch)[\u@\h \w]\$ '
#export PS1='$(parse_git_branch)\W >> '

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# The terminal actually supports 256-bit colour.
if [[ $TERM == "xterm" ]]
then
  export TERM="xterm-256color"
fi

# Colourful prompts to cheer the day.
#if [[ $TERM == "putty-256color" || $TERM == "xterm-256color" ]]
if [[ 1 -eq 2 ]]
then
  # Get a random color which is good on a dark background.
  function get_rand_color {
  num='0'
  invalid_nums='0 4 16 17 18 19 20 21 22 25 52 53 54 55 56 57 91 92 232 233 234 235 236 237 238 239 240'
  while [[ $invalid_nums =~ $num ]]
  do
    num=$((RANDOM%255+1))
  done
  echo $num
  }
  function set_rand_color {
  COL=$(get_rand_color)
  tput setaf ${COL}
  #echo "($COL)"
  }

  export PS1='\[$(set_rand_color)\]'$PS1
fi

# Fuzzy finding files.
source ~/.fzf.bash
