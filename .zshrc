# == Oh-my-zsh ==

# https://lazyren.github.io/devlog/oh-my-zsh-setup.html

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="lukerandall"

# Plugins
plugins=(z fzf vi-mode command-not-found zsh-autosuggestions)
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

# Don't beep
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

# WSL-specific alias
# https://stackoverflow.com/questions/38086185/how-to-check-if-a-program-is-run-in-bash-on-ubuntu-on-windows-and-not-just-plain#43618657
if grep -qEi "(Microsoft|WSL)" /proc/sys/kernel/osrelease &>/dev/null; then
    # Open in File Explorer (for WSL)
    alias explorer='explorer.exe .; or true'
fi

# == FZF ==

if type "fzf" &>/dev/null; then
    export FZF_DEFAULT_COMMAND='fd --type f -H -I -E "*.*.package" -E ".svn" -E ".git" -E ".hg" -E "node_modules" -E "bower_components"'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_CTRL_T_OPTS="--preview='less {}'"
fi
