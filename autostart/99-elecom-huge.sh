#!/usr/bin/env bash

if command -v xinput &> /dev/null; then
    # https://www.reddit.com/r/Trackballs/comments/drdp6f/elecom_huge_trackball_scroll_emulation/
    # https://www.reddit.com/r/Trackballs/comments/mtdgld/elecom_huge_button_configuration_ideas/
    # https://askubuntu.com/questions/492744/how-do-i-automatically-remap-buttons-on-my-mouse-at-startup

    # Remember to auto-start this with your desktop environment
    # e.g., for xfce: set to "launch on login" in sessions and startup
    
    num=$(xinput list | grep -m 1 "ELECOM TrackBall Mouse HUGE TrackBall" | sed 's/^.*id=\([0-9]*\)[ \t].*$/\1/')

    if [ -z $num ]; then
        echo "Elecom Huge not found!" 1>&2
        exit 1
    fi

    # Set Fn3 to scroll mode
    xinput set-prop $num 'libinput Button Scrolling Button' 12
    xinput set-prop $num 'libinput Scroll Method Enabled' 0 0 1
    xinput set-button-map $num 1 2 3 4 5 6 7 8 9 10 11 2
fi
