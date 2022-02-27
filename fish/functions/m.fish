# Idea from https://dmitryfrank.com/articles/shell_shortcuts

# Location of bookmark file
set bookmark_path ~/.cd_bookmarks

# Add preview
if which exa &>/dev/null
    set preview_string 'exa {} --all --long --header --icons --sort=ext --git'
else
    set preview_string 'ls {} -AlhF --group-directories-first'
end

function m --description "cd with bookmarks"
    if which fzf &>/dev/null
        if test -f $bookmark_path

            set -l dest_dir ( cat $bookmark_path | sed 's|#.*||g' | sed 's|^\~|/home/'"$USER"'|g' | sed '/^\s*$/d' | fzf --preview $preview_string)

            if [ "$dest_dir" != "" ]
                cd $dest_dir
            end
        else
            touch $bookmark_path
            echo "$bookmark_path created"
        end
    else
        echo "fzf not installed"
    end
end

function ma --description "add to bookmarks"
    echo $PWD >>$bookmark_path
end
