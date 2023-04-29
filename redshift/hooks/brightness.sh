#!/bin/sh
# Set brightness via xbrightness when redshift status changes

# Deeply based on https://wiki.archlinux.org/title/Redshift
# Main change is that brightnessctl is used instead

# Set brightness values for each status.
# Range from 0% to 100%, and 0 to 255, are valid
brightness_day='70%'
brightness_transition='50%'
brightness_night='30%'
# Adjust this grep to filter only the backlights you want to adjust
backlights=($(brightnessctl --list | grep "'backlight'" | sed "s/.*'\([^']*\)'.*/\1/"))

set_brightness() {
    for backlight in "${backlights[@]}"
    do
        brightnessctl --device=$backlight set $1 &
    done
}

if [ "$1" = period-changed ]; then
    case $3 in
        night)
            set_brightness $brightness_night
            ;;
        transition)
            set_brightness $brightness_transition
            ;;
        daytime)
            set_brightness $brightness_day
            ;;
    esac
fi
