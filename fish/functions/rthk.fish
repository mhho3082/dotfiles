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
        sed -n 's|.*<pubDate>.*\, \(.* .*\) .* \(.*:.*\):.*</pubDate>.*<title><\!\[CDATA\[\(.*\)\]\]></title>.*|'(set_color blue)'\1'(set_color green)' \2'(set_color normal)' \3|p' | # Parse headlines
        less -RF # Use pager if larger than 1 screen
end
