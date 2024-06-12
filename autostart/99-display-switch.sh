#!/bin/bash

# Switch monitors automatically based on HDMI cable

function main {
    if xrandr | grep "HDMI-A-0 connected"; then
        # Activate HDMI
        xrandr --output HDMI-A-0 --auto --primary
        xrandr --output eDP --off
    else
        # Activate eDP
        xrandr --output eDP --auto --primary
        xrandr --output HDMI-A-0 --off
    fi

    # Restart i3
    killall -q polybar
    i3-msg restart

    # https://superuser.com/a/644829
    xset s off && xset s noblank && xset -dpms
}
main

# Listen to udev events for DRM subsystem
udevadm monitor --subsystem-match=drm | while read -r line; do
    if echo "$line" | grep -E "change"; then
        # Eat up any upcoming data in the next second
        # https://stackoverflow.com/a/69945839
        timeout 3 cat

        main
    fi
done
