# Environment variables

# Let's go Neovim!
set --universal --export VISUAL nvim
set --universal --export EDITOR nvim

# == Rename programs ==

# Ubuntu calls fd as such, so...
alias fd 'fdfind -H -I -E ".git"'

# == Alias ==

# Basic shortcuts
alias n 'nvim'
alias c 'clear'
alias q 'exit'

# Exa (or ls + tree)
if which exa >/dev/null
    alias l 'exa --all --long --header --icons --sort=ext --git'
    alias ll 'exa --all --long --tree --header --icons --sort=ext --git --ignore-glob="CVS|*.*.package|.svn|.git|.hg|node_modules|bower_components"'
else
    alias l 'ls -AlhF --group-directories-first'
    if which tree >/dev/null
        alias ll 'tree -CAFa -I "CVS|*.*.package|.svn|.git|.hg|node_modules|bower_components" --dirsfirst'
    end
end

# Tmux
alias t 'tmux'
alias ta 'tmux at || tmux new'

# Git
alias g 'git'
alias ga 'git add'
alias gco 'git checkout'
alias gcp 'git cherry-pick --ff'
alias gd 'git diff'
alias ggl 'git grep --files-with-matches'
alias gl 'git log'
alias gg 'git graph'
alias gs 'git status --short'

# Weather (short and long versions)
alias wttr 'curl "v2d.wttr.in/wan+chai?format=4"'
alias weather 'curl "v2d.wttr.in/wan+chai"'

# Goto c mount (on WSL)
alias cdc 'cd /mnt/c/Users/max/'

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
set --universal --export FZF_DEFAULT_COMMAND 'fdfind --type file --hidden --no-ignore'

# == Interactive settings ==
if status is-interactive
    # Commands to run in interactive sessions
end
