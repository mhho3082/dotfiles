#!/usr/bin/env bash

config_folder=~/.config/

mkdir -p "$config_folder"

for file in "$(find -type f | \
    sed "/copy_to_config.*/d" | sed "/README.*/d" | \
    sed "/tips\//d" | sed "/\.git\//d")"
do
    cp --parents "$file" "$config_folder" 2>/dev/null
done
