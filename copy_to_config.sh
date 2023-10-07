#!/usr/bin/env bash

# The folder where default configs go
config_folder=~/.config/
mkdir -p "$config_folder"

files=$(find -type f | sed "/copy_to_config.*/d" | sed "/README.*/d" | \
    sed "/.stylua.*/d" | sed "/tips\//d" | sed "/\.git\//d")

# For every file in this folder
for file in $files
do
    if [[ $file == "./.Xmodmap" ]] || [[ $file == "./.Xresources" ]]; then
        original_file=$(realpath "${HOME}/${file}")
    else
        original_file=$(realpath "${config_folder}/${file}")
    fi

    # Check if the file is different
    if ! test -f "$original_file" || ! cmp -s "$file" "$original_file"
    then
        # Copy the file over, creating parent folders if necessary
        echo "Copying $file to $original_file"
        cp --parents "$file" "$config_folder"
        cp "$file" "$original_file"
    fi

    # Make necessary files executable
    mod=$(stat -c "%a" "$file" | cut -b 1)
    if ((mod % 2 == 1))
    then
        chmod +x "$original_file"
    fi
done

# Source files as appropriate
if ! [[ -f ~/.zshrc ]]; then
    echo "Linking Zsh config to ~/"
    echo "source ~/.config/.zshrc" > ~/.zshrc
fi
if ! [[ -f ~/.tmux.conf ]]; then
    echo "Linking Tmux config to ~/"
    echo "source-file ~/.config/tmux/.tmux.conf" > ~/.tmux.conf
fi
