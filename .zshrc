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
plugins=(fzf command-not-found zsh-autosuggestions)
plugins+=(gh fd ripgrep rsync rust yarn)
plugins+=zsh-syntax-highlighting # Must be last of plugins

# Add compdef for zoxide
# https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/zoxide/zoxide.plugin.zsh
if (( $+commands[zoxide] )); then
    eval "$(zoxide init zsh)"
fi

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
unsetopt autocd

# Change less flags
# https://unix.stackexchange.com/questions/566943/how-to-set-less-and-lesspipe-correctly
export LESS=FRX

# Add local scripts to interactive shell
fpath+=~/.config/scripts
autoload -U ~/.config/scripts/*(.:t)

# Add gem path if any
if type "ruby" &>/dev/null; then
    export GEM_HOME="$(ruby -e 'puts Gem.user_dir')"
    path+="$GEM_HOME/bin"
fi

# == Alias ==

# Utility shortcuts
alias c="clear"
alias q="exit"

# Application shortcuts
if (( $+commands[git] )); then
    alias g="git"
fi
if (( $+commands[nvim] )); then
    alias n="nvim"
fi
if (( $+commands[vifm] )); then
    alias f="vifm"
fi
if (( $+commands[yarn] )); then
    alias y="yarn"
fi

# Exa (or ls + tree)
if (( $+commands[yarn] )); then
    alias l='exa --all --long --icons --sort=type --git'
    alias ll='exa --all --long --tree --icons --sort=type --git --ignore-glob="CVS|*.*.package|.svn|.git|.hg|node_modules|bower_components"'
else
    alias l='ls -AlhF --group-directories-first'
    if type "tree" &>/dev/null; then
        alias ll='tree -CAFa -I "CVS|*.*.package|.svn|.git|.hg|node_modules|bower_components" --dirsfirst'
    fi
fi

# Tmux
if (( $+commands[tmux] )); then
    alias t="tmux"
    alias ta="tmux attach || tmux new"
    alias tl="tmux ls"
fi

# Open and disown
function o {
    if (( $+commands["xdg-open"] )); then
        xdg-open "$1" &>/dev/null & disown
    elif (( $+commands[open] )); then
        open "$1" &>/dev/null & disown
    fi
}

# Pretty print paths
function paths {
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

# Get sizes of different directories / files in current directory
# https://superuser.com/questions/605414/how-to-merge-ls-commands-colors-with-the-output-of-find-or-du
function sizes {
    paste <(du $1 -axh -d 1 2>/dev/null | sed 's/\s.*//') <(ls $1 --color=always -1 --almost-all -U) | sort -k1 -hr | less
}

# Update the computer (and reboot if necessary)
# Needs checkupdates
# https://bbs.archlinux.org/viewtopic.php?id=173508
# https://forum.endeavouros.com/t/check-if-a-reboot-is-neccessary/7092
function yay-update {
    # Check if updates (and reboot) is needed
    local updates=$(checkupdates)

    # Words to check for in updates
    local reboot_check="(ucode|cryptsetup|linux|nvidia|mesa|systemd|wayland|xf86-video|xorg)"

    if [[ -n $updates ]]; then
        # Update (and also downgrade if needed)
        yay -Syyuu --noconfirm

        if [[ $updates =~ $reboot_check ]]; then
            reboot
        else
            print -P "%F{green}No need to reboot%f"

        fi
    else
        print -P "%F{green}No need to update%f"
    fi
}

# Re-install (i.e., update) AUR git repositories,
# of which the version is not actively tracked on AUR
# (e.g., neovim nightly: neovim-nightly-bin)
function yay-reinstall {
    for package in "$@"; do
        if pacman -Qi $package &>/dev/null; then
            sudo true
            print -P "%F{green}Reinstalling %F{cyan}$package%F{green}...%f"
            local old_ver=$(pacman -Q $package | grep -o "[0-9]\+.[0-9]\+.*")
            yay -Runs --noconfirm $package >/dev/null
            yay -S --noconfirm $package >/dev/null
            local new_ver=$(pacman -Q $package | grep -o "[0-9]\+.[0-9]\+.*")
            print -P "%F{green}Reinstalled %F{cyan}$package%F{green} from %F{white}$old_ver%F{green} to %F{white}$new_ver%f"
        else
            print -P "%F{red}$package not installed!%f" >/dev/stderr
        fi
    done
}
compdef _pactree yay-reinstall

# Remove orphan packages
function yay-autoremove {
    yay -Runs $(yay -Qdt | cut -d ' ' -f 1)
}

# Quickly create files with their parent directories too
# https://news.ycombinator.com/item?id=9869706
# From https://news.ycombinator.com/item?id=9869231
function create {
    if [ $# -lt 1 ]; then
        echo "Missing argument";
        return 1;
    fi

    for f in "$@"; do
        mkdir -p -- "$(dirname -- "$f")"
        touch -- "$f"
    done
}

# Get the IP address in the form 192.168.x.y
# https://unix.stackexchange.com/questions/119269/how-to-get-ip-address-using-shell-script
function ip-addr {
    ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1  -d'/'
}

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

# Get utility functions from https://github.com/romkatv/gitstatus
if [ ! -d ~/gitstatus ]; then
    git clone --depth=1 https://github.com/romkatv/gitstatus.git ~/gitstatus >/dev/null
fi
source ~/gitstatus/gitstatus.plugin.zsh

local GLYPH=" "

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

local GIT_GITHUB=" "
local GIT_GITLAB=" "
local GIT_BITBUCKET="󰂨 "

_setup_ps1() {
    # Jobs
    PS1="%(1j.%F{cyan}[%j]%f .)"

    # pwd
    PS1+="%F{blue}%(4~|.../%3~|%~)%f"

    # Superuser flag
    PS1+="%(!. %F{red}#%f.)"

    # Chevron
    PS1+=" %(?.%F{blue}.%F{red})$GLYPH%f "

    # RHS prompt: git info
    # Modified from https://github.com/romkatv/gitstatus
    RPROMPT=''
    if gitstatus_query MY && [[ $VCS_STATUS_RESULT == ok-sync ]]; then
        RPROMPT=""

        # Inter-branch status
        (( VCS_STATUS_COMMITS_AHEAD )) && RPROMPT+="$GIT_AHEAD"
        (( VCS_STATUS_COMMITS_BEHIND )) && RPROMPT+="$GIT_BEHIND"
        (( VCS_STATUS_STASHES )) && RPROMPT+="$GIT_STASHED"

        if [ -n $RPROMPT ]; then
            RPROMPT+=" "
        fi

        # Currently running action
        if [[ -n $VCS_STATUS_ACTION ]]; then
            RPROMPT+="%F{yellow}${VCS_STATUS_ACTION}%f "
            (( VCS_STATUS_HAS_CONFLICTED )) && RPROMPT+="$GIT_CONFLICT"
        fi

        # Check if remote exists
        if [[ -n $VCS_STATUS_REMOTE_NAME ]]; then
            if [[ $VCS_STATUS_REMOTE_URL =~ "github" ]]; then
                RPROMPT+="%F{242}$GIT_GITHUB%f"
            elif [[ $VCS_STATUS_REMOTE_URL =~ "gitlab" ]]; then
                RPROMPT+="%F{242}$GIT_GITLAB%f"
            elif [[ $VCS_STATUS_REMOTE_URL =~ "bitbucket" ]]; then
                RPROMPT+="%F{242}$GIT_BITBUCKET%f"
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
        elif (( VCS_STATUS_NUM_UNTRACKED )); then
            RPROMPT+=" $GIT_UNTRACKED"
        elif (( VCS_STATUS_NUM_STAGED )) && (( VCS_STATUS_NUM_UNSTAGED )); then
            RPROMPT+=" $GIT_STAGED_UNSTAGED"
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

# https://unix.stackexchange.com/questions/433273/changing-cursor-style-based-on-mode-in-both-zsh-and-vim
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
# https://apple.stackexchange.com/questions/426084/zsh-how-do-i-get-ctrl-p-and-ctrl-n-keys-to-perform-history-search-backward-forw
bindkey '^P' history-beginning-search-backward
bindkey '^N' history-beginning-search-forward

# Ctrl-u/k for delete to beginning/end of line
bindkey '^U' backward-kill-line
bindkey '^K' kill-line

# Add ^Z-fg
# https://sheerun.net/2014/03/21/how-to-boost-your-vim-productivity/
fancy-ctrl-z () {
    if [[ $#BUFFER -eq 0 ]]; then
        if [[ -n ${jobstates[(r)s*]} ]]; then
            BUFFER="fg"
            zle accept-line
        else
            BUFFER="$VISUAL"
            zle accept-line
        fi
    else
        BUFFER+=""
        zle end-of-line
    fi
}
zle -N fancy-ctrl-z
bindkey '^Z' fancy-ctrl-z

# == FZF ==

if type "fzf" &>/dev/null; then
    export FZF_DEFAULT_COMMAND='fd --type f -H -I -E "*.*.package" -E ".svn" -E ".git" -E ".hg" -E "node_modules" -E "bower_components"'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_CTRL_T_OPTS="--preview='less {}'"
fi
