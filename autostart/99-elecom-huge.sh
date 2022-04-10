#!/bin/sh

if command -v xinput &> /dev/null; then
	# Set button Fn3 to scroll mode
	# https://www.reddit.com/r/Trackballs/comments/drdp6f/elecom_huge_trackball_scroll_emulation/
	xinput set-prop "pointer:ELECOM TrackBall Mouse HUGE TrackBall" 'libinput Button Scrolling Button' 12
	xinput set-prop "pointer:ELECOM TrackBall Mouse HUGE TrackBall" 'libinput Scroll Method Enabled' 0 0 1
fi
