# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# == Base config ==

# Check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# Make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# limits recursive functions, see 'man bash'
[[ -z "$FUNCNEST" ]] && export FUNCNEST=100

# Change less flags
# https://unix.stackexchange.com/q/566943
export LESS=FRX

# == History ==

# Don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# For setting history length, see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# Append to the history file, don't overwrite it
shopt -s histappend

# enable color support of ls and grep
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"

  alias ls='ls --color=auto'
  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

# == Completion ==

# Enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Use the up and down arrow keys for finding a command in history
# (you can write some initial letters of the command first)
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

# == Aliases and functions ==

# Enable .bash_aliases
if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi

# Enable vi mode
set -o vi

# Handy aliases
alias l='ls -AlhF'
alias g='git'
alias c='clear'
alias q='exit'

# For GitHub commit links in Markdown
function gh-sha-md() {
  local remote_url=$(git config --get remote.origin.url | sed 's|^git@|https://|' | sed 's@.git$@@')
  if [[ " $* " == *" -b "* ]]; then
    local branch=$(git rev-parse --abbrev-ref HEAD)
    local branch_str="[\`$branch\`]($remote_url/commits/$branch)"
  else
    local branch_str=""
  fi
  echo "$branch_str [\`#$(git rev-parse --short HEAD)\`]($remote_url/commit/$(git rev-parse HEAD))" |
    xargs echo # https://stackoverflow.com/a/12973694
}

# For GitLab commit links in Markdown
function gl-sha-md() {
  local remote_url="$(git config --get remote.origin.url | sed 's@:@/@' | sed 's|^git@|https://|' | sed 's@.git$@@')"

  if [[ " $* " == *" -b "* ]]; then
    local branch=$(git rev-parse --abbrev-ref HEAD)
    local branch_str="[\`$branch\`]($remote_url/-/commits/$branch?ref_type=heads)"
  else
    local branch_str=""
  fi

  echo "$branch_str [\`#$(git rev-parse --short HEAD)\`]($remote_url/-/commit/$(git rev-parse HEAD))" |
    xargs echo # https://stackoverflow.com/a/12973694
}

alias sha-md=gl-sha-md

# == Prompt ==

# https://code.mendhak.com/simple-bash-prompt-for-developers-ps1-git/
function parse_git_dirty {
  [[ $(git status --porcelain 2>/dev/null) ]] && echo " *"
}
function parse_git_branch {
  git branch --no-color 2>/dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/ (\1$(parse_git_dirty))/"
}

export PS1="\[\033[01;32m\]\u@\h \[\033[00;34m\]\w\[\033[33m\]\$(parse_git_branch)\[\033[00m\] $ "

# == NVM ==

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion
