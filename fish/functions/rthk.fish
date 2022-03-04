# Source for using sed to parse XML
# https://unix.stackexchange.com/questions/98217/using-sed-to-extract-text-between-2-tags

# Source webpages to curl from
set -g local "https://rthk9.rthk.hk/rthk/news/rss/e_expressnews_elocal.xml"
set -g china "https://rthk9.rthk.hk/rthk/news/rss/e_expressnews_egreaterchina.xml"
set -g world "https://rthk9.rthk.hk/rthk/news/rss/e_expressnews_einternational.xml"
set -g finance "https://rthk9.rthk.hk/rthk/news/rss/e_expressnews_efinance.xml"
set -g sport "https://rthk9.rthk.hk/rthk/news/rss/e_expressnews_esport.xml"

# Add completion
set -l rthk_commands local china world finance sport
complete -f -c rthk -n "not __fish_seen_subcommand_from $rthk_commands" -a local -d "Local news"
complete -f -c rthk -n "not __fish_seen_subcommand_from $rthk_commands" -a china -d "Greater China news"
complete -f -c rthk -n "not __fish_seen_subcommand_from $rthk_commands" -a world -d "World news"
complete -f -c rthk -n "not __fish_seen_subcommand_from $rthk_commands" -a finance -d "Finance news"
complete -f -c rthk -n "not __fish_seen_subcommand_from $rthk_commands" -a sport -d "Sport news"

function rthk -d "Get news from RTHK"
    # Pick source
    switch "$argv[1]"
        case local
            set -g link $local
        case china
            set -g link $china
        case world
            set -g link $world
        case finance
            set -g link $finance
        case sport
            set -g link $sport
        case '*'
            set -g link $local
    end

    curl -s $link |
        tr '\n' '\f' |
        sed 's|<item>|\n<item>|g' |
        sed 's|<description>.*<\/description>||g' |
        sed 's|\f||g' |
        sed -n 's|.*<title>\(.*\)</title>.*<pubDate>.*, \(.* .*\) .* \(.*:.*\):.*</pubDate>.*|'(set_color blue)'\2'(set_color green)' \3'(set_color normal)' - \1|p' |
        sed '1s|.* - \(.*\): \(.*\)$|\1: '(set_color cyan)'\2'(set_color normal)'\n|' |
        sed 's|<\!\[CDATA\[\(.*\)\]\]>|\1|g' |
        sed 's|\(.*\) - \(.*\)$|\1 \2|' |
        less -RF # Use pager if larger than 1 screen
end
