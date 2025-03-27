# == Oh-my-zsh ==

# https://lazyren.github.io/devlog/oh-my-zsh-setup.html

export ZSH="$HOME/.oh-my-zsh"

# Auto-install omz if needed
if ! test -d $ZSH; then
  export RUNZSH=no
  export KEEP_ZSHRC=yes
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

  # Force-link the zshrc to this one
  echo "source ~/.config/.zshrc" > ~/.zshrc
fi

# Auto-install external plugins if needed

# Modified from https://github.com/mattmc3/zsh_unplugged
function plugin-load {
  local repo plugdir initfile
  ZPLUGINDIR=${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins
  for repo in $@; do
    plugdir=$ZPLUGINDIR/${repo:t}
    initfile=$plugdir/${repo:t}.plugin.zsh
    if [[ ! -d $plugdir ]]; then
      echo "Cloning $repo..."
      git clone -q --depth 1 --recursive --shallow-submodules https://github.com/$repo $plugdir
    fi
  done
}
local repos=(
  zsh-users/zsh-autosuggestions
  zsh-users/zsh-syntax-highlighting
)
plugin-load $repos

# Turn off completion issues with `sudo -E -s`
export ZSH_DISABLE_COMPFIX=true

# Turn on compinit
autoload -U compinit && compinit

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

# Plugins
plugins=(fzf command-not-found zsh-autosuggestions) # Add functionalities
plugins+=(gh npm yarn rust) # For command auto-completion
plugins+=zsh-syntax-highlighting # Must be last of plugins

# Add compdef for zoxide
# https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/zoxide/zoxide.plugin.zsh
if (( $+commands[zoxide] )); then
  eval "$(zoxide init zsh)"
fi

# Save all non-plugin alias
# https://unix.stackexchange.com/q/161973
save_aliases=$(alias -L)

source $ZSH/oh-my-zsh.sh

# Remove all alias from plugins, and restore the rest
unalias -m '*'
eval $save_aliases; unset save_aliases

# == Base config ==

# Use nvim (or vim, or vi) for editing
if (( $+commands[nvim] )); then
  export VISUAL="nvim"
  export EDITOR="nvim"

  # Use nvim as manpager
  export MANPAGER='nvim +Man!'

  # Use nvim as ssh client
  # https://gist.github.com/jsongerber/7dfd9f2d22ae060b98e15c5590c4828d
  function oil-ssh {
    host=${1:-$(grep '^Host ' ~/.ssh/config | awk '{ for (i=2; i<=NF; i++) print $i }' | fzf --cycle --layout=reverse --height=80%)}
    [ -z "$host" ] && return 1
    user=${2:-$(ssh -G "$host" | grep '^user\>'  | sed 's/^user //')}
    if ! ssh-add -l &>/dev/null; then ssh-add; fi
    nvim '+lua require("oil").open()' oil-ssh://"$user"@"$host"/
  }
elif (( $+commands[vim] )); then
  export VISUAL="vim"
  export EDITOR="vim"
else
  export VISUAL="vi"
  export EDITOR="vi"
fi

# Modify history
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000

# Change zsh options
setopt correct
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt prompt_subst
unsetopt beep
unsetopt autocd

# Change less flags
# https://unix.stackexchange.com/q/566943
export LESS=FRX

# Add local scripts to interactive shell
fpath+=~/.config/scripts
autoload -U ~/.config/scripts/*(.:t)

# Add gem path if any
if (( $+commands[ruby] )); then
  export GEM_HOME="$(ruby -e 'puts Gem.user_dir')"
  path+="$GEM_HOME/bin"
fi

# Set GPG's tty to the current one
# https://unix.stackexchange.com/a/724766
export GPG_TTY=$(tty)

# == Alias ==

# Utility shortahnds
alias c="clear"
alias d="disown"
alias q="exit"

# Editors
alias e="$EDITOR"
alias v="$VISUAL"

# Application shorthands
alias g="git"
alias m="make"
# NPM
alias n="npm"
alias nd="npm run dev"
# Yarn
alias y="yarn"
alias yd="yarn dev"
alias yx="yarn dlx"
# Tmux
alias t="tmux"
alias ta="tmux attach || tmux new"
alias tl="tmux ls"

if (( $+commands[trash] )); then
  alias r="trash"
else
  alias r="rm -i"
fi

# File manager (open)
function o {
  if (( $+commands[open] )); then
    # For macOS
    open ${@:-.} 2>/dev/null & disown
  elif grep -qEi "(Microsoft|WSL)" /proc/sys/kernel/osrelease &>/dev/null; then
    # Open in File Explorer (for WSL)
    # https://stackoverflow.com/q/38086185
    explorer.exe ${@:-.}; (( $? == 1 ))
  else
    xdg-open ${@:-.} 2>/dev/null & disown
  fi
}

# Exa/Eza (or ls + tree)
if (( $+commands[eza] )); then
  alias l='eza --all --long --icons --sort=type --git --hyperlink'
  alias ll='eza --all --long --tree --icons --sort=type --git --hyperlink --ignore-glob="CVS|*.*.package|.svn|.git|.hg|.svelte-kit|node_modules|bower_components|.next|venv"'
else
  alias l='ls -AlhF --group-directories-first --color=auto'
  if (( $+commands[tree] )); then
    alias ll='tree -CAFa -I "CVS|*.*.package|.svn|.git|.hg|node_modules|bower_components" --dirsfirst'
  fi
fi

# Generate ".." shortcuts
# (since paths are set to not be considered executables by themselves)
for i in {1..9}; do
  local alias_name="."
  local relative_path=""
  for j in `seq $i`; do
    alias_name+='.'
    relative_path+='../'
  done
  local line="alias $alias_name='cd $relative_path'"
  eval $line
done

# Zathura / Zaread
if (( $+commands[zaread] )); then
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
elif (( $+commands[zathura] )); then
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
if (( $+commands[wezterm] )); then
  # Create a new instance of wezterm with the same directory
  # (nice to have for tiling window managers, e.g., i3wm)
  # https://wezfurlong.org/wezterm/troubleshooting.html#increasing-log-verbosity
  alias wezterm-split="WEZTERM_LOG=config=debug,wezterm_font=debug,warn wezterm start --cwd ."

  # Show images in the terminal
  alias imgcat="wezterm imgcat"
fi

# Prepare virtual network for virt-manager
alias virshprep="sudo virsh net-start default >/dev/null"

# Change to superuser
alias superuser="sudo -Eks"

# == Functions ==

# Pretty print paths
function paths {
  for i in $path; do
    echo $i
  done
}

# Run every autostart script
function autostart {
  timeout 1s bash -c 'for script in ~/.config/autostart/*.sh; do "$script" &>/dev/null & done; wait'
}

# Get sizes of different directories / files in current directory
# https://superuser.com/q/605414/
function sizes {
  paste <(du $1 -axh -d 1 2>/dev/null | sed 's/\s.*//') <(ls $1 --color=always -1 --almost-all -U) | sort -k1 -hr | less
}

# Get the IP address of this machine
# https://unix.stackexchange.com/q/119269
function ip-addr {
  # Get all IP addresses for this machine
  local all_ips=($(ip addr show | perl -nle 's/inet (\S+)/print $1/e'))

  # Get the main outbound IP address
  local out_ip=$(ip route get 8.8.8.8 | perl -nle 's/src (\S+)/print $1/e')

  # Highlight the main outbound IP address group in print
  for ip_addr in $all_ips; do
    [[ $ip_addr =~ $out_ip ]] && print -P '%F{cyan}'$ip_addr'%f' || echo $ip_addr
  done
}

# Get n-letters long alias and functions
# (helpful to get a wider picture)
function shorthands {
  # Use 1 if none provided
  local length=${1:-1}

  # Generate grep checker
  local letters=$(printf '[a-z]%.0s' {1..$length})

  # Get alias with correct length
  local alias_list=$(alias | grep '^'$letters'=')

  # Print alias if any
  if [[ -n $alias_list ]]; then
    print -P '%F{cyan}alias%f'
    echo $alias_list | grep '^'$letters
  fi

  # Get functions with correct length
  local functions_list=$(for f in $(print -l ${(ok)functions} | grep '^'$letters'$'); do
      if ! [[ $(type $f) =~ ".*is an alias for.*" ]]; then
        # Get function definition
        local definition=$(functions $f | tr '\n' ' ' | sed 's/[[:space:]]\+/ /g')
        if [[ ${#definition} -ge 50 ]]; then
          echo "$(echo $definition | head -c 50)..."
        else
          echo $definition
        fi
      fi
  done)

  # Print functions if any
  if [[ -n $functions_list ]]; then
    print -P '\n%F{cyan}functions%f'
    echo $functions_list | grep '^'$letters
  fi

}

# Edit the content of the most recent clipboard
if (( $+commands[xsel] )); then
  function clipedit {
    tempfile=$(mktemp)
    xsel -ob > "$tempfile"
    $VISUAL "$tempfile"
    xsel -ib < "$tempfile"
    rm "$tempfile"
  }
fi

if (( $+commands[paru] )); then
  # Update the computer (and reboot if necessary)
  # https://bbs.archlinux.org/viewtopic.php?id=173508
  # https://forum.endeavouros.com/t/check-if-a-reboot-is-neccessary/7092
  function paru-update {
    # Sync databases and list updates needed
    paru -Sy
    local updates=$(paru -Qu --color=always)

    # Words to check for in updates
    local reboot_check="(ucode|cryptsetup|linux|nvidia|mesa|systemd|wayland|xf86-video|xorg)"

    # No need to update - skip
    if [[ -z $updates ]]; then
      print -P "%F{green}No need to update%f"
      return
    fi

    # Need to reboot, ask for confirm
    if [[ $updates =~ $reboot_check ]]; then
      echo $updates
      read -k1 "answer?Reboot will be needed, are you sure? [y/N] "
      echo
      [[ "$answer" =~ ^[yY]$ ]] || return
    fi

    # Run the update
    paru -Su --noconfirm
    if (( $? == 0 )); then
      if [[ $updates =~ $reboot_check ]]; then
        reboot && return
      else
        print -P "%F{green}No need to reboot%f"
      fi
    else
      print -P "%F{red}Paru failed!%f"
    fi

    # Reload autostart scripts (but only their bootup parts)
    timeout 1s bash -c 'for script in ~/.config/autostart/*.sh; do "$script" &>/dev/null & done; wait'
    return
  }

  # Remove orphan packages
  function paru-autoremove {
    local orphans=$(paru -Qdtq) && [[ -n $orphans ]] && paru -Runs $orphans || print -P "%F{red}No orphan package to remove%f"
  }
fi

# == Prompt ==

# https://zserge.com/posts/terminal/
# https://voracious.dev/blog/a-guide-to-customizing-the-zsh-shell-prompt
# https://unix.stackexchange.com/q/273529
# https://stackoverflow.com/q/37364631

# Get utility functions from https://github.com/romkatv/gitstatus
local gitstatus_repo="$HOME/.gitstatus"
if [ ! -d $gitstatus_repo ]; then
  git clone --depth=1 https://github.com/romkatv/gitstatus.git $gitstatus_repo >/dev/null
fi
source $gitstatus_repo/gitstatus.plugin.zsh

local GIT_CLEAN="%F{blue}󰝥 %f"
local GIT_STAGED="%F{green}󰋘 %f"
local GIT_UNSTAGED="%F{red}󰋙 %f"
local GIT_STAGED_UNSTAGED="%F{yellow}󰋙 %f"
local GIT_UNTRACKED="%F{red}󰔷 %f"
local GIT_STAGED_UNTRACKED="%F{yellow}󰔷 %f"

local GIT_BEHIND="⇣"
local GIT_AHEAD="⇡"
local GIT_STASHED="󰈻 "

local GIT_CONFLICT="%F{red}  %f"

local GIT_ICONS_GITHUB=" "
local GIT_ICONS_GITLAB=" "
local GIT_ICONS_NOTABUG="󱇪 "
local GIT_ICONS_CODEBERG=" "
local GIT_ICONS_GITEA="󰶞 "
local GIT_ICONS_GOGS=" "
local GIT_ICONS_BITBUCKET="󰂨 "
local GIT_ICONS_BASIC_REMOTE="󰘬 "

local GLYPH=""
local SUPERUSER_GLYPH=""
local TMUX_GLYPH="%F{green}%f"
local VENV_GLYPH="%F{yellow}%f"

_setup_ps1() {
  ## PS1 ##

  # Jobs
  PS1="%(1j.%F{cyan}[%j]%f .)"

  # pwd
  PS1+="%F{blue}%(4~|.../%3~|%~)%f "

  # Is in tmux?
  if [ -n "$TMUX" ]; then
    PS1+="$TMUX_GLYPH "
  fi

  # Is in Python venv?
  if [ -n "$VIRTUAL_ENV" ]; then
    PS1+="$VENV_GLYPH "
  fi

  # Glyph (special glyph for superuser)
  # Turn red if previous command return != 0
  PS1+="%(?.%F{cyan}.%F{red})%(!.$SUPERUSER_GLYPH.$GLYPH)%f "

  ## RPROMPT ##

  # RHS prompt: git info
  # Modified from https://github.com/romkatv/gitstatus
  RPROMPT=""
  if gitstatus_query 'MY' && [[ $VCS_STATUS_RESULT == ok-sync ]]; then
    # Inter-branch status
    (( VCS_STATUS_COMMITS_AHEAD )) && RPROMPT+="$GIT_AHEAD"
    (( VCS_STATUS_COMMITS_BEHIND )) && RPROMPT+="$GIT_BEHIND"
    (( VCS_STATUS_STASHES )) && RPROMPT+="$GIT_STASHED"

    if [[ -n $RPROMPT ]]; then
      RPROMPT+=" "
    fi

    # Currently running action
    if [[ -n $VCS_STATUS_ACTION ]]; then
      RPROMPT+="%F{yellow}${VCS_STATUS_ACTION}%f "
      (( VCS_STATUS_HAS_CONFLICTED )) && RPROMPT+="$GIT_CONFLICT"
    fi

    # Check if remote exists
    if [[ -n $VCS_STATUS_REMOTE_NAME ]]; then
      # Show correct hosting service icon if appropriate
      # https://www.baeldung.com/linux/one-case-multiple-conditions#case-statements-with-fallthrough
      case $VCS_STATUS_REMOTE_URL in
        *"github.com"*)    RPROMPT+="%F{242}$GIT_ICONS_GITHUB%f"       ;;
        *"gitlab.com"*)    RPROMPT+="%F{242}$GIT_ICONS_GITLAB%f"       ;;
        *"notabug.org"*)   RPROMPT+="%F{242}$GIT_ICONS_NOTABUG%f"      ;;
        *"codeberg.org"*)  RPROMPT+="%F{242}$GIT_ICONS_CODEBERG%f"     ;;
        *"gitea.com"*)     RPROMPT+="%F{242}$GIT_ICONS_GITEA%f"        ;;
        *"gogs.io"*)       RPROMPT+="%F{242}$GIT_ICONS_GOGS%f"         ;;
        *"bitbucket.org"*) RPROMPT+="%F{242}$GIT_ICONS_BITBUCKET%f"    ;;
        *)                 RPROMPT+="%F{242}$GIT_ICONS_BASIC_REMOTE%f" ;;
      esac

      # Show remote name if different
      if [[ $VCS_STATUS_LOCAL_BRANCH != $VCS_STATUS_REMOTE_BRANCH ]]; then
        RPROMPT+="%F{242}(${${VCS_STATUS_REMOTE_BRANCH}//\%/%%}) %f"
      fi
    fi

    # Branch name
    # Modified from https://github.com/romkatv/gitstatus/blob/master/gitstatus.prompt.zsh
    if [[ -n $VCS_STATUS_LOCAL_BRANCH ]]; then
      RPROMPT+="%F{242}${${VCS_STATUS_LOCAL_BRANCH}//\%/%%}%f"
    elif [[ -n $VCS_STATUS_TAG ]]; then
      RPROMPT+="#%F{242}${${VCS_STATUS_TAG}//\%/%%}%f"
    else
      RPROMPT+="@%F{242}${${VCS_STATUS_COMMIT:0:8}//\%/%%}%f"
    fi

    # Within-branch status
    if (( VCS_STATUS_NUM_STAGED )) && (( VCS_STATUS_NUM_UNTRACKED )); then
      RPROMPT+=" $GIT_STAGED_UNTRACKED"
    elif (( VCS_STATUS_NUM_STAGED )) && (( VCS_STATUS_NUM_UNSTAGED_DELETED )); then # deleted is also a type of untracked
      RPROMPT+=" $GIT_STAGED_UNTRACKED"
    elif (( VCS_STATUS_NUM_STAGED )) && (( VCS_STATUS_NUM_UNSTAGED )); then
      RPROMPT+=" $GIT_STAGED_UNSTAGED"
    elif (( VCS_STATUS_NUM_UNTRACKED )) || (( VCS_STATUS_NUM_UNSTAGED_DELETED )); then
      RPROMPT+=" $GIT_UNTRACKED"
    elif (( VCS_STATUS_NUM_UNSTAGED )); then
      RPROMPT+=" $GIT_UNSTAGED"
    elif (( VCS_STATUS_NUM_STAGED )); then
      RPROMPT+=" $GIT_STAGED"
    else
      RPROMPT+=" $GIT_CLEAN"
    fi
  fi

  setopt no_prompt_{bang,subst} prompt_percent  # enable/disable correct prompt expansions
}
gitstatus_stop 'MY' && gitstatus_start -s -1 -u -1 -c -1 -d -1 'MY'
autoload -Uz add-zsh-hook
add-zsh-hook precmd _setup_ps1

# == Vi mode ==

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
function _default_cursor {
  echo -ne $CURSOR_INSERT
}
precmd_functions+=(_default_cursor)

# Ctrl-a/e for beginning/end of line
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line

# Ctrl-n/p for history
# https://apple.stackexchange.com/q/426084/
bindkey '^P' history-beginning-search-backward
bindkey '^N' history-beginning-search-forward

# Ctrl-u/k for delete to beginning/end of line
bindkey '^U' backward-kill-line
bindkey '^K' kill-line

# == FZF ==

if (( $+commands[fzf] )); then
  export FZF_DEFAULT_COMMAND='fd --type f -H -I -E "*.*.package" -E ".svn" -E ".git" -E ".hg" -E "node_modules" -E "bower_components"'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_CTRL_T_OPTS="--preview='less {}'"
fi

# == NVM ==

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
