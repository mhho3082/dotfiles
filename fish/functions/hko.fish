# Using Hong Kong Observatory's Open Data API:
# https://data.weather.gov.hk/weatherAPI/doc/HKO_Open_Data_API_Documentation.pdf

# Source URL to curl from (use printf to format options into)
set -g url "https://data.weather.gov.hk/weatherAPI/opendata/weather.php?dataType=%s&lang=%s" # dataType, lang

# Add completions
set -l hko_type forecast 9day current warnings info tips
complete -c hko -f
complete -c hko -n "not __fish_seen_subcommand_from $hko_type" \
    -a "forecast 9day current warnings info tips"

function hko -d "Get weather from HKO"
    # Pick data type
    switch "$argv[1]"
        case forecast
            set -g type "flw"
        case 9day
            set -g type "fnd"
        case curr
        case current
            set -g type "rhrread"
        case warnings
            set -g type "warnsum"
        case info
            set -g type "warninginfo"
        case tips
            set -g type "swt"
        case '*'
            if test -z "$argv[1]"
                set -g type "flw"
            else
                set -g type "$argv[1]"
            end
    end

    # Get language
    switch "$argv[2]"
        case english
            set -g lang "en"
        case '*'
            if test -z "$argv[2]"
                set -g lang "en"
            else
                set -g lang "$argv[2]"
            end
    end


    curl -s (printf $url $type $lang) | # Get data
        python -m json.tool | # Pretty print json
        less -F # Use pager if larger than 1 screen
end
