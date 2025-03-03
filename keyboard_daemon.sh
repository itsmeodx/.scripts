#!/bin/zsh

# Run as a daemon
while true; do
	# Get current keyboard layout
	LAYOUT=$(setxkbmap -query | awk '/layout:/ {print $2}')

	# Check if ft_lock is running and the layout is Arabic
	if pgrep -x "ft_lock" > /dev/null && [ "$LAYOUT" != "us" ]; then
		setxkbmap us
		# Send a notification
		notify-send "Keyboard Layout" "ft_lock is running, keyboard layout changed to US" -u normal -i keyboard
	fi

	# Wait before checking again
	sleep 5
done &
