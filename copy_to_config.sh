#!/usr/bin/env bash

# The folder where default configs go
config_folder=~/.config/
mkdir -p "$config_folder"

# The files (from this repo) to copy over
files=$(git ls-files | sed "/copy_to_config.*/d" | sed "/README.*/d" | \
    sed "/.stylua.*/d" | sed "/tips\//d" | sed "/makefile/d")

# These files cannot be linked, and need to be copied to ~/ directly
direct_copy_files=(".Xresources" ".nanorc")

# Function to get the real path of a file
resolve_path() {
    command -v greadlink &> /dev/null && greadlink -m $@ || readlink -m $@
}

# Copy file from source to destination,
# creating necessary folders if needed
copy_file() {
    local src=$1
    local dst=$2

    echo "Copying $src to $dst"
    mkdir -p $(dirname "$dst")
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
    read -p "Do you want to overwrite $original_file? [y/N] " answer
    if [[ "$answer" =~ ^[yY]$ ]]; then
        # Copy the file over, creating parent folders if necessary
        copy_file "$file" "$original_file"
    else
        echo "Skipping $file"
    fi
}

# Check for "-y"
auto_yes=$([[ " $@ " =~ " -y " ]] && echo true || echo false)

# For every file in this folder
for file in $files
do
    if [[ " ${direct_copy_files[@]} " =~ " ${file} " ]]; then
        # Copy non-linkable files to ~/
        original_file=$(resolve_path "${HOME}/${file}")
    else
        original_file=$(resolve_path "${config_folder}/${file}")
    fi

    if [ -f "$original_file" ] && ! cmp -s "$file" "$original_file"; then
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
    if [[ "$(uname)" == "Darwin" ]]; then
        mod=$(stat -f "%A" "$file" | cut -b 1)
    else
        mod=$(stat -c "%a" "$file" | cut -b 1)
    fi
    if ((mod % 2 == 1)); then
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
