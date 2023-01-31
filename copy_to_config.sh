#!/usr/bin/env bash

# The folder where default configs go
config_folder=~/.config/
mkdir -p "$config_folder"

# For every file in this folder
for file in $(find -type f | sed "/copy_to_config.*/d" | \
    sed "/README.*/d" | sed "/tips\//d" | sed "/\.git\//d")
do
    original_file="${config_folder}/${file}"

    # Check if the file is different
    if ! test -f "$original_file" || ! cmp -s "$file" "$original_file"
    then
        # Copy the file over, creating parent folders if necessary
        echo "$file"
        cp --parents "$file" "$config_folder" 2>/dev/null
    fi

    # Make necessary files executable
    mod=$(stat -c "%a" "$file" | cut -b 1)
    if ((mod % 2 == 1))
    then
        chmod +x "$original_file"
    fi
done
