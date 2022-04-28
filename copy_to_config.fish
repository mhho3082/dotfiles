#!/usr/bin/fish

# Copies files starting with . with **/.*
# Currently does not copy folders starting with . (e.g., .git/), but can be enabled with .**/* .**/.*

# Do not add quotation marks; fish auto-expands paths here
set config_folder ~/.config/
# set config_folder ./temp/

set ignore_files copy_to_config.fish README.md tips/*

mkdir -p "$config_folder"

for i in ** **/.*
    if [ -f $i ]; and not contains $i $ignore_files
        cp --parents "$i" "$config_folder"
    end
end
