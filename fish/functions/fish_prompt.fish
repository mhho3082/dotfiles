# pwd length
set -g fish_prompt_pwd_dir_length 0

# Git prompt setup
set -g __fish_git_prompt_showcolorhints
set -g __fish_git_prompt_showstashstate
set -g __fish_git_prompt_show_informative_status
set -g __fish_git_prompt_showupstream informative
set -g __fish_git_prompt_describe_style branch

# Git prompt icons
set __fish_git_prompt_char_stateseparator ' | '
set __fish_git_prompt_char_cleanstate ' '
set __fish_git_prompt_char_dirtystate ' '
set __fish_git_prompt_char_invalidstate ' '
set __fish_git_prompt_char_stagedstate ' '
set __fish_git_prompt_char_stashstate '⚑ '
set __fish_git_prompt_char_untrackedfiles '… '
set __fish_git_prompt_char_upstream_prefix ' '
set __fish_git_prompt_char_upstream_ahead ' '
set __fish_git_prompt_char_upstream_behind ' '
set __fish_git_prompt_char_upstream_diverged '  '
set __fish_git_prompt_char_upstream_equal '  '

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
            printf '%s[%s%s%s] ' (set_color normal) (set_color cyan) (tmux display-message -p "#S") (set_color normal)
        end
    end

    # Git status
    if type git &>/dev/null
        printf '%s%s ' (set_color normal) (fish_git_prompt | sed 's/^[ \t]*//' | sed 's/[(]\(.*\)[)]/\[\1\]/')
    end

    # Pipe status (error code)
    printf '%s ' $pipestatus_string

    # Next line
    printf '\n'

    # Vi mode
    if test "$fish_key_bindings" = fish_vi_key_bindings
        or test "$fish_key_bindings" = fish_hybrid_key_bindings
        switch $fish_bind_mode
            case default
                set_color --bold red
                printf 'N'
            case insert
                set_color --bold green
                printf 'I'
            case replace_one
                set_color --bold green
                printf 'R'
            case replace
                set_color --bold cyan
                printf 'R'
            case visual
                set_color --bold magenta
                printf 'V'
        end
        set_color normal
    end

    # Chevron
    printf '%s❯%s ' ([ "$last_pipestatus[-1]" -eq 0 ]; and set_color green; or set_color red) (set_color normal)
end
