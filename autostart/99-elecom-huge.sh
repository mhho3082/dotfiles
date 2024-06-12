#!/usr/bin/env bash

# Add trackball scrolling for Elecom Huge

# https://www.reddit.com/r/Trackballs/comments/drdp6f/elecom_huge_trackball_scroll_emulation/
# https://www.reddit.com/r/Trackballs/comments/mtdgld/elecom_huge_button_configuration_ideas/
# https://askubuntu.com/q/492744

function main {
    if command -v xinput &> /dev/null; then
        num=$(xinput list | grep -m 1 "ELECOM TrackBall Mouse HUGE TrackBall" | sed 's/^.*id=\([0-9]*\)[ \t].*$/\1/')

        if [ -n "$num" ]; then
            # Set Fn3 to scroll mode
            xinput set-prop "$num" 'libinput Button Scrolling Button' 12
            xinput set-prop "$num" 'libinput Scroll Method Enabled' 0 0 1
            xinput set-button-map "$num" 1 2 3 4 5 6 7 8 9 10 11 2
        fi
    else
        printf "WARNING(Elecom Huge): xinput not installed!" 1>&2
    fi
}
main


udevadm monitor --subsystem-match=input | while read -r line; do
    if echo "$line" | grep -E "add"; then
        # Eat up any upcoming data in the next second
        # https://stackoverflow.com/a/69945839
        timeout 1 cat

        main
    fi
done
