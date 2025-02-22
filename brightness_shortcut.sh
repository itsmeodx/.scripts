#!/bin/zsh

# Check if gnome-shell is running
if ! pgrep -x "gnome-shell" > /dev/null; then
	echo "gnome-shell is not running"
	exit 1
fi

# Set brightness shortcuts
gsettings set org.gnome.settings-daemon.plugins.media-keys screen-brightness-down "['<Super>F6']"
gsettings set org.gnome.settings-daemon.plugins.media-keys screen-brightness-up "['<Super>F7']"
echo "Brightness shortcuts set to <Super>F6 and <Super>F7"
