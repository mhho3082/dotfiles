#!/bin/bash

if curl -s -f https://api.github.com >/dev/null; then
    method="curl -s https://api.github.com/gitignore/templates"
else
    if type gh > /dev/null; then
        method="gh api gitignore/templates"
    else
        echo "Rate limited by GitHub!" > /dev/stderr
    fi
fi

select_type=$(
    eval $method | jq --raw-output '.[]' |
    fzf --preview "jq --raw-output .source <($method/{})"
)

if [[ -n $select_type && $select_type != "null" ]]; then
    jq --raw-output .source <(sh -c "$method/$select_type") | $VISUAL -
fi
