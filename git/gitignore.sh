#!/bin/bash

if [ -f $(git rev-parse --show-toplevel 2>/dev/null)/.gitignore ]; then
    echo 'Ignore file already exists!' > /dev/stderr
    exit 1
fi

if type gh &> /dev/null; then
    method='gh api gitignore/templates'
elif curl -s -f https://api.github.com &>/dev/null; then
    method='curl -s https://api.github.com/gitignore/templates'
else
    echo 'Rate limited by GitHub!' > /dev/stderr
    exit 1
fi

select_type=$(
    eval $method | jq --raw-output '.[]' |
    fzf --layout=reverse --height=80% \
        --preview "jq --raw-output .source <($method/{})" --preview-window=wrap
)

if [[ -n $select_type && $select_type != 'null' ]]; then
    jq --raw-output .source <(sh -c "$method/$select_type") | $VISUAL - '+f .gitignore'
fi
