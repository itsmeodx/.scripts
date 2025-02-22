#!/bin/zsh

# Check if gnome-shell is running
if ! pgrep -x "gnome-shell" > /dev/null; then
    echo "gnome-shell is not running"
    exit 1
fi

# Set Layout shortcuts
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name 'Toggle Layout'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command "sh -c 'layout=\$(setxkbmap -query | grep layout | cut -d: -f2 | tr -d \" \"); if [ \"\$layout\" = \"us\" ]; then setxkbmap ar; else setxkbmap us; fi'"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding '<Control><Alt>c'

# Enable the custom keybinding
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/']"
