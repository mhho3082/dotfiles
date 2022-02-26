set __fish_git_prompt_showcolorhints
set __fish_git_prompt_show_informative_status
set __fish_git_prompt_showupstream "informative"
set __fish_git_prompt_char_cleanstate ""

function fish_prompt --description 'Informative prompt'
    #Save the return status of the previous command
    set -l last_pipestatus $pipestatus
    set -lx __fish_last_status $status # Export for __fish_print_pipestatus.

    if functions -q fish_is_root_user; and fish_is_root_user
        printf '%s@%s %s%s%s# ' $USER (prompt_hostname) (set -q fish_color_cwd_root
                                                         and set_color $fish_color_cwd_root
                                                         or set_color $fish_color_cwd) \
            (prompt_pwd) (set_color normal)
    else
        set -l status_color (set_color $fish_color_status)
        set -l statusb_color (set_color --bold $fish_color_status)
        set -l pipestatus_string (__fish_print_pipestatus "[" "]" "|" "$status_color" "$statusb_color" $last_pipestatus)

        # User
        printf '%s%s@%s ' (set_color brblue) $USER (prompt_hostname)

        # pwd (current location)
        printf '%s%s ' (set_color $fish_color_cwd) $PWD

        # Tmux session name
        if type tmux >/dev/null 2>/dev/null
            if test "$TERM" = "tmux-256color"
                printf '%s[tmux:%s%s%s] ' (set_color normal) (set_color brgreen) (tmux display-message -p "#S") (set_color normal)
            end
        end

        # Git status
        if type git >/dev/null 2>/dev/null
            printf '%s%s ' (set_color normal) (fish_git_prompt | sed '1s/^.//')
        end

        # Pipe status (error code)
        printf '%s ' $pipestatus_string

        # Pointer
        printf '\n> '
    end
end
