# == Environment variables ==

# Let's go Neovim!
if which nvim &>/dev/null
    set --global --export VISUAL nvim
    set --global --export EDITOR nvim
end

# Check that `$HOME/.local/bin` exists, or create it
if [ ! -d $HOME/.local/bin/ ]
    mkdir -p $HOME/.local/bin/
end

# Add `$HOME/.local/bin` to path
# This is where the renamed programs are symlinked to
fish_add_path $HOME/.local/bin

# Use Vi bindings
fish_vi_key_bindings

# == Alias ==

# Basic shortcuts
alias g git
alias n nvim
alias c clear
alias q exit
alias m marks # see ./functions/marks.fish

# Exa (or ls + tree)
if which exa &>/dev/null
    alias l 'exa --all --long --icons --sort=type --git'
    alias ll 'exa --all --long --tree --icons --sort=type --git --ignore-glob="CVS|*.*.package|.svn|.git|.hg|node_modules|bower_components"'
else
    alias l 'ls -AlhF --group-directories-first'
    if which tree &>/dev/null
        alias ll 'tree -CAFa -I "CVS|*.*.package|.svn|.git|.hg|node_modules|bower_components" --dirsfirst'
    end
end

# Tmux
alias t tmux
alias ta 'tmux at || tmux new'

# Pretty print paths
alias paths 'for i in $PATH; echo $i; end | less -RF'

# == FZF ==

if which fzf &>/dev/null
    # Setup fzf with fd as default source
    set --global --export FZF_DEFAULT_COMMAND 'fd --type f -H -I -E "*.*.package" -E ".svn" -E ".git" -E ".hg" -E "node_modules" -E "bower_components"'
    set --global --export FZF_DEFAULT_OPTS "--preview='less {}'"
    set --global --export FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"

    # Initiate fzf key bindings
    # <C-t> - find files
    # <C-r> - reverse search command history
    # <A-c> - cd to directory
    fzf_key_bindings
end

# == Interactive settings ==

if status is-interactive
    # Commands to run in interactive sessions

    # # Auto-launch tmux (if tmux is closed, fish closes too)
    if which tmux &>/dev/null
        if not set -q TMUX
            exec tmux
        end
    end
end
