#!/usr/bin/env bash

# Copied from https://wiki.archlinux.org/title/Polybar

# Terminate already running bar instances
killall -q polybar
# If all your bars have ipc enabled, you can also use
# polybar-msg cmd quit

# Launch Polybar, using default config location ~/.config/polybar/config.ini
polybar 2>&1 | tee -a /tmp/polybar.log &
disown
