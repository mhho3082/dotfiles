#!/usr/bin/env bash

# The folder where default configs go
config_folder=~/.config/
mkdir -p "$config_folder"

files=$(git ls-files | sed "/copy_to_config.*/d" | sed "/README.*/d" | \
    sed "/.stylua.*/d" | sed "/tips\//d" | sed "/makefile/d")

# For every file in this folder
for file in $files
do
    # These files cannot be linked, and need to be copied to ~/ directly
    if [[ $file == ".Xmodmap" ]] || [[ $file == ".Xresources" ]]; then
        original_file=$(readlink -m "${HOME}/${file}")
    else
        original_file=$(readlink -m "${config_folder}/${file}")
    fi

    # Check if the destination file exists and compare it
    if [ -f "$original_file" ] && ! cmp -s "$file" "$original_file"
    then
        if command -v difft &> /dev/null; then
            difft "$original_file" "$file"
        else
            diff "$original_file" "$file"
        fi

        # Ask user if they want to overwrite the file
        read -p "Do you want to overwrite $original_file? (y/N) " answer
        if [[ "$answer" == "y" || "$answer" == "Y" ]]
        then
            # Copy the file over, creating parent folders if necessary
            echo "Copying $file to $original_file"
            cp --parents "$file" "$config_folder"
            cp "$file" "$original_file"
        else
            echo "Skipping $file"
        fi
    elif [ ! -f "$original_file" ]; then
        # File does not exist, simply copy it
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
