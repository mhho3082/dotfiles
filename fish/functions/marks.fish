# Idea from https://dmitryfrank.com/articles/shell_shortcuts

# Requires fzf

# Location of bookmark file
set bookmark_path ~/.cd_bookmarks

# Add preview
if which exa &>/dev/null
    set preview_string 'exa {} --all --long --header --icons --sort=ext --git'
else
    set preview_string 'ls {} -AlhF --group-directories-first'
end

# Add completion
set -l bookmark_commands add edit remove
complete -f -c marks -n "not __fish_seen_subcommand_from $bookmark_commands" -a add -d "Add current pwd to bookmarks"
complete -f -c marks -n "not __fish_seen_subcommand_from $bookmark_commands" -a edit -d "Edit bookmarks"
complete -f -c marks -n "not __fish_seen_subcommand_from $bookmark_commands" -a remove -d "Remove current pwd from bookmarks"

function marks --description "cd with bookmarks"
    if begin [ "$argv[1]" = a ]; or [ "$argv[1]" = "add" ]; end # Add pwd to bookmarks
        # Add only if not found
        if ! grep -Fxq "$PWD" $bookmark_path
            echo $PWD >>$bookmark_path
        end

        # Sort the bookmarks
        sort -o $bookmark_path{,}
        return
    end

    if begin [ "$argv[1]" = e ]; or [ "$argv[1]" = "edit" ]; end # Edit bookmarks
        # Allow editing of bookmarks
        $VISUAL $bookmark_path

        # Expand ~
        sed -i -e 's|^\~|/home/'"$USER"'|' $bookmark_path

        # Remove trailing /
        sed -i -e 's|/$||' $bookmark_path

        # Remove duplicates
        gawk -i inplace '!a[$0]++' $bookmark_path

        # Remove empty lines
        sed -i '/^$/d' $bookmark_path
        
        # Sort the bookmarks
        sort -o $bookmark_path{,}
        return
    end

    if begin [ "$argv[1]" = r ]; or [ "$argv[1]" = "remove" ]; end # Remove pwd from bookmarks
        # Find and remove pwd (except newline)
        sed -i -e 's|^'"$PWD"'$||' $bookmark_path

        # Remove the newline
        sed -i '/^$/d' $bookmark_path
        return
    end

    # The core function
    if which fzf &>/dev/null
        # Create file if not found
        if test ! -f $bookmark_path
            touch $bookmark_path
        end

        set -l dest_dir ( cat $bookmark_path |
                          sed 's|^\~|/home/'"$USER"'|' | # Expand ~
                          sed 's|/$||' |                 # Remove trailing /
                          sed '/^\s*$/d' |               # Remove leading whitespace
                          sed '/^*\s$/d' |               # Remove trailing whitespace
                          sort | uniq |                  # Remove duplicates
                          fzf --preview $preview_string  --prompt="marks> ")

        if [ "$dest_dir" != "" ]
            cd $dest_dir
        end
    else
        echo "fzf not installed"
    end
end
