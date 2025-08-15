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
export HISTCONTROL=ignoreboth:erasedups

# For setting history length, see HISTSIZE and HISTFILESIZE in bash(1)
export HISTSIZE=1000
export HISTFILESIZE=2000

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

# Enable programmable completion features
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    source /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    source /etc/bash_completion
  fi
fi

# == Extending with local apps ==

# For nvim: https://github.com/neovim/neovim/releases
# mkdir -p ~/.local/bin
# wget https://github.com/neovim/neovim/releases/download/v0.11.3/nvim-linux-x86_64.appimage
# chmod u+x nvim-linux-x86_64.appimage
# mv nvim-linux-x86_64.appimage ~/.local/bin/nvim

# For fzf: https://github.com/junegunn/fzf/releases
# mkdir -p ~/.local/bin
# wget https://github.com/junegunn/fzf/releases/download/v0.65.1/fzf-0.65.1-linux_amd64.tar.gz
# tar xzvf fzf-0.65.1-linux_amd64.tar.gz
# rm fzf-0.65.1-linux_amd64.tar.gz
# mv fzf ~/.local/bin/fzf

# For fd: https://github.com/sharkdp/fd/releases
# mkdir -p ~/.local/bin
# wget https://github.com/sharkdp/fd/releases/download/v10.2.0/fd-v10.2.0-x86_64-unknown-linux-gnu.tar.gz
# tar xzvf fd-v10.2.0-x86_64-unknown-linux-gnu.tar.gz
# rm fd-v10.2.0-x86_64-unknown-linux-gnu.tar.gz
# mv fd-v10.2.0-x86_64-unknown-linux-gnu/fd ~/.local/bin/fd
# rm -rf fd-v10.2.0-x86_64-unknown-linux-gnu

# For ripgrep: https://github.com/BurntSushi/ripgrep/releases
# mkdir -p ~/.local/bin
# wget https://github.com/BurntSushi/ripgrep/releases/download/14.1.1/ripgrep-14.1.1-x86_64-unknown-linux-musl.tar.gz
# tar xzvf ripgrep-14.1.1-x86_64-unknown-linux-musl.tar.gz
# rm ripgrep-14.1.1-x86_64-unknown-linux-musl.tar.gz
# mv ripgrep-14.1.1-x86_64-unknown-linux-musl/rg ~/.local/bin/rg
# rm -rf ripgrep-14.1.1-x86_64-unknown-linux-musl

if [ -d "$HOME/.local/bin" ]; then
  # Add local bin to PATH
  export PATH="$HOME/.local/bin:$PATH"
fi

if command -v nvim >/dev/null 2>&1; then
  export EDITOR=nvim
  export VISUAL=nvim
elif command -v vim >/dev/null 2>&1; then
  # Fallback to Vim if Neovim is not available
  export EDITOR=vim
  export VISUAL=vim
else
  # Default editor if neither Neovim nor Vim is available
  export EDITOR=vi
  export VISUAL=vi
fi

# == Aliases and functions ==

# Enable .bash_aliases
if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi

# Enable vi mode
set -o vi

# Handy aliases
alias l='ls -AlhF'
alias ll='tree -CAFa -I "CVS|*.*.package|.svn|.git|.hg|node_modules|bower_components" --dirsfirst'
alias e="$EDITOR"
alias v="$VISUAL"
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
