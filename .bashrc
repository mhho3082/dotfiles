# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# == Base config ==

# Set the command-line editor
if command -v nvim >/dev/null 2>&1; then
  export EDITOR=nvim
  export VISUAL=nvim
elif command -v vim >/dev/null 2>&1; then
  export EDITOR=vim
  export VISUAL=vim
else
  export EDITOR=vi
  export VISUAL=vi
fi

# Set the man pager
if command -v bat >/dev/null 2>&1; then
  export MANPAGER='bat -plman'
elif command -v nvim >/dev/null 2>&1; then
  export MANPAGER='nvim +Man!'
elif command -v vim >/dev/null 2>&1; then
  export MANPAGER='vim -M +MANPAGER -'
else
  export MANPAGER='less -s'
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
export LESS="-FMRX"

# Disable "Did you mean ...?" suggestions
# https://askubuntu.com/a/958493
unset command_not_found_handle

# If the server does not understand tmux-256color, use fallback
# https://unix.stackexchange.com/a/574674
if [ "$TERM" = "tmux-256color" ] && ! infocmp -0qU "tmux-256color" >/dev/null 2>&1; then
  export TERM=screen-256color
fi

# fix washed-out colors over SSH
export COLORTERM=truecolor

# Add local bin to PATH
[ -d "$HOME/.local/bin" ] && export PATH="$HOME/.local/bin:$PATH"

# Set GPG's tty to the current one
# https://unix.stackexchange.com/a/724766
export GPG_TTY=$(tty)

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
  if [[ -r /usr/share/bash-completion/bash_completion ]]; then
    . /usr/share/bash-completion/bash_completion
  elif [[ -r /etc/bash_completion ]]; then
    . /etc/bash_completion
  fi
fi

# Include some major applications' completions
for app in git; do
  if [[ -r "/usr/share/bash-completion/completions/$app" ]]; then
    . "/usr/share/bash-completion/completions/$app"
  elif [[ -r "/etc/bash_completion.d/$app" ]]; then
    . "/etc/bash_completion.d/$app"
  fi
done

# Also handle aliases that resolve to git
if command -v __git_complete &>/dev/null; then
  for v in g; do
    __git_complete $v __git_main
  done
fi

# == Alias ==

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
alias c='clear'
alias q='exit'
alias e="$EDITOR"
alias v="$VISUAL"
alias g='git'
alias m='make'
alias s='ssh'

if command -v trash >/dev/null 2>&1; then
  alias r="trash"
else
  alias r="rm -i"
fi

if command -v eza >/dev/null 2>&1; then
  alias l='eza --all --long --icons --sort=type --git'
  alias ll='eza --all --long --tree --icons --sort=type --git --ignore-glob="CVS|*.*.package|.svn|.git|.hg|node_modules|bower_components|.next|.svelte-kit|venv"'
else
  alias l='ls -AlhF --group-directories-first --color=auto'
  alias ll='tree -CAFa -I "CVS|*.*.package|.svn|.git|.hg|node_modules|bower_components|.next|.svelte-kit|venv" --dirsfirst'
fi

# Change to superuser
alias superuser="sudo -Es"

# == Functions ==

# Password generator
function gen-password {
  LC_ALL=C tr -dc '[:graph:]' </dev/urandom | head -c ${1:-20}
  echo
}

# File manager (open)
function o {
  if command -v open >/dev/null 2>&1; then
    # For macOS
    open "${@:-.}" 2>/dev/null &
    disown
  elif grep -qEi "(Microsoft|WSL)" /proc/sys/kernel/osrelease &>/dev/null; then
    # Open in File Explorer (for WSL)
    # https://stackoverflow.com/q/38086185
    explorer.exe "${@:-.}"
    (($? == 1))
  else
    xdg-open "${@:-.}" 2>/dev/null &
    disown
  fi
}

# Set the AUR helper (variable used only for .bashrc functions)
export AUR_HELPER="paru"

# Only define functions if the AUR helper exists
if command -v "$AUR_HELPER" >/dev/null 2>&1; then
  # Package regexes that may require a reboot
  # Based on https://github.com/endeavouros-team/eos-bash-shared/blob/main/eos-reboot-required.hook
  aur_reboot_pkgs=(
    'amd-ucode'
    'intel-ucode'
    'btrfs-progs'
    'cryptsetup'
    'linux'
    'linux-hardened'
    'linux-lts'
    'linux-zen'
    'linux-rt'
    'linux-rt-lts'
    'linux-firmware\S*'
    'nvidia'
    'nvidia-dkms'
    'nvidia-\S*xx-dkms'
    'nvidia-\S*xx'
    'nvidia-\S*lts-dkms'
    'nvidia\S*-lts'
    'mesa'
    'systemd\S*'
    'wayland'
    'virtualbox-guest-utils'
    'virtualbox-host-dkms'
    'virtualbox-host-modules-arch'
    'egl-wayland'
    'xf86-video-\S*'
    'xorg-server\S*'
    'xorg-fonts\S*'
  )

  # Join the package names with '|' and check word boundaries using space char
  aur_reboot_check="\s($(
    IFS='|'
    echo "${aur_reboot_pkgs[*]}"
  ))(?=\s)"

  # Update the system and reboot if needed
  function aur-update {
    local updates status=0

    if command -v checkupdates >/dev/null 2>&1; then
      updates=$(checkupdates --nocolor | awk '{print $1;}' | tr '\n' ' ')
    else
      "$AUR_HELPER" -Sy
      updates=$("$AUR_HELPER" -Qu --color=never | awk '{print $1;}' | tr '\n' ' ')
    fi

    if [ -z "$updates" ]; then
      echo -e "No updates available."
      return
    fi

    # Warn about required reboot
    local reboot_needed=0
    if echo " $updates " | grep -P "$aur_reboot_check" &>/dev/null; then
      reboot_needed=1
      echo "Packages to update:"
      echo " $updates " | grep -P "$aur_reboot_check" --color=always | xargs
      read -rn1 -p "Reboot likely needed. Proceed with update? [y/N] " answer
      echo
      [[ "$answer" =~ ^[yY]$ ]] || return
    fi

    # Perform upgrade
    "$AUR_HELPER" -Syu --noconfirm
    status="$?"
    if [ $status -eq 0 ]; then
      if [ "$reboot_needed" -eq 1 ]; then
        echo -e "Update successful. rebooting now."
        reboot && return
      else
        echo -e "Update successful. No reboot needed."
      fi
    else
      echo -e "Update failed using $AUR_HELPER. See logs above."
    fi

    # Reload autostart scripts (bootup parts only)
    timeout 1s bash -c 'for script in $HOME/.config/autostart/*.sh; do "$script" &>/dev/null & done; wait'

    return $status
  }

  # Remove orphaned packages
  function aur-autoremove {
    "$AUR_HELPER" -Runs $("$AUR_HELPER" -Qdtq)
  }
fi

# For homebrew / linuxbrew
if command -v brew >/dev/null 2>&1; then
  # Update homebrew
  function brew-update {
    brew update
    brew upgrade
    brew cleanup
    brew doctor
  }
fi

# == Prompt ==

# https://linuxvox.com/blog/bash-ps1-line-wrap-issue-with-non-printing-characters-from-an-external-command/

# Detect an in-progress rebase/merge/cherry-pick/revert/bisect/am action
function bash-git-action {
  local git_dir="$1"
  [ -z "$git_dir" ] && return
  if [ -f "$git_dir/rebase-merge/interactive" ]; then
    echo "rebase-i"
  elif [ -d "$git_dir/rebase-merge" ]; then
    echo "rebase-m"
  elif [ -d "$git_dir/rebase-apply" ]; then
    if [ -f "$git_dir/rebase-apply/rebasing" ]; then
      echo "rebase"
    elif [ -f "$git_dir/rebase-apply/applying" ]; then
      echo "am"
    else
      echo "am/rebase"
    fi
  elif [ -f "$git_dir/MERGE_HEAD" ]; then
    echo "merge"
  elif [ -f "$git_dir/CHERRY_PICK_HEAD" ]; then
    echo "cherry-pick"
  elif [ -f "$git_dir/REVERT_HEAD" ]; then
    echo "revert"
  elif [ -f "$git_dir/BISECT_LOG" ]; then
    echo "bisect"
  fi
}

function bash-git-status {
  local git_dir=$(git rev-parse --git-dir 2>/dev/null)
  [ -z "$git_dir" ] && return

  local S=$'\x01' E=$'\x02'
  local RESET="${S}$(tput sgr0)${E}"
  local DIM="${S}$(tput setaf 242)${E}"
  local YELLOW="${S}$(tput setaf 3)${E}"
  local RED="${S}$(tput setaf 1)${E}"
  local GREEN_BOLD="${S}$(tput bold)$(tput setaf 2)${E}"
  local YELLOW_BOLD="${S}$(tput bold)$(tput setaf 3)${E}"
  local RED_BOLD="${S}$(tput bold)$(tput setaf 1)${E}"

  local output=""

  local upstream=""
  local has_upstream=false
  if upstream=$(git rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null); then
    has_upstream=true
    local diff=$(git rev-list --left-right --count HEAD...@{u} 2>/dev/null)
    [ "$(echo "$diff" | awk '{print $1}')" -gt 0 ] && output+="↑"
    [ "$(echo "$diff" | awk '{print $2}')" -gt 0 ] && output+="↓"
  fi
  if [ "$(git rev-list --walk-reflogs --ignore-missing --count refs/stash 2>/dev/null)" -gt 0 ]; then
    output+="${DIM}⚑${RESET}"
  fi
  [ -n "$output" ] && output+=" "

  local action=$(bash-git-action "$git_dir")
  [ -n "$action" ] && output+="${DIM}${action}${RESET} "

  local has_staged=false has_unstaged=false has_untracked=false has_conflict=false
  while IFS= read -r line; do
    local x="${line:0:1}" y="${line:1:1}"
    if [[ "$x" == "?" ]]; then
      has_untracked=true
    elif [[ "$x" == "U" || "$y" == "U" || ("$x" == "A" && "$y" == "A") || ("$x" == "D" && "$y" == "D") ]]; then
      has_conflict=true
    else
      [[ "$x" != " " ]] && has_staged=true
      if [[ "$y" == "D" ]]; then
        has_untracked=true
      elif [[ "$y" != " " ]]; then
        has_unstaged=true
      fi
    fi
  done < <(git status --porcelain 2>/dev/null)

  $has_conflict && output+="${RED}✗${RESET} "

  local branch=$(git symbolic-ref --short -q HEAD 2>/dev/null)
  if $has_upstream; then
    output+="${DIM}⧉ ${RESET}"
    local remote_branch="${upstream#*/}"
    if [ -n "$remote_branch" ] && [ "$remote_branch" != "$branch" ]; then
      output+="${DIM}(${remote_branch})${RESET} "
    fi
  fi

  local tag=$(git describe --tags --exact-match 2>/dev/null)
  local sha=$(git rev-parse --short HEAD 2>/dev/null)
  if [ -n "$branch" ]; then
    output+="${YELLOW}$branch${RESET}"
  elif [ -n "$tag" ]; then
    output+="${DIM}#${YELLOW}$tag${RESET}"
  else
    output+="${DIM}@${YELLOW}$sha${RESET}"
  fi

  local status_color="" status_symbol=""
  if $has_staged; then
    if $has_untracked; then
      status_color="$YELLOW_BOLD" && status_symbol="?"
    elif $has_unstaged; then
      status_color="$YELLOW_BOLD" && status_symbol="!"
    else
      status_color="$GREEN_BOLD" && status_symbol="+"
    fi
  elif $has_untracked; then
    status_color="$RED_BOLD" && status_symbol="?"
  elif $has_unstaged; then
    status_color="$RED_BOLD" && status_symbol="!"
  fi

  if [ -n "$status_symbol" ]; then
    output+=" ${status_color}${status_symbol}${RESET}"
  fi

  echo -e "${YELLOW}(${RESET}${output}${YELLOW})${RESET}"
}

function bash-prompt {
  status="$?"

  local RESET="\[$(tput sgr0)\]"
  local DIM="\[$(tput setaf 242)\]"
  local INVERT="\[$(tput rev)\]"
  local GREEN="\[$(tput setaf 2)\]"
  local BLUE="\[$(tput setaf 4)\]"
  local CYAN="\[$(tput setaf 6)\]"
  local MAGENTA="\[$(tput setaf 5)\]"
  local ORANGE="\[$(tput setaf 208)\]"
  local RED="\[$(tput setaf 1)\]"

  PS1=""

  # If the previous command did not add a new line, add it ourselves
  # https://stackoverflow.com/a/20156527
  local curpos
  echo -en "\E[6n"
  IFS=";" read -sdR -a curpos
  if ((curpos[1] != 1)); then
    PS1+="${INVERT}%${RESET}\n"
  fi

  jobs_count=$(jobs -p | wc -l)
  if [ "$jobs_count" -gt 0 ]; then
    PS1+="${CYAN}\133${jobs_count}\135 ${RESET}"
  fi

  if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ] || [ -n "$SSH_CONNECTION" ]; then
    local host_color="$ORANGE"
  else
    local host_color="$MAGENTA"
  fi
  PS1+="${GREEN}\u${DIM}@${host_color}\h ${RESET}"

  PS1+="${BLUE}\w ${RESET}"

  if git rev-parse --git-dir &>/dev/null; then
    PS1+="\$(bash-git-status) "
  fi

  if [ $status -eq 0 ]; then
    PS1+="${DIM}"
  else
    PS1+="${RED}"
  fi
  if [ "$EUID" -eq 0 ]; then
    PS1+="# "
  else
    PS1+="$ "
  fi

  PS1+="${RESET}"
}

# Reset cursor shape to insert mode
export PROMPT_COMMAND='bash-prompt'

# == FZF ==

# Add completion for fzf
if command -v fzf >/dev/null 2>&1; then
  if command -v fd >/dev/null 2>&1; then
    export FZF_DEFAULT_OPTS="--ansi"
    export FZF_DEFAULT_COMMAND="fd --type file --follow --hidden --exclude .git --color=always"
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  fi

  if command -v bat >/dev/null 2>&1; then
    export FZF_CTRL_T_OPTS="--preview='bat --color=always --style=numbers --line-range=:500 {}'"
  else
    export FZF_CTRL_T_OPTS="--preview='less {}'"
  fi

  eval "$(fzf --bash)"
fi

# == Zoxide ==

# Add completion for zoxide
# https://github.com/ajeetdsouza/zoxide?tab=readme-ov-file#installation
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init bash)"
fi

# == AI tools ==

# Disable setting terminal titles
export OPENCODE_DISABLE_TERMINAL_TITLE="true"
export CLAUDE_CODE_DISABLE_TERMINAL_TITLE="true"

# == Version managers ==

# == NVM ==

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" || true
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" || true

# == Pyenv ==

# To enable auto-activation of Python virtualenvs
# (when you are likely doing Python-intensive work),
# call pyenv in advance

# Lazy-load pyenv: define a stub that initialises pyenv on first use
if command -v pyenv >/dev/null 2>&1 || [ -d "$HOME/.pyenv" ]; then
  export PYENV_ROOT="${PYENV_ROOT:-$HOME/.pyenv}"
  export PATH="$PYENV_ROOT/bin:$PATH"

  function _pyenv_init {
    unset -f pyenv _pyenv_init
    eval "$(pyenv init --path)"
    eval "$(pyenv init -)"
    if pyenv commands | grep -q "virtualenv-init"; then
      eval "$(pyenv virtualenv-init -)"
    fi
  }

  function pyenv {
    _pyenv_init
    pyenv "$@"
  }
fi
