#!/bin/zsh

# Run as a daemon
while true; do
    # Get current keyboard layout
    LAYOUT=$(setxkbmap -query | awk '/layout:/ {print $2}')

    # Check if the layout is Arabic and change to US
    if [ "$LAYOUT" = "ar" ]; then
        setxkbmap us
        echo "Keyboard layout changed to US"
    fi

    # Wait before checking again
    sleep 5
done &
