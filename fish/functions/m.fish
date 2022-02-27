# Idea from https://dmitryfrank.com/articles/shell_shortcuts

set bookmark_path ~/.cd_bookmarks 

function m --description "cd with bookmarks"
    if test -f $bookmark_path
        set -l dest_dir ( cat $bookmark_path | sed 's|#.*||g' | sed 's|^\~|/home/'"$USER"'|g' | sed '/^\s*$/d' | fzf --preview 'exa {} --all --long --header --icons --sort=ext --git')
        if [ "$dest_dir" != "" ]
            cd $dest_dir
        end
    else
        touch $bookmark_path
    end
end

function ma --description "add to bookmarks"
    echo $PWD >> $bookmark_path
end
