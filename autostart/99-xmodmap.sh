#!/usr/bin/env bash

# Auto-reload xmodmap upon keyboard connected

function main {
    xmodmap ~/.Xmodmap
}
main

udevadm monitor --subsystem-match=input | while read -r line; do
    if echo "$line" | grep -E "add"; then
        # Eat up any upcoming data in the next second
        # https://stackoverflow.com/a/69945839
        timeout 1 cat

        main
    fi
done
