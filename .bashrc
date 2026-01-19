# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# == Base config ==

# Use nvim (or vim, or vi) for editing
if command -v nvim >/dev/null 2>&1; then
  export EDITOR=nvim
  export VISUAL=nvim
  export MANPAGER='nvim +Man!'
elif command -v vim >/dev/null 2>&1; then
  # Fallback to Vim if Neovim is not available
  export EDITOR=vim
  export VISUAL=vim
  export MANPAGER="vim -M +MANPAGER -"
else
  # Default editor if neither Neovim nor Vim is available
  export EDITOR=vi
  export VISUAL=vi
fi

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

# Disable "Did you mean ...?" suggestions
# https://askubuntu.com/a/958493
unset command_not_found_handle

# If the server does not understand tmux-256color, use fallback
# https://unix.stackexchange.com/a/574674
if [ "$TERM" = "tmux-256color" ] && ! infocmp -0qU "tmux-256color" >/dev/null 2>&1; then
  export TERM=screen-256color
fi

# Add local bin to PATH
[ -d "$HOME/.local/bin" ] && export PATH="$HOME/.local/bin:$PATH"

# == History ==

# Don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
export HISTCONTROL=ignoreboth:erasedups

# For setting history length, see HISTSIZE and HISTFILESIZE in bash(1)
export HISTSIZE=1000
export HISTFILESIZE=2000

# Append to the history file, don't overwrite it
shopt -s histappend

# == Completion ==

# Enable programmable completion features
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    source /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    source /etc/bash_completion
  fi
fi

# Include some major applications' completions
for app in git; do
  if [ -f "/usr/share/bash-completion/completions/$app" ]; then
    source "/usr/share/bash-completion/completions/$app"
  elif [ -f "/etc/bash_completion.d/$app" ]; then
    source "/etc/bash_completion.d/$app"
  fi
done

# Also handle aliases that resolve to git
if command -v __git_complete &>/dev/null; then
  for v in g; do
    __git_complete $v __git_main
  done
fi

# == Aliases and functions ==

# Enable .bash_aliases if exists
if [ -f "$HOME/.bash_aliases" ]; then
  . "$HOME/.bash_aliases"
fi

# Enable vi mode
set -o vi

# enable color support of ls and grep
if [ -x /usr/bin/dircolors ]; then
  test -r "$HOME/.dircolors" && eval "$(dircolors -b "$HOME/.dircolors")" || eval "$(dircolors -b)"

  alias ls='ls --color=auto'
  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

# Handy aliases
alias l='ls -AlhF --group-directories-first --color=auto'
alias ll='tree -CAFa -I "CVS|*.*.package|.svn|.git|.hg|node_modules|bower_components|.next|.svelte-kit|venv" --dirsfirst'
alias e="$EDITOR"
alias v="$VISUAL"
alias g='git'
alias c='clear'
alias q='exit'

# Generate ".." shortcuts
# (since paths are set to not be considered executables by themselves)
for i in {1..9}; do
  alias_name="."
  relative_path=""
  for j in $(seq $i); do
    alias_name+='.'
    relative_path+='../'
  done
  line="alias $alias_name='cd $relative_path'"
  eval $line
done

function install-local-apps {
  # (re-)Install local apps
  # Uses `musl` instead of `gnu` for portability to servers that do not support recent glibc versions,
  # see https://github.com/sharkdp/fd/issues/417

  function get-version {
    curl -s "https://api.github.com/repos/$1/releases/latest" | node -e "console.log(JSON.parse(require('fs').readFileSync(0, 'utf-8')).tag_name);"
  }

  mkdir -p "$HOME/.local/bin"
  TEMP_DIR=$(mktemp -d /tmp/install.XXXXXX) && pushd "$TEMP_DIR" >/dev/null

  WGET_OPTS="--quiet --show-progress --progress=bar:force:noscroll"
  # If wget is too old to support --show-progress, fallback to no progress
  if ! wget --help | grep -q -- '--show-progress'; then
    WGET_OPTS="--quiet"
  fi

  # Check Github API rate limit
  rate_data=$(curl -s "https://api.github.com/rate_limit")
  rate_remaining=$(echo "$rate_data" | node -e "console.log(JSON.parse(require('fs').readFileSync(0, 'utf-8')).rate.remaining);")
  if [ "$rate_remaining" -lt 10 ]; then
    rate_reset=$(echo "$rate_data" | node -e "console.log(new Date(JSON.parse(require('fs').readFileSync(0, 'utf-8')).rate.reset * 1000).toLocaleString('en-GB'));")
    echo "Warning: GitHub API rate limit is low ($rate_remaining remaining)."
    echo "Consider waiting until $rate_reset before running this script again."
    return 1
  fi

  # For nvim: https://github.com/neovim/neovim/releases
  # If server does not support recent glibc versions, use https://github.com/neovim/neovim-releases (glibc 2.17) instead
  glibc_version=$(ldd --version | head -n1 | awk '{print $NF}')
  neovim_repo=$([ "$glibc_version" == "2.17" ] && echo "neovim/neovim-releases" || echo "neovim/neovim")
  version=$(get-version "$neovim_repo")
  wget $WGET_OPTS "https://github.com/$neovim_repo/releases/download/$version/nvim-linux-x86_64.tar.gz"
  tar xzf "nvim-linux-x86_64.tar.gz"
  rm -rf "$HOME/.local/bin/nvim-linux-x86_64" "$HOME/.local/bin/nvim" || true
  mv "nvim-linux-x86_64" "$HOME/.local/bin/nvim-linux-x86_64"
  ln -s "$HOME/.local/bin/nvim-linux-x86_64/bin/nvim" "$HOME/.local/bin/nvim"

  # For fzf: https://github.com/junegunn/fzf/releases
  version=$(get-version "junegunn/fzf")
  wget $WGET_OPTS "https://github.com/junegunn/fzf/releases/download/$version/fzf-${version#v}-linux_amd64.tar.gz"
  tar xzf "fzf-${version#v}-linux_amd64.tar.gz"
  mv fzf "$HOME/.local/bin/fzf"

  # For fd: https://github.com/sharkdp/fd/releases
  version=$(get-version "sharkdp/fd")
  wget $WGET_OPTS "https://github.com/sharkdp/fd/releases/download/$version/fd-$version-x86_64-unknown-linux-musl.tar.gz"
  tar xzf "fd-$version-x86_64-unknown-linux-musl.tar.gz"
  mv "fd-$version-x86_64-unknown-linux-musl/fd" "$HOME/.local/bin/fd"

  # For ripgrep: https://github.com/BurntSushi/ripgrep/releases
  version=$(get-version "BurntSushi/ripgrep")
  wget $WGET_OPTS "https://github.com/BurntSushi/ripgrep/releases/download/${version#v}/ripgrep-${version#v}-x86_64-unknown-linux-musl.tar.gz"
  tar xzf "ripgrep-${version#v}-x86_64-unknown-linux-musl.tar.gz"
  mv "ripgrep-${version#v}-x86_64-unknown-linux-musl/rg" "$HOME/.local/bin/rg"

  # For difftastic: https://github.com/Wilfred/difftastic/releases
  version=$(get-version "Wilfred/difftastic")
  wget $WGET_OPTS "https://github.com/Wilfred/difftastic/releases/download/${version#v}/difft-x86_64-unknown-linux-musl.tar.gz"
  tar xzf "difft-x86_64-unknown-linux-musl.tar.gz"
  mv difft "$HOME/.local/bin/difft"

  popd >/dev/null && rm -rf "$TEMP_DIR"
}

# == Prompt ==

function bash-git-status {
  # In-branch status
  local location=""
  local branch=$(git symbolic-ref --short -q HEAD 2>/dev/null || echo "")
  local tag=$(git describe --tags --exact-match 2>/dev/null || echo "")
  local sha=$(git rev-parse --short HEAD 2>/dev/null || echo "")
  if [ -n "$branch" ]; then
    location="\033[33m$branch"
  elif [ -n "$tag" ]; then
    location="\033[00;90m#\033[33m$tag"
  else
    location="\033[00;90m@\033[33m$sha"
  fi

  # Inter-branch status
  local remote_diff=""
  if git rev-parse --abbrev-ref --symbolic-full-name @{u} &>/dev/null; then
    local diff=$(git rev-list --left-right --count HEAD...@{u} 2>/dev/null)
    if [ "$(echo "$diff" | awk '{print $1}')" -gt 0 ]; then remote_diff+="↑"; fi
    if [ "$(echo "$diff" | awk '{print $2}')" -gt 0 ]; then remote_diff+="↓"; fi
  fi
  if [ -n "$remote_diff" ]; then remote_diff=" \033[00m$remote_diff"; fi

  # Stash status
  local stash_flag=""
  if [ "$(git rev-list --walk-reflogs --ignore-missing --count refs/stash)" -gt 0 ]; then
    stash_flag=" \033[00;90m⚑"
  fi

  # Status indicator
  has_staged=false
  has_unstaged=false
  has_untracked=false
  while IFS= read -r line; do
    local x="${line:0:1}" y="${line:1:1}"
    if [[ "$x" == "?" ]]; then
      has_untracked=true
    elif [[ "$x" != " " ]]; then
      has_staged=true
    elif [[ "$y" != " " ]]; then
      has_unstaged=true
    fi
  done < <(git status --porcelain 2>/dev/null)

  local status_color=""
  if $has_staged; then
    if $has_unstaged || $has_untracked; then
      status_color="\033[01;33m" # yellow
    else
      status_color="\033[01;32m" # green
    fi
  elif $has_unstaged || $has_untracked; then
    status_color="\033[01;31m" # red
  else
    status_color="\033[01;34m" # blue
  fi

  local status_symbol=""
  if $has_untracked; then
    status_symbol+="?"
  elif $has_unstaged; then
    status_symbol+="!"
  elif $has_staged; then
    status_symbol+="+"
  fi

  local status=$([ $status_symbol ] && echo -e " $status_color$status_symbol\033[00m")

  echo -e "\033[33m(${location}${remote_diff}${stash_flag}${status}\033[33m)\033[00m"
}

function bash-prompt {
  # Capture exit status of the last command
  status="$?"

  # Reset PS1
  PS1=""

  # Jobs
  jobs_count=$(jobs -p | wc -l)
  if [ "$jobs_count" -gt 0 ]; then
    PS1+="\[\033[00;36m\]\133${jobs_count}\135 \[\033[00m\]"
  fi

  # Username and hostname
  PS1+="\[\033[00;32m\]\u@\h "

  # pwd
  PS1+="\[\033[00;34m\]\w "

  # Git branch and status
  if git rev-parse --git-dir &>/dev/null; then
    PS1+="\$(bash-git-status) "
  fi

  # Glyph indicating last command status
  if [ $status -eq 0 ]; then
    PS1+="\[\033[00;34m\]"
  else
    PS1+="\[\033[00;31m\]"
  fi
  # Check if superuser
  if [ "$EUID" -eq 0 ]; then
    PS1+="# "
  else
    PS1+="$ "
  fi

  # Reset the prompt color
  PS1+="\[\033[00m\]"
}

# Reset cursor shape to insert mode
export PROMPT_COMMAND='bash-prompt'

# == NVM ==

export NVM_DIR="$HOME/.nvm"
# Load nvm
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" || true
# Add completion for nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" || true
