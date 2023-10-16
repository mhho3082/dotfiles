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
plugins+=(gh fd ripgrep yarn rust) # For command auto-completion
plugins+=zsh-syntax-highlighting # Must be last of plugins

# Add compdef for zoxide
# https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/zoxide/zoxide.plugin.zsh
if (( $+commands[zoxide] )); then
    eval "$(zoxide init zsh)"
fi

source $ZSH/oh-my-zsh.sh

# == Base config ==

# Use nvim (or vim, or vi) for editing
if (( $+commands[nvim] )); then
    export VISUAL="nvim"
    export EDITOR="nvim"
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
# https://unix.stackexchange.com/questions/566943/how-to-set-less-and-lesspipe-correctly
export LESS=FRX

# Add local scripts to interactive shell
fpath+=~/.config/scripts
autoload -U ~/.config/scripts/*(.:t)

# Add gem path if any
if (( $+commands[ruby] )); then
    export GEM_HOME="$(ruby -e 'puts Gem.user_dir')"
    path+="$GEM_HOME/bin"
fi

# == Alias ==

# Utility shortahnds
alias c="clear"
alias d="disown"
alias q="exit"

# Application shorthands
if (( $+commands[git] )); then
    alias g="git"
fi
if (( $+commands[yarn] )); then
    alias y="yarn"
fi
if (( $+commands[trash] )); then
    alias r="trash"
else
    alias r="rm -i"
fi

# Defaults
# Editors
alias e="$EDITOR"
alias v="$VISUAL"
# File manager
alias f="xdg-open . 2>/dev/null & disown"

# Exa (or ls + tree)
if (( $+commands[exa] )); then
    alias l='exa --all --long --icons --sort=type --git'
    alias ll='exa --all --long --tree --icons --sort=type --git --ignore-glob="CVS|*.*.package|.svn|.git|.hg|node_modules|bower_components|.next|venv"'
else
    alias l='ls -AlhF --group-directories-first --color=auto'
    if (( $+commands[tree] )); then
        alias ll='tree -CAFa -I "CVS|*.*.package|.svn|.git|.hg|node_modules|bower_components" --dirsfirst'
    fi
fi

# Tmux
if (( $+commands[tmux] )); then
    alias t="tmux"
    alias ta="tmux attach || tmux new"
    alias tl="tmux ls"
fi

# Zathura / Zaread
if (( $+commands[zaread] )); then
    alias za='local f=$(fzf); zaread $f & disown'
elif (( $+commands[zathura] )); then
    alias za='local f=$(fzf); zathura $f & disown'
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

# Pretty print paths
function paths {
    for i in $path; do
        echo $i
    done
}

# Wezterm
if (( $+commands[wezterm] )); then
    # Create a new instance of wezterm with the same directory
    # (nice to have for tiling window managers, e.g., i3wm)
    alias wezterm-split="wezterm start --cwd ."

    # Show images in the terminal
    alias imgcat="wezterm imgcat"
fi

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
function paru-update {
    # Check if updates (and reboot) is needed
    local updates=$(checkupdates)

    # Words to check for in updates
    local reboot_check="(ucode|cryptsetup|linux|nvidia|mesa|systemd|wayland|xf86-video|xorg)"

    if [[ -n $updates ]]; then
        # Update (and also downgrade if needed)
        paru -Syu --noconfirm
        check=$?

        if [[ $check = 0 ]]; then
            if [[ $updates =~ $reboot_check ]]; then
                reboot
            else
                # Re-configure external devices
                xmodmap ~/.Xmodmap &>/dev/null
                autostart &>/dev/null
                print -P "%F{green}No need to reboot%f"
            fi
        else
            # Re-configure external devices
            xmodmap ~/.Xmodmap &>/dev/null
            autostart &>/dev/null
            print -P "%F{red}Paru failed!%f"
        fi
    else
        print -P "%F{green}No need to update%f"
    fi
}

# Specifically force-update package(s)
# helpful for packages not actively tracked on AUR (e.g., neovim-nightly-bin)
function paru-forceupdate {
    if [ -n "$1" ]; then
        # Update specified packages
        paru --noconfirm -S $@
    else
        # Update packages that are likely not actively tracked
        paru --noconfirm -S $(paru -Qq | grep '\-git') $(paru -Qq | grep 'nightly')
    fi
}
compdef _pactree paru-forceupdate

# Remove orphan packages
function paru-autoremove {
    paru -Runs $(paru -Qdt | cut -d ' ' -f 1)
}

# Get the IP address of this machine
# https://unix.stackexchange.com/questions/119269/how-to-get-ip-address-using-shell-script
function ip-addr {
    # Get all IP addresses for this machine
    local all_ips=($(ip addr show | perl -nle 's/inet (\S+)/print $1/e'))

    # Get the main outbound IP address
    local out_ip=$(ip route get 1.1.1.1 | perl -nle 's/src (\S+)/print $1/e')

    # Highlight the main outbound IP address group in print
    for ip_addr in $all_ips; do
        [[ $ip_addr =~ $out_ip ]] && print -P '%F{cyan}'$ip_addr'%f' || echo $ip_addr
    done
}

# WSL-specific alias
# https://stackoverflow.com/questions/38086185/how-to-check-if-a-program-is-run-in-bash-on-ubuntu-on-windows-and-not-just-plain#43618657
if grep -qEi "(Microsoft|WSL)" /proc/sys/kernel/osrelease &>/dev/null; then
    # Open in File Explorer (for WSL)
    alias explorer='explorer.exe .; || true'
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
local GIT_ICONS_GOGS=" "
local GIT_ICONS_BITBUCKET="󰂨 "
local GIT_ICONS_BASIC_REMOTE=" "

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
    if gitstatus_query MY && [[ $VCS_STATUS_RESULT == ok-sync ]]; then
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
            if [[ $VCS_STATUS_REMOTE_URL =~ "github.com" ]]; then
                RPROMPT+="%F{242}$GIT_ICONS_GITHUB%f"
            elif [[ $VCS_STATUS_REMOTE_URL =~ "gitlab.com" ]]; then
                RPROMPT+="%F{242}$GIT_ICONS_GITLAB%f"
            elif [[ $VCS_STATUS_REMOTE_URL =~ "notabug.org" ]]; then
                RPROMPT+="%F{242}$GIT_ICONS_NOTABUG%f"
            elif [[ $VCS_STATUS_REMOTE_URL =~ "codeberg.org" ]]; then
                RPROMPT+="%F{242}$GIT_ICONS_CODEBERG%f"
            elif [[ $VCS_STATUS_REMOTE_URL =~ "gitea.com" ]]; then
                RPROMPT+="%F{242}$GIT_ICONS_GITEA%f"
            elif [[ $VCS_STATUS_REMOTE_URL =~ "gogs.io" ]]; then
                RPROMPT+="%F{242}$GIT_ICONS_GOGS%f"
            elif [[ $VCS_STATUS_REMOTE_URL =~ "bitbucket.org" ]]; then
                RPROMPT+="%F{242}$GIT_ICONS_BITBUCKET%f"
            else
                RPROMPT+="%F{242}$GIT_ICONS_BASIC_REMOTE%f"
            fi

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

if (( $+commands[fzf] )); then
    export FZF_DEFAULT_COMMAND='fd --type f -H -I -E "*.*.package" -E ".svn" -E ".git" -E ".hg" -E "node_modules" -E "bower_components"'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_CTRL_T_OPTS="--preview='less {}'"
fi
