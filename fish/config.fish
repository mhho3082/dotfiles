# == Environment variables ==

if command -v nvim &>/dev/null
    # Let's go Neovim!
    set --global --export VISUAL nvim
    set --global --export EDITOR nvim
else if command -v vim &>/dev/null
    # Vim then
    set --global --export VISUAL vim
    set --global --export EDITOR vim
else
    # Various Arch-based distros does not have Vim pre-installed
    set --global --export VISUAL vi
    set --global --export EDITOR vi
end

# Add `$HOME/.local/bin` to path
# This is where the renamed programs can be symlinked to
mkdir -p $HOME/.local/bin/
fish_add_path $HOME/.local/bin

# Use Vi bindings
fish_vi_key_bindings

# Remove greeting message
set fish_greeting ""

# == Alias ==

# Basic shortcuts
alias c clear
alias q exit
if command -v git &>/dev/null
    alias g git
end
if command -v nvim &>/dev/null
    alias n nvim
end
if command -v ranger &>/dev/null
    alias r ranger
end
if test -f ~/.config/fish/functions/marks.fish
    alias m marks # see ./functions/marks.fish
end

# Exa (or ls + tree)
if command -v exa &>/dev/null
    alias l 'exa --all --long --icons --sort=type --git'
    alias ll 'exa --all --long --tree --icons --sort=type --git --ignore-glob="CVS|*.*.package|.svn|.git|.hg|node_modules|bower_components"'
else
    alias l 'ls -AlhF --group-directories-first'
    if command -v tree &>/dev/null
        alias ll 'tree -CAFa -I "CVS|*.*.package|.svn|.git|.hg|node_modules|bower_components" --dirsfirst'
    end
end

# Tmux
alias t tmux
alias ta 'tmux attach || tmux new'
alias tl 'tmux ls'

# Pretty print paths
alias paths 'for i in $PATH; echo $i; end | less -RF'

# WSL-specific alias
# https://stackoverflow.com/questions/38086185/how-to-check-if-a-program-is-run-in-bash-on-ubuntu-on-windows-and-not-just-plain#43618657
if grep -qEi "(Microsoft|WSL)" /proc/sys/kernel/osrelease &>/dev/null
    # Open in File Explorer (for WSL)
    alias explorer 'explorer.exe .; or true'
end

# == FZF ==

if command -v fzf &>/dev/null
    # Setup fzf with fd as default source
    set --global --export FZF_DEFAULT_COMMAND 'fd --type f -H -I -E "*.*.package" -E ".svn" -E ".git" -E ".hg" -E "node_modules" -E "bower_components"'
    set --global --export FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
    set --global --export FZF_CTRL_T_OPTS "--preview='less {}'"

    # Initiate fzf key bindings
    # <C-t> - find files
    # <C-r> - reverse search command history
    # <A-c> - cd to directory
    fzf_key_bindings
end
