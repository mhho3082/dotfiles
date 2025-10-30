#!/usr/bin/env bash

# The dir where default configs go
# https://unix.stackexchange.com/a/537531
config_dir=${XDG_CONFIG_HOME:-~/.config}
mkdir -p "$config_dir"

# Regex patterns to ignore
ignore_patterns=(
  ".gitignore"
  "copy_to_config.*"
  "README.*"
  ".stylua.*"
  "tips/"
  "makefile"
  "vimium-options.json"
)

# Get all Git files in this repo
# https://stackoverflow.com/a/9429887
dotfiles=$(git ls-files | grep -Ev $(
  IFS='|'
  echo "${ignore_patterns[*]}"
))

# Get the real path of a file, handling Darwin differences
resolve_path() {
  if command -v greadlink &>/dev/null; then
    greadlink -m $@
  else
    readlink -m $@
  fi
}

# Copy executable attribute
copy_chmod() {
  local src=$1
  local dst=$2

  if [[ -f $src && -x $src && -f $dst && ! -x $dst ]]; then
    echo -e "\033[1;32mMaking $dst executable...\033[0m"
    chmod +x "$dst"
  fi
}

# Show diff (if needed) and ask for confirmation to copy
diff_and_ask() {
  local src=$1
  local dst=$2

  # Ask user for confirmation
  if [[ -f "$dst" ]]; then
    # Show diff first
    if command -v difft &>/dev/null; then
      difft "$dst" "$src" --color=always | less -FRX
    else
      diff "$dst" "$src" --color=always | less -FRX
    fi

    read -n1 -p $'Do you want to overwrite \e[34m'$dst$'\e[0m? [y/N] ' answer
    echo
  else
    read -n1 -p $'Do you want to create \e[34m'$dst$'\e[0m? [y/N] ' answer
    echo
  fi

  if [[ "$answer" =~ ^[yY]$ ]]; then
    # Copy file from source to destination,
    # creating necessary dirs if needed
    echo -e "\033[0;32mCopying $src to $dst...\033[0m"
    mkdir -p $(dirname "$dst")
    cp "$src" "$dst"
  else
    echo -e "\033[1;33mSkipping $src...\033[0m"
  fi
}

# Preserve current Git username and email
git_username=$(git config --global user.name)
git_email=$(git config --global user.email)
git_signingkey=$(git config --global user.signingkey)
if [ -n "$git_username" ] || [ -n "$git_email" ] || [ -n "$git_signingkey" ]; then
  echo -e "\033[0;32mWe will preserve your current Git user settings...\033[0m"
fi

# For every file in this repo
for dotfile in $dotfiles; do
  # If the file is not found (deleted from filesystem, but not `git rm` yet), skip it
  # Use red output to alert user to handle the Git issues
  if [[ ! -f $dotfile ]]; then
    echo -e "\033[1;31mCannot find $dotfile (likely deleted), skipping...\033[0m"

    continue
  fi

  if [[ $dotfile != *"/"* ]]; then
    # Copy files that don't use XDG_CONFIG_HOME (indicated by not being in its own dir inside the repo, eg `.zshrc`) to ~/
    config_file=$(resolve_path "${HOME}/${dotfile}")
  else
    config_file=$(resolve_path "${config_dir}/${dotfile}")
  fi

  # No need to handle unmodified files (execpt executable attribute)
  if [[ -f "$config_file" ]] && cmp -s "$dotfile" "$config_file"; then
    # Make necessary files executable (for unmodified files)
    copy_chmod $dotfile $config_file

    continue
  fi

  diff_and_ask "$dotfile" "$config_file"

  # Make necessary files executable (for newly created / modified files)
  copy_chmod $dotfile $config_file
done

# Re-configure Git username and email if needed
if [ -n "$git_username" ] || [ -n "$git_email" ] || [ -n "$git_signingkey" ]; then
  echo -e "\033[0;32mRe-configuring your Git user settings...\033[0m"
  [ -n "$git_username" ] && git config --global user.name "$git_username" || true
  [ -n "$git_email" ] && git config --global user.email "$git_email" || true
  [ -n "$git_signingkey" ] && git config --global user.signingkey "$git_signingkey" || true
fi
