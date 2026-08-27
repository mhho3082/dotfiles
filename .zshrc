# == Base config ==

# Use nvim (or vim, or vi) for editing
if (($+commands[nvim])); then
  export VISUAL="nvim"
  export EDITOR="nvim"
  export MANPAGER='nvim +Man!'
elif (($+commands[vim])); then
  export VISUAL="vim"
  export EDITOR="vim"
  export MANPAGER="vim -M +MANPAGER -"
else
  export VISUAL="vi"
  export EDITOR="vi"
fi

# Set the AUR helper (variable used only for .zshrc functions)
export AUR_HELPER="paru"

# Modify history
HISTFILE="$HOME/.zsh_history"
HISTSIZE=1000
SAVEHIST=1000

# Change zsh options
setopt correct
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt prompt_subst
setopt no_case_glob
unsetopt beep
unsetopt autocd

# Change less flags
export LESS="-FMRX"

# If the server does not understand tmux-256color, use fallback
# https://unix.stackexchange.com/a/574674
if [ "$TERM" = "tmux-256color" ] && ! infocmp -0qU "tmux-256color" >/dev/null 2>&1; then
  export TERM=screen-256color
fi

# fix washed-out colors over SSH
export COLORTERM=truecolor

# Add paths to PATH
[[ -d "/usr/local/sbin" ]] && path+="/usr/local/sbin"
[[ -d "$HOME/.local/bin" ]] && path+="$HOME/.local/bin"

# Set GPG's tty to the current one
# https://unix.stackexchange.com/a/724766
export GPG_TTY=$(tty)

# == Plugins ==

# Auto-install and load external plugins
# Modified from https://github.com/mattmc3/zsh_unplugged

# If the plugin folder does not exist, create it
ZPLUGINDIR="$HOME/.local/share/zsh/plugins"
mkdir -p $ZPLUGINDIR

# Clone a plugin, identify its init file, source it, and add it to your fpath
function plugin-load {
  local repo repos=($@) plugdir initfile initfiles=()

  # Clear positional parameters ($@),
  # otherwise old plugins might malfunction with unexpected parameters passed to them
  set --

  for repo in $repos; do
    plugdir=$ZPLUGINDIR/${repo:t}
    initfile=$plugdir/${repo:t}.plugin.zsh
    if [[ ! -d $plugdir ]]; then
      echo "Cloning $repo..."
      git clone -q --depth 1 --recursive --shallow-submodules \
        https://github.com/$repo $plugdir
    fi
    if [[ ! -e $initfile ]]; then
      initfiles=($plugdir/*.{plugin.zsh,zsh-theme,zsh,sh}(N))
      (($#initfiles)) || { echo >&2 "No init file '$repo'." && continue; }
      ln -sf $initfiles[1] $initfile
    fi
    fpath+=$plugdir
    source $initfile
  done
}

# Update each plugin in $ZPLUGINDIR
function plugin-update {
  local repo plugdir old_commit new_commit
  for plugdir in $ZPLUGINDIR/*; do
    if [[ -d $plugdir ]]; then
      repo=${plugdir:t}
      echo -ne "Updating $repo...\r"

      old_commit=$(git -C $plugdir rev-parse --short HEAD 2>/dev/null)

      if git -C $plugdir pull --ff-only --quiet; then
        new_commit=$(git -C $plugdir rev-parse --short HEAD 2>/dev/null)
        if [[ "$old_commit" != "$new_commit" ]]; then
          echo "Updated $repo: $old_commit -> $new_commit"
        else
          echo "$repo is already up to date."
        fi
      else
        echo >&2 "Failed to update $repo."
      fi
    fi
  done
}

local repos=(
  zsh-users/zsh-completions
  # zsh-syntax-highlighting must be sourced after all ZLE command-line buffer hooks,
  # see https://github.com/zsh-users/zsh-syntax-highlighting?tab=readme-ov-file#why-must-zsh-syntax-highlightingzsh-be-sourced-at-the-end-of-the-zshrc-file
  zsh-users/zsh-syntax-highlighting
)
plugin-load $repos

# == Completion ==

# Turn on compinit and bash compatibility
autoload -Uz compinit && compinit
autoload -Uz bashcompinit && bashcompinit

# Modify zsh completion
# https://thevaluable.dev/zsh-completion-guide-examples/
zstyle ':completion:*' menu select
zstyle ':completion:*' completer _extensions _complete _approximate
zstyle ':completion:*' group-name ''
zstyle ':completion:*' complete-options true
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*'
zstyle ':completion:*' list-suffixes
zstyle ':completion:*' expand prefix suffix

zstyle ':completion:*' verbose yes
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:descriptions' format "%F{yellow}%B--- %d%b"
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format "%F{red}No matches for:%f %d"
zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'

# Enable programmable completion features (using bash completion)
# (also ensure shopt does not exist in the files, zsh does not have shopt)
if [[ -r /usr/share/bash-completion/bash_completion ]] && ! grep 'shopt' /usr/share/bash-completion/bash_completion &>/dev/null; then
  source /usr/share/bash-completion/bash_completion
elif [[ -r /etc/bash_completion ]] && ! grep 'shopt' /etc/bash_completion &>/dev/null; then
  source /etc/bash_completion
fi

# == Vi mode and ZLE ==

# Use vi mode
bindkey -v

# https://unix.stackexchange.com/q/433273
local CURSOR_NORMAL='\e[2 q'
local CURSOR_INSERT='\e[6 q'

# Change cursor upon changing modes
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
    [[ $1 = 'block' ]]; then
    echo -ne $CURSOR_NORMAL
  elif [[ ${KEYMAP} == main ]] ||
    [[ ${KEYMAP} == viins ]] ||
    [[ ${KEYMAP} = '' ]] ||
    [[ $1 = 'beam' ]]; then
    echo -ne $CURSOR_INSERT
  fi
}
zle -N zle-keymap-select

function zle-line-init {
  zle -K viins
}
zle -N zle-line-init

# Default in insert mode cursor
function _default-cursor {
  echo -ne $CURSOR_INSERT
}
precmd_functions+=(_default-cursor)

# Set up history search in ZLE
# https://unix.stackexchange.com/a/97844
# https://apple.stackexchange.com/q/426084/
autoload -Uz history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end

# Use the up and down arrow keys, and Ctrl-n/p, for finding a command in history
# (you can write some initial letters of the command first)
bindkey "^[[A" history-beginning-search-backward-end
bindkey "^[[B" history-beginning-search-forward-end

# Also for Ctrl-p/n
bindkey '^P' history-beginning-search-backward-end
bindkey '^N' history-beginning-search-forward-end

# Ctrl-a/e for beginning/end of line
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line

# Ctrl-u/k for delete to beginning/end of line
bindkey '^U' backward-kill-line
bindkey '^K' kill-line

# Set up native command line editor
autoload -Uz edit-command-line
zle -N edit-command-line

# <Esc> v for editing current prompt in editor
bindkey -M vicmd 'v' edit-command-line

# == Alias ==

# Enable .zsh_aliases if exists
if [[ -f "$HOME/.zsh_aliases" ]]; then
  source "$HOME/.zsh_aliases"
fi

# Utility shortahnds
alias c="clear"
alias q="exit"

# Editors
alias e="$EDITOR"
alias v="$VISUAL"

# Application shorthands
alias g="git"
alias m="make"
alias s="ssh"

if (($+commands[trash])); then
  alias r="trash"
else
  alias r="rm -i"
fi

# File manager (open)
function o {
  if (($+commands[open])); then
    # For macOS
    open ${@:-.} 2>/dev/null &
    disown
  elif grep -qEi "(Microsoft|WSL)" /proc/sys/kernel/osrelease &>/dev/null; then
    # Open in File Explorer (for WSL)
    # https://stackoverflow.com/q/38086185
    explorer.exe ${@:-.}
    (($? == 1))
  else
    xdg-open ${@:-.} 2>/dev/null &
    disown
  fi
}

# Exa/Eza (or ls + tree)
if (($+commands[eza])); then
  alias l='eza --all --long --icons --sort=type --git'
  alias ll='eza --all --long --tree --icons --sort=type --git --ignore-glob="CVS|*.*.package|.svn|.git|.hg|node_modules|bower_components|.next|.svelte-kit|venv"'
else
  alias l='ls -AlhF --group-directories-first --color=auto'
  if (($+commands[tree])); then
    alias ll='tree -CAFa -I "CVS|*.*.package|.svn|.git|.hg|node_modules|bower_components|.next|.svelte-kit|venv" --dirsfirst'
  fi
fi

# Generate ".." shortcuts
# (since paths are set to not be considered executables by themselves)
for i in {1..9}; do
  local alias_name="."
  local relative_path=""
  for j in $(seq $i); do
    alias_name+='.'
    relative_path+='../'
  done
  local line="alias $alias_name='cd $relative_path'"
  eval $line
done

# Zathura / Zaread
if (($+commands[zaread])); then
  # Select only the viewable files (based on extension)
  local za_e=(
    'pdf' 'epub'
    'docx' 'xlsx' 'pptx' 'doc' 'xls' 'ppt'
    # 'mobi' 'csv'
    # 'md' 'rtf' 'typ'
  )
  local za_f=""
  for za_t in "${za_e[@]}"; do
    [ -z $za_f ] && za_f+='-iname \*.'$za_t || za_f+=' -o -iname \*.'$za_t
  done
  local search='$(find -type f \( '$za_f' \) | fzf --cycle --layout=reverse --height=80%)'
  alias za='local f='$search'; zaread $f & disown'
elif (($+commands[zathura])); then
  # Select only the viewable files (based on extension)
  local za_e=('pdf')
  local za_f=""
  for za_t in "${za_e[@]}"; do
    [ -z $za_f ] && za_f+='-iname \*.'$za_t || za_f+=' -o -iname \*.'$za_t
  done
  local search='$(find -type f \( '$za_f' \) | fzf --cycle --layout=reverse --height=80%)'
  alias za='local f='$search'; zathura $f & disown'
fi

# Wezterm
if (($+commands[wezterm])); then
  # Create a new instance of wezterm with the same directory
  # (nice to have for tiling window managers, e.g., i3wm)
  # https://wezfurlong.org/wezterm/troubleshooting.html#increasing-log-verbosity
  alias wezterm-split="WEZTERM_LOG=config=debug,wezterm_font=debug,warn wezterm start --cwd ."

  # Show images in the terminal
  alias imgcat="wezterm imgcat"
fi

# Change to superuser
alias superuser="sudo -Es"

# == Functions ==

# Password generator
function gen-password {
  LC_ALL=C tr -dc '[:graph:]' </dev/urandom | head -c ${1:-20}
  echo
}

# Only define functions if the AUR helper exists
if (($+commands[$AUR_HELPER])); then
  # Package regexes that may require a reboot
  # Based on https://github.com/endeavouros-team/eos-bash-shared/blob/main/eos-reboot-required.hook
  local aur_reboot_pkgs=(
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
  local aur_reboot_check="\s($(
    IFS='|'
    echo "${aur_reboot_pkgs[*]}"
  ))(?=\s)"

  # Update the system and reboot if needed
  function aur-update {
    # Sync databases
    local updates

    if (($+commands[checkupdates])); then
      updates=$(checkupdates --nocolor | awk '{print $1;}' | tr '\n' ' ')
    else
      $AUR_HELPER -Sy
      updates=$($AUR_HELPER -Qu --color=never | awk '{print $1;}' | tr '\n' ' ')
    fi

    if [[ -z $updates ]]; then
      print -P "%F{green}No updates available.%f"
      return
    fi

    # Warn about required reboot
    local reboot_needed=0
    if echo " $updates " | grep -P $aur_reboot_check &>/dev/null; then
      reboot_needed=1
      echo "Packages to update:"
      echo " $updates " | grep -P $aur_reboot_check --color=always | xargs
      read -k1 "answer?Reboot likely needed. Proceed with update? [y/N] "
      echo
      [[ "$answer" =~ ^[yY]$ ]] || return
    fi

    # Perform upgrade
    $AUR_HELPER -Syu --noconfirm
    if (($? == 0)); then
      if ((reboot_needed)); then
        reboot && return
      else
        print -P "%F{green}Update successful. No reboot needed.%f"
      fi
    else
      print -P "%F{red}Update failed using $AUR_HELPER!%f"
    fi

    # Reload autostart scripts (bootup parts only)
    timeout 1s bash -c 'for script in $HOME/.config/autostart/*.sh; do "$script" &>/dev/null & done; wait'

    # Return without errors if it could get to the end
    return 0
  }

  # Remove orphaned packages
  function aur-autoremove {
    $AUR_HELPER -Runs $($AUR_HELPER -Qdtq)
  }
fi

# For homebrew / linuxbrew
if (($+commands[brew])); then
  # Update homebrew
  function brew-update {
    brew update
    brew upgrade
    brew cleanup
    brew doctor
  }
fi

# == Prompt ==

# Detect an in-progress rebase/merge/cherry-pick/revert/bisect/am action
function zsh-git-action {
  local git_dir="$1"
  [[ -z $git_dir ]] && return
  if [[ -f "$git_dir/rebase-merge/interactive" ]]; then
    echo "rebase-i"
  elif [[ -d "$git_dir/rebase-merge" ]]; then
    echo "rebase-m"
  elif [[ -d "$git_dir/rebase-apply" ]]; then
    if [[ -f "$git_dir/rebase-apply/rebasing" ]]; then
      echo "rebase"
    elif [[ -f "$git_dir/rebase-apply/applying" ]]; then
      echo "am"
    else
      echo "am/rebase"
    fi
  elif [[ -f "$git_dir/MERGE_HEAD" ]]; then
    echo "merge"
  elif [[ -f "$git_dir/CHERRY_PICK_HEAD" ]]; then
    echo "cherry-pick"
  elif [[ -f "$git_dir/REVERT_HEAD" ]]; then
    echo "revert"
  elif [[ -f "$git_dir/BISECT_LOG" ]]; then
    echo "bisect"
  fi
}

function zsh-git-status {
  local git_dir=$(git rev-parse --git-dir 2>/dev/null)
  [[ -z $git_dir ]] && return

  local output=""

  # Inter-branch status: commits ahead/behind upstream, and stash count
  local upstream="" has_upstream=false
  if upstream=$(git rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null); then
    has_upstream=true
    local diff=$(git rev-list --left-right --count HEAD...@{u} 2>/dev/null)
    (($(echo "$diff" | awk '{print $1}') > 0)) && output+="↑"
    (($(echo "$diff" | awk '{print $2}') > 0)) && output+="↓"
  fi
  if (($(git rev-list --walk-reflogs --ignore-missing --count refs/stash 2>/dev/null) > 0)); then
    output+="%F{242}⚑%f"
  fi
  [[ -n $output ]] && output+=" "

  # Currently running action (rebase, merge, cherry-pick, ...)
  local action=$(zsh-git-action "$git_dir")
  [[ -n $action ]] && output+="%F{242}${action}%f "

  # Status indicator (single pass over porcelain output)
  local has_staged=false has_unstaged=false has_untracked=false has_conflict=false
  local line x y
  while IFS= read -r line; do
    x="${line[1]}" y="${line[2]}"
    if [[ $x == "?" ]]; then
      has_untracked=true
    elif [[ $x == "U" || $y == "U" || ($x == "A" && $y == "A") || ($x == "D" && $y == "D") ]]; then
      has_conflict=true
    else
      [[ $x != " " ]] && has_staged=true
      if [[ $y == "D" ]]; then
        has_untracked=true
      elif [[ $y != " " ]]; then
        has_unstaged=true
      fi
    fi
  done < <(git status --porcelain 2>/dev/null)

  $has_conflict && output+="%F{red}✗%f "

  # Remote indicator, and remote branch name if it differs from the local one
  local branch=$(git symbolic-ref --short -q HEAD 2>/dev/null)
  if $has_upstream; then
    output+="%F{242}⎇ %f"
    local remote_branch="${upstream#*/}"
    if [[ -n $remote_branch && $remote_branch != $branch ]]; then
      output+="%F{242}(${${remote_branch}//\%/%%})%f "
    fi
  fi

  # Location: branch, or tag, or short commit hash
  local tag=$(git describe --tags --exact-match 2>/dev/null)
  local sha=$(git rev-parse --short HEAD 2>/dev/null)
  if [[ -n $branch ]]; then
    output+="%F{yellow}${${branch}//\%/%%}%f"
  elif [[ -n $tag ]]; then
    output+="%F{242}#%F{yellow}${${tag}//\%/%%}%f"
  else
    output+="%F{242}@%F{yellow}${sha}%f"
  fi

  # Status glyph: same symbol as the matching single state, recolored yellow
  # when it is combined with staged changes
  local status_color="" status_symbol=""
  if $has_staged; then
    if $has_untracked; then
      status_color="%F{yellow}" && status_symbol="?"
    elif $has_unstaged; then
      status_color="%F{yellow}" && status_symbol="!"
    else
      status_color="%F{green}" && status_symbol="+"
    fi
  elif $has_untracked; then
    status_color="%F{red}" && status_symbol="?"
  elif $has_unstaged; then
    status_color="%F{red}" && status_symbol="!"
  fi

  if [ -n "$status_symbol" ]; then
    output+=" ${status_color}${status_symbol}%f"
  fi

  echo "%F{yellow}(%f${output}%F{yellow})%f"
}

_setup_ps1() {
  ## PS1 ##

  # Jobs
  PS1="%(1j.%F{cyan}[%j]%f .)"

  # Username and hostname
  # Hostname is always a different color from the username so they never
  # blend together; it turns orange when remoting in (SSH or similar), as a
  # "you're remote" warning
  local HOST_COLOR="magenta"
  [[ -n "$SSH_CLIENT" || -n "$SSH_TTY" || -n "$SSH_CONNECTION" ]] && HOST_COLOR="208"
  PS1+="%F{green}%n%F{242}@%F{$HOST_COLOR}%m%f "

  # pwd
  PS1+="%F{blue}%~%f "

  # Git branch and status
  if git rev-parse --git-dir &>/dev/null; then
    PS1+="$(zsh-git-status) "
  fi

  # Glyph (special glyph for superuser)
  # Turn red if previous command return != 0
  PS1+="%(?.%F{242}.%F{red})%(!.#.$)%f "

  setopt no_prompt_{bang,subst} prompt_percent # enable/disable correct prompt expansions
}
autoload -Uz add-zsh-hook
add-zsh-hook precmd _setup_ps1

# == FZF ==

# Add completion for fzf
if (($+commands[fzf])); then
  export FZF_DEFAULT_COMMAND="fd -t f -H"
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_CTRL_T_OPTS="--preview='less {}'"
fi

# == ZOXIDE ==

# Add completion for zoxide
# https://github.com/ajeetdsouza/zoxide?tab=readme-ov-file#installation
if (($+commands[zoxide])); then
  eval "$(zoxide init zsh)"
fi

# == Version managers ==

# Based on:
# https://peterlyons.com/problog/2018/01/zsh-lazy-loading/
# https://notes.frederic-hemberger.de/speeding-up-initial-zsh-startup-with-lazy-loading/
# https://github.com/qoomon/zsh-lazyload
# https://sumercip.com/posts/lazyload-zsh/

function lazyload {
  # cmd[] init_code
  local cmd cmds=(${@[1,-2]}) f="${@[-1]}"
  for cmd in $cmds; do
    # https://www.bashsupport.com/zsh/parameter-expansion-flags/q/
    eval \
      "function $cmd {
        unfunction $cmds
        eval ${(qqqq)f} && $cmd \"\$@\"
      }"
  done
}

# Do not lazyload nvm, as node is needed for multiple LSPs and AI interfaces
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"

# To enable enable auto-activation of Python virtualenvs
# (when you are likely doing Python-intensive work),
# call pyenv in advance

# https://github.com/pyenv/pyenv-virtualenv/issues/387#issuecomment-2629477881
lazyload pyenv \
  'eval "$(pyenv init --path)"
  eval "$(pyenv init -)"
  if pyenv commands | grep -q "virtualenv-init"; then eval "$(pyenv virtualenv-init -)"; fi'
