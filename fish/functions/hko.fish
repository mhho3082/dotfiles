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
            set -f type flw
        case 9day
            set -f type fnd
        case curr
        case current
            set -f type rhrread
        case warnings
            set -f type warnsum
        case info
            set -f type warninginfo
        case tips
            set -f type swt
        case '*'
            if test -z "$argv[1]"
                set -f type flw
            else
                set -f type "$argv[1]"
            end
    end

    # Get language
    switch "$argv[2]"
        case english
            set -f lang en
        case traditional
        case chinese
            set -f lang tc
        case simplified
            set -f lang sc
        case '*'
            if test -z "$argv[2]"
                set -f lang en
            else
                set -f lang "$argv[2]"
            end
    end

    # Get data
    set -f response (curl -X GET -s (printf $url $type $lang))

    # Pretty-print data
    echo $response |
        python -c 'import sys, yaml, json; print(yaml.safe_dump(json.loads(sys.stdin.read()), allow_unicode=True, sort_keys=False))' |
        less -RF
end
