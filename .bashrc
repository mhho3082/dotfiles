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

# Disable "Did you mean ...?" suggestions
# https://askubuntu.com/a/958493
unset command_not_found_handle

# If the server does not understand tmux-256color, use fallback
# https://unix.stackexchange.com/a/574674
if [ "$TERM" = "tmux-256color" ] && ! infocmp -0qU "tmux-256color" >/dev/null 2>&1; then
  export TERM=screen-256color
fi

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

# == Extending with local apps ==

# # Use below script to (re-)install local apps
# # Uses `musl` instead of `gnu` for portability to servers that do not support recent glibc versions,
# # see https://github.com/sharkdp/fd/issues/417
#
# mkdir -p ~/.local/bin
# TEMP_DIR=$(mktemp -d) && pushd "$TEMP_DIR"
#
# # For nvim: https://github.com/neovim/neovim/releases
# # If server does not support recent glibc versions, use https://github.com/neovim/neovim-releases (glibc 2.17) instead
# glibc_version=$(ldd --version | head -n1 | awk '{print $NF}')
# neovim_repo=$([ "$glibc_version" == "2.17" ] && echo "neovim/neovim-releases" || echo "neovim/neovim")
# version=$(curl -s "https://api.github.com/repos/$neovim_repo/releases/latest" | node -e "console.log(JSON.parse(require('fs').readFileSync(0, 'utf-8')).tag_name);")
# wget "https://github.com/$neovim_repo/releases/download/$version/nvim-linux-x86_64.appimage"
# chmod u+x "nvim-linux-x86_64.appimage"
# mv "nvim-linux-x86_64.appimage" ~/.local/bin/nvim
#
# # For fzf: https://github.com/junegunn/fzf/releases
# version=$(curl -s "https://api.github.com/repos/junegunn/fzf/releases/latest" | node -e "console.log(JSON.parse(require('fs').readFileSync(0, 'utf-8')).tag_name);")
# wget "https://github.com/junegunn/fzf/releases/download/$version/fzf-${version#v}-linux_amd64.tar.gz"
# tar xzvf "fzf-${version#v}-linux_amd64.tar.gz"
# mv fzf ~/.local/bin/fzf
#
# # For fd: https://github.com/sharkdp/fd/releases
# version=$(curl -s "https://api.github.com/repos/sharkdp/fd/releases/latest" | node -e "console.log(JSON.parse(require('fs').readFileSync(0, 'utf-8')).tag_name);")
# wget "https://github.com/sharkdp/fd/releases/download/$version/fd-$version-x86_64-unknown-linux-musl.tar.gz"
# tar xzvf "fd-$version-x86_64-unknown-linux-musl.tar.gz"
# mv "fd-$version-x86_64-unknown-linux-musl/fd" ~/.local/bin/fd
#
# # For ripgrep: https://github.com/BurntSushi/ripgrep/releases
# version=$(curl -s "https://api.github.com/repos/BurntSushi/ripgrep/releases/latest" | node -e "console.log(JSON.parse(require('fs').readFileSync(0, 'utf-8')).tag_name);")
# wget "https://github.com/BurntSushi/ripgrep/releases/download/${version#v}/ripgrep-${version#v}-x86_64-unknown-linux-musl.tar.gz"
# tar xzvf "ripgrep-${version#v}-x86_64-unknown-linux-musl.tar.gz"
# mv "ripgrep-${version#v}-x86_64-unknown-linux-musl/rg" ~/.local/bin/rg
#
# # For difftastic: https://github.com/Wilfred/difftastic/releases
# version=$(curl -s "https://api.github.com/repos/Wilfred/difftastic/releases/latest" | node -e "console.log(JSON.parse(require('fs').readFileSync(0, 'utf-8')).tag_name);")
# wget "https://github.com/Wilfred/difftastic/releases/download/${version#v}/difft-x86_64-unknown-linux-musl.tar.gz"
# tar xzvf "difft-x86_64-unknown-linux-musl.tar.gz"
# mv difft ~/.local/bin/difft
#
# popd && rm -rf "$TEMP_DIR"

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

# enable color support of ls and grep
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"

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

# == Prompt ==

# https://code.mendhak.com/simple-bash-prompt-for-developers-ps1-git/
function parse_git_dirty {
  [[ $(git status --porcelain 2>/dev/null) ]] && echo " *"
}
function parse_git_branch {
  git branch --no-color 2>/dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/ (\1$(parse_git_dirty))/"
}

export PS1="\[\033[01;32m\]\u@\h \[\033[00;34m\]\w\[\033[33m\]\$(parse_git_branch)\[\033[00m\] $ "

# Reset cursor shape to insert mode
export PROMPT_COMMAND='echo -ne "\e[6 q"'

# == NVM ==

export NVM_DIR="$HOME/.nvm"
# Load nvm
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" || true
# Add completion for nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" || true
