#!/bin/bash

# Switch monitors automatically based on HDMI cable

# Function to activate HDMI and deactivate eDP
function activate_hdmi {
    xrandr --output HDMI-A-0 --auto --primary
    xrandr --output eDP --off
    i3-msg restart
}

# Function to deactivate HDMI and activate eDP
function activate_edp {
    xrandr --output eDP --auto --primary
    xrandr --output HDMI-A-0 --off
    i3-msg restart
}

function main {
    if xrandr | grep "HDMI-A-0 connected"; then
        activate_hdmi
    else
        activate_edp
    fi
}
main

# Listen to udev events for DRM subsystem
udevadm monitor --subsystem-match=drm | while read -r line; do
    if echo "$line" | grep -E "change"; then
        # Eat up any upcoming data in the next second
        # https://stackoverflow.com/a/69945839
        timeout 1 cat

        main
    fi
done
