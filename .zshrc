# == Environment ==

export EDITOR="${commands[nvim]:+nvim}${commands[nvim]:-${commands[vim]:+vim}${commands[vim]:-vi}}"
export VISUAL="$EDITOR"
export GPG_TTY=$(tty)

[[ -d "$HOME/.local/bin" ]] && path+="$HOME/.local/bin"

# == History ==

HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000
setopt hist_ignore_all_dups hist_ignore_space hist_reduce_blanks

# == Completion ==

autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}'

# == Options ==

setopt prompt_subst no_case_glob
unsetopt beep autocd

# == Key bindings ==

# Use terminfo values so bindings work across terminals
typeset -g -A key
key[Home]="${terminfo[khome]}"
key[End]="${terminfo[kend]}"
key[Up]="${terminfo[kcuu1]}"
key[Down]="${terminfo[kcud1]}"
key[Delete]="${terminfo[kdch1]}"

autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

[[ -n "${key[Home]}"   ]] && bindkey -- "${key[Home]}"   beginning-of-line
[[ -n "${key[End]}"    ]] && bindkey -- "${key[End]}"     end-of-line
[[ -n "${key[Delete]}" ]] && bindkey -- "${key[Delete]}"  delete-char
[[ -n "${key[Up]}"     ]] && bindkey -- "${key[Up]}"      up-line-or-beginning-search
[[ -n "${key[Down]}"   ]] && bindkey -- "${key[Down]}"    down-line-or-beginning-search

bindkey '^A' beginning-of-line
bindkey '^E' end-of-line
bindkey '^U' backward-kill-line
bindkey '^K' kill-line

# Ensure ZLE is in application mode so terminfo values are valid
if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
  autoload -Uz add-zle-hook-widget
  function _zle_app_mode_start { echoti smkx }
  function _zle_app_mode_stop  { echoti rmkx }
  add-zle-hook-widget -Uz zle-line-init   _zle_app_mode_start
  add-zle-hook-widget -Uz zle-line-finish _zle_app_mode_stop
fi

# == Prompt ==

# Sources:
# https://wiki.archlinux.org/title/Zsh#Customized_prompt
# https://wiki.archlinux.org/title/Zsh#Key_bindings

# user@host path [git-branch] $/#
function zsh-git-branch {
  local branch
  branch=$(git symbolic-ref --short -q HEAD 2>/dev/null) || return
  echo " %F{yellow}(${branch})%f"
}

PS1='%F{green}%n%F{242}@%F{magenta}%m%f %F{blue}%~%f$(zsh-git-branch) %(?.%F{242}.%F{red})%(!.#.$)%f '

# == Aliases ==

[[ -f "$HOME/.zsh_aliases" ]] && source "$HOME/.zsh_aliases"

# enable color support of ls and grep
if [ -x /usr/bin/dircolors ]; then
  test -r "$HOME/.dircolors" && eval "$(dircolors -b "$HOME/.dircolors")" || eval "$(dircolors -b)"

  alias ls='ls --color=auto'
  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi
