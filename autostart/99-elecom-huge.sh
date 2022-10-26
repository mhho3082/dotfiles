#!/bin/sh

if command -v xinput &> /dev/null; then
    # https://www.reddit.com/r/Trackballs/comments/drdp6f/elecom_huge_trackball_scroll_emulation/
    # https://www.reddit.com/r/Trackballs/comments/mtdgld/elecom_huge_button_configuration_ideas/

    # Remember to auto-start this with your desktop environment
    # e.g., for xfce: set to "launch on login" in sessions and startup
    
    num=$(xinput list | grep "ELECOM TrackBall Mouse HUGE TrackBall" | \
        grep "pointer" | grep -Eo "id=[0-9]+" | grep -Eo "[0-9]+")

    if [ -z $num ]; then
        echo "Elecom Huge not found!"
        exit 1
    fi

    # Set Fn3 to scroll mode
    xinput set-prop $num 'libinput Button Scrolling Button' 12
    xinput set-prop $num 'libinput Scroll Method Enabled' 0 0 1
    xinput set-button-map $num 1 2 3 4 5 6 7 8 9 10 11 2
fi
