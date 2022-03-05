set -g fish_prompt_pwd_dir_length 0

set -g __fish_git_prompt_showcolorhints
set -g __fish_git_prompt_showstashstate
set -g __fish_git_prompt_show_informative_status
set -g __fish_git_prompt_showupstream informative
set -g __fish_git_prompt_describe_style branch
set -g __fish_git_prompt_char_cleanstate ""

function fish_prompt --description 'Informative prompt'
    #Save the return status of the previous command
    set -l last_pipestatus $pipestatus
    set -lx __fish_last_status $status # Export for __fish_print_pipestatus.

    set -l status_color (set_color $fish_color_status)
    set -l statusb_color (set_color --bold $fish_color_status)
    set -l pipestatus_string (__fish_print_pipestatus "[" "]" "|" "$status_color" "$statusb_color" $last_pipestatus)

    if functions -q fish_is_root_user; and fish_is_root_user
        printf '%s%s ' (set_color brred) ($USER)
    end

    # Current location
    printf '%s%s ' (set_color brblue) (prompt_pwd)

    # Tmux session name
    if type tmux &>/dev/null
        if test -n "$TMUX"
            printf '%s[S#%s%s%s] ' (set_color normal) (set_color cyan) (tmux display-message -p "#S") (set_color normal)
        end
    end

    # Git status
    if type git &>/dev/null
        printf '%s%s ' (set_color normal) (fish_git_prompt | sed 's/^[ \t]*//' | sed 's/[(]\(.*\)[)]/\[\1\]/')
    end

    # Pipe status (error code)
    printf '%s ' $pipestatus_string

    # Chevron
    printf '\n%s❯%s ' ([ "$last_pipestatus[-1]" -eq 0 ]; and set_color green; or set_color red) (set_color normal)
end
