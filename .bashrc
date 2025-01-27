# Handy aliases
alias l='ls -AlhF'
alias g='git'
alias c='clear'
alias q='exit'

# Use the up and down arrows to cycle through commands
# (You can write some initial letters of the command first)
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

# For GitHub commit links in Markdown
function gh-sha-md() {
    local remote_url=$(git config --get remote.origin.url | sed 's|^git@|https://|' | sed 's@.git$@@')
    if [[ " $* " == *" -b "* ]]; then
        local branch=$(git rev-parse --abbrev-ref HEAD)
        local branch_str="[\`$branch\`]($remote_url/commits/$branch)"
    else
        local branch_str=""
    fi
    echo "$branch_str [\`#$(git rev-parse --short HEAD)\`]($remote_url/commit/$(git rev-parse HEAD))" |
        xargs echo # https://stackoverflow.com/a/12973694
}

# For GitLab commit links in Markdown
function gl-sha-md() {
    local remote_url="$(git config --get remote.origin.url | sed 's@:@/@' | sed 's|^git@|https://|' | sed 's@.git$@@')"

    if [[ " $* " == *" -b "* ]]; then
        local branch=$(git rev-parse --abbrev-ref HEAD)
        local branch_str="[\`$branch\`]($remote_url/-/commits/$branch?ref_type=heads)"
    else
        local branch_str=""
    fi

    echo "$branch_str [\`#$(git rev-parse --short HEAD)\`]($remote_url/-/commit/$(git rev-parse HEAD))" |
        xargs echo # https://stackoverflow.com/a/12973694
}

alias sha-md=gl-sha-md
