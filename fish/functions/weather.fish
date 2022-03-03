# Source for using sed to remove trailing blank line
# sed.sourceforge.net/sed1line.txt

# Source webpages to curl from
set -g forecast "https://www.hko.gov.hk/textonly/v2/forecast/local.htm"
set -g current "https://www.hko.gov.hk/textonly/v2/forecast/englishwx2.htm"
set -g 9day "https://www.hko.gov.hk/textonly/v2/forecast/nday_v2.htm"
set -g world "https://www.hko.gov.hk/textonly/v2/other/wwf.htm"

# Add completion
set -l weather_commands forecast current 9day world
complete -f -c weather -n "not __fish_seen_subcommand_from $weather_commands" -a forecast -d "Weather forecast"
complete -f -c weather -n "not __fish_seen_subcommand_from $weather_commands" -a current -d "Current weather"
complete -f -c weather -n "not __fish_seen_subcommand_from $weather_commands" -a 9day -d "9 day weather forecast"
complete -f -c weather -n "not __fish_seen_subcommand_from $weather_commands" -a world -d "World weather"

function weather -d "Get weather from HKO"
    # Pick source
    switch "$argv[1]"
        case forecast
            set -g link $forecast
        case current
            set -g link $current
        case 9day
            set -g link $9day
        case china
            set -g link $china
        case world
            set -g link $world
        case '*'
            set -g link $forecast
    end

    curl -s $link | # Get data
        sed 's|<sup>\*<\/sup>|*|g' | # Remove <sup> tags (IDK why HKO puts it there)
        sed -e '1,/<pre>/Id' | # Remove html tags at the top
        sed -e '/<\/pre>/,/<\/html>/Id' | # Remove html tags at the bottom
        sed -e :a -e '/^\n*$/{$d;N;};/\n$/ba' | # Remove trailing blank lines
        less -F # Use pager if larger than 1 screen
end
