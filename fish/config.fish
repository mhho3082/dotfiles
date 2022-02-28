# == Environment variables ==

# Let's go Neovim!
set --universal --export VISUAL nvim
set --universal --export EDITOR nvim

# == Rename programs ==

# Ubuntu calls fd as such, so...
# Note that fish alias are just functions, so this name is not changed for other places
alias fd 'fdfind -H -I -E ".git"'

# == Alias ==

# Basic shortcuts
alias g git
alias n nvim
alias c clear
alias q exit
alias m mark # see ./functions/mark.fish

# Exa (or ls + tree)
if which exa &>/dev/null
    alias l 'exa --all --long --header --icons --sort=ext --git'
    alias ll 'exa --all --long --tree --header --icons --sort=ext --git --ignore-glob="CVS|*.*.package|.svn|.git|.hg|node_modules|bower_components"'
else
    alias l 'ls -AlhF --group-directories-first'
    if which tree &>/dev/null
        alias ll 'tree -CAFa -I "CVS|*.*.package|.svn|.git|.hg|node_modules|bower_components" --dirsfirst'
    end
end

# Tmux
alias t tmux
alias ta 'tmux at || tmux new'

# Weather (short and long versions)
alias wttr 'curl "v2d.wttr.in/wan+chai?format=4"'
alias weather 'curl "v2d.wttr.in/wan+chai"'

# Default flags
alias mkdir 'mkdir -p'
alias ps 'ps -ef'
alias cp 'cp -r'
alias scp 'scp -r'
alias df 'df -h'
alias du 'du -h -d 2'
alias free 'free -h'
alias xsel 'xsel -b'
alias uptime 'uptime -p'

# == FZF ==

# Setup fzf with fd as default source
set --universal --export FZF_DEFAULT_COMMAND 'fdfind --type file -H -I -E ".git"'

# == Interactive settings ==

if status is-interactive
    # Commands to run in interactive sessions
end
