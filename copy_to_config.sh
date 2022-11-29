#!/usr/bin/env bash

# The folder where default configs go
config_folder=~/.config/
mkdir -p "$config_folder"

# For every file in this folder
for file in $(find -type f | \
    sed "/copy_to_config.*/d" | sed "/README.*/d" | \
    sed "/tips\//d" | sed "/\.git\//d")
do
    # Copy the file over, creating parent folders if necessary
    cp --parents "$file" "$config_folder" 2>/dev/null

    # Make necessary files executable
    mod=$(stat -c "%a" "$file" | cut -b 1)
    if ((mod % 2 == 1))
    then
        chmod +x "$config_folder"/"$file"
    fi
done
