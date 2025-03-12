#!/bin/zsh

# Export your phone's ID (via lsusb) in MYPHONEID in your .zshrc
source ~/.zshrc

# Run as a daemon
while true; do
	# Check if the device is connected
	if lsusb | grep -q $MYPHONEID; then
		if [ ! -f /tmp/telelock ]; then
			touch /tmp/telelock
			pkill -KILL ft_lock
			notify-send "Session unlocked" "ft_lock has been killed" -u normal -i lock
		fi
	else
		[ -f /tmp/telelock ] && rm /tmp/telelock
	fi
done &
