#!/usr/bin/env bash

# The folder where default configs go
config_folder=~/.config/
mkdir -p "$config_folder"

files=$(git ls-files | sed "/copy_to_config.*/d" | sed "/README.*/d" | \
    sed "/.stylua.*/d" | sed "/tips\//d" | sed "/makefile/d")

# Copy file from source to destination,
# creating necessary folders if needed
copy_file() {
    local src=$1
    local dst=$2

    echo "Copying $src to $dst"
    cp --parents "$src" "$config_folder"
    cp "$src" "$dst"
}

# Show diff and ask for confirmation
diff_and_ask() {
    local file=$1
    local original_file=$2

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
        copy_file "$file" "$original_file"
    else
        echo "Skipping $file"
    fi
}

# Check for "-y"
auto_yes=$([[ $1 == "-y" ]] && echo true || echo false)

# For every file in this folder
for file in $files
do
    # These files cannot be linked, and need to be copied to ~/ directly
    if [[ $file == ".Xmodmap" ]] || [[ $file == ".Xresources" ]]; then
        original_file=$(readlink -m "${HOME}/${file}")
    else
        original_file=$(readlink -m "${config_folder}/${file}")
    fi

    if [ -f "$original_file" ] && ! cmp -s "$file" "$original_file"
    then
        # Destination file exists
        if $auto_yes; then
            copy_file "$file" "$original_file"
        else
            diff_and_ask "$file" "$original_file"
        fi
    elif [ ! -f "$original_file" ]; then
        # File does not exist; simply copy it over
        copy_file "$file" "$original_file"
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
