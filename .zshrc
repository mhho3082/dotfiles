# == Oh-my-zsh ==

# https://lazyren.github.io/devlog/oh-my-zsh-setup.html

export ZSH="$HOME/.oh-my-zsh"

# Turn off completion issues with `sudo -E -s`
export ZSH_DISABLE_COMPFIX=true

# Turn on compinit
autoload -U compinit && compinit
zstyle ':completion:*' menu select

# Plugins
plugins=(z fzf command-not-found zsh-autosuggestions)
# Must be last of plugins
plugins+=zsh-syntax-highlighting

source $ZSH/oh-my-zsh.sh

# == Base config ==

# Use nvim (or vim, or vi) for editing
if type "nvim" &>/dev/null; then
    export VISUAL="nvim"
    export EDITOR="nvim"
elif type "vim" &>/dev/null; then
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

# Change less flags
# https://unix.stackexchange.com/questions/566943/how-to-set-less-and-lesspipe-correctly
export LESS=FRX

# == Alias ==

# Utility shortcuts
alias c="clear"
alias q="exit"

# Application shortcuts
if type "git" &>/dev/null; then
    alias g="git"
fi
if type "nvim" &>/dev/null; then
    alias n="nvim"
fi
if type "vifm" &>/dev/null; then
    alias f="vifm"
fi
if type "yarn" &>/dev/null; then
    alias y="yarn"
fi

# Exa (or ls + tree)
if type "exa" &>/dev/null; then
    alias l='exa --all --long --icons --sort=type --git'
    alias ll='exa --all --long --tree --icons --sort=type --git --ignore-glob="CVS|*.*.package|.svn|.git|.hg|node_modules|bower_components"'
else
    alias l='ls -AlhF --group-directories-first'
    if type "tree" &>/dev/null; then
        alias ll='tree -CAFa -I "CVS|*.*.package|.svn|.git|.hg|node_modules|bower_components" --dirsfirst'
    fi
fi

# Tmux
if type "tmux" &>/dev/null; then
    alias t="tmux"
    alias ta="tmux attach || tmux new"
    alias tl="tmux ls"
fi

# Pretty print paths
paths() {
    for i in $path; do
        echo $i
    done
}

# Prepare virtual network for virt-manager
alias virshprep="sudo virsh net-start default >/dev/null"

# Change to superuser
alias superuser="sudo -Eks"

# Run every autostart script
alias autostart="run-parts --regex '.*sh$' ~/.config/autostart"

# WSL-specific alias
# https://stackoverflow.com/questions/38086185/how-to-check-if-a-program-is-run-in-bash-on-ubuntu-on-windows-and-not-just-plain#43618657
if grep -qEi "(Microsoft|WSL)" /proc/sys/kernel/osrelease &>/dev/null; then
    # Open in File Explorer (for WSL)
    alias explorer='explorer.exe .; or true'
fi

# == Prompt ==

# https://zserge.com/posts/terminal/
# https://voracious.dev/blog/a-guide-to-customizing-the-zsh-shell-prompt
# https://unix.stackexchange.com/questions/273529/shorten-path-in-zsh-prompt
# https://stackoverflow.com/questions/37364631/oh-my-zsh-geometry-theme-git-errors

local GIT_CLEAN="%F{green}ﱣ %f"
local GIT_STASHED="%F{blue}ﱢ %f"
local GIT_STAGED="%F{blue} %f"
local GIT_STAGED_DIRTY="%F{yellow} %f"
local GIT_DIRTY="%F{red} %f"
local GIT_UNTRACKED="%F{red}喝%f"

local GIT_UNPULLED="⇣"
local GIT_UNPUSHED="⇡"
local GIT_REBASE=" "
local GIT_DETACHED=" "

_git_branch() {
    ref=$(git symbolic-ref HEAD 2> /dev/null) || \
        ref=$(git rev-parse --short HEAD 2> /dev/null) || return

    # Handle detached head
    if [ $(git rev-parse --abbrev-ref --symbolic-full-name HEAD) = "HEAD" ]; then
        echo "$GIT_DETACHED${ref#refs/heads/}"
        return
    fi

    # Normal branch
    echo "${ref#refs/heads/}"
}

_git_status() {
    if test -z "$(git status --porcelain --ignore-submodules)"; then
        if test -n "$(git stash list -1)"; then
            echo $GIT_STASHED
        else
            echo $GIT_CLEAN
        fi
    elif test -n "$(git ls-files --others --exclude-standard)"; then
        echo $GIT_UNTRACKED
    elif test -z "$(git diff --name-only)"; then
        echo $GIT_STAGED
    elif test -n "$(git diff --name-only --cached)"; then
        echo $GIT_STAGED_DIRTY
    else
        echo $GIT_DIRTY
    fi
}

_git_rebase_check() {
    git_dir=$(git rev-parse --git-dir)
    if test -d "$git_dir/rebase-merge" -o -d "$git_dir/rebase-apply"; then
        echo "$GIT_REBASE"
    fi
}

_git_remote_check() {
    # Check that a remote repo do exist
    git symbolic-ref refs/remotes/origin/HEAD &>/dev/null || return

    local_commit=$(git rev-parse @ 2>&1)
    remote_commit=$(git rev-parse @{u} 2>&1)
    common_base=$(git merge-base @ @{u} 2>&1) # last common commit

    if [[ $local_commit == $remote_commit ]]; then
        echo ""
    else
        if [[ $common_base == $remote_commit ]]; then
            echo "$GIT_UNPUSHED"
        elif [[ $common_base == $local_commit ]]; then
            echo "$GIT_UNPULLED"
        else
            echo "$GIT_UNPUSHED $GIT_UNPULLED"
        fi
    fi
}

_git_symbol() {
    echo "$(_git_rebase_check) $(_git_remote_check) "
}

_git_info() {
    if git rev-parse --git-dir > /dev/null 2>&1; then
        echo "$(_git_symbol)%F{242}$(_git_branch)%f $(_git_status)"
    fi
}

_setup_ps1() {
    # Chevron (with vi mode indication) setup
    GLYPH=" "
    [ "x$KEYMAP" = "xvicmd" ] && GLYPH=" "

    # Jobs
    PS1="%(1j.%F{cyan}[%j]%f .)"

    # pwd
    PS1+="%F{blue}%(4~|.../%3~|%~)%f"

    # Superuser flag
    PS1+="%(!. %F{red}#%f.)"

    # Chevron
    PS1+=" %(?.%F{blue}.%F{red})$GLYPH%f "

    # RHS prompt: git info
    RPROMPT="$(_git_info)"
}
_setup_ps1

# == Vi mode ==

zle-keymap-select () {
    _setup_ps1
    zle reset-prompt
}
zle -N zle-keymap-select
zle-line-init () {
    zle -K viins
}
zle -N zle-line-init
bindkey -v

# == FZF ==

if type "fzf" &>/dev/null; then
    export FZF_DEFAULT_COMMAND='fd --type f -H -I -E "*.*.package" -E ".svn" -E ".git" -E ".hg" -E "node_modules" -E "bower_components"'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_CTRL_T_OPTS="--preview='less {}'"
fi
