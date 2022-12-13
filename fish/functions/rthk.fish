# Source for using sed to parse XML
# https://unix.stackexchange.com/questions/98217/using-sed-to-extract-text-between-2-tags

# Add completion
set -l rthk_commands local china world finance sport
complete -f -c rthk -n "not __fish_seen_subcommand_from $rthk_commands" -a local -d "Local news"
complete -f -c rthk -n "not __fish_seen_subcommand_from $rthk_commands" -a china -d "Greater China news"
complete -f -c rthk -n "not __fish_seen_subcommand_from $rthk_commands" -a world -d "World news"
complete -f -c rthk -n "not __fish_seen_subcommand_from $rthk_commands" -a finance -d "Finance news"
complete -f -c rthk -n "not __fish_seen_subcommand_from $rthk_commands" -a sport -d "Sport news"

function rthk -d "Get news from RTHK"
    # Source URL to curl from (use printf to format options into)
    set -f url "https://rthk9.rthk.hk/rthk/news/rss/e_expressnews_e%s.xml"
    # Pick source
    switch "$argv[1]"
        case local
            set -f type local
        case china
            set -f type greaterchina
        case world
            set -f type international
        case finance
            set -f type finance
        case sport
            set -f type sport
        case '*'
            if test -z "$argv[1]"
                set -f type local
            else
                set -f type "$argv[1]"
            end
    end

    curl -X GET -s (printf $url $type) |
        tr -d '\n' |
        sed 's|<item>|\n<item>|g' |
        sed 's|<description>.*<\/description>||g' |
        sed -n 's|.*<title>\(.*\)</title>.*<pubDate>.*, \(.* .*\) .* \(.*:.*\):.*</pubDate>.*|'(set_color blue)'\2'(set_color green)' \3'(set_color normal)' - \1|p' |
        sed '1s|.* - \(.*\): \(.*\)$|\1: '(set_color cyan)'\2'(set_color normal)'\n|' |
        sed 's|<\!\[CDATA\[\(.*\)\]\]>|\1|g' |
        sed 's|\(.*\) - \(.*\)$|\1 \2|' |
        less -RF # Use pager if larger than 1 screen
end
