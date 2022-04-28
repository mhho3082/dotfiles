#!/bin/sh

if command -v xinput &> /dev/null; then
	# https://www.reddit.com/r/Trackballs/comments/drdp6f/elecom_huge_trackball_scroll_emulation/
	# https://www.reddit.com/r/Trackballs/comments/mtdgld/elecom_huge_button_configuration_ideas/

	# Remember to set this to really auto-start with your desktop environment
	# e.g., for xfce: set to "launch on login" in sessions and startup

	# Set Fn3 to scroll mode
	xinput set-prop "pointer:ELECOM TrackBall Mouse HUGE TrackBall" 'libinput Button Scrolling Button' 12 2> /dev/null
	xinput set-prop "pointer:ELECOM TrackBall Mouse HUGE TrackBall" 'libinput Scroll Method Enabled' 0 0 1 2> /dev/null
fi
