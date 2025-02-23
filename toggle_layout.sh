#!/bin/zsh

# Check if gnome-shell is running
if ! pgrep -x "gnome-shell" > /dev/null; then
    echo "gnome-shell is not running"
    exit 1
fi

# Get existing custom keybindings
CURRENT_BINDINGS=$(gsettings get org.gnome.settings-daemon.plugins.media-keys custom-keybindings)
# Remove the brackets from the current bindings string
CURRENT_BINDINGS=${CURRENT_BINDINGS:1:-1}

# Add our new binding path
NEW_BINDING="'/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/'"
if [[ -z "$CURRENT_BINDINGS" ]]; then
    FINAL_BINDINGS="[$NEW_BINDING]"
else
    FINAL_BINDINGS="[$CURRENT_BINDINGS, $NEW_BINDING]"
fi

# Set Layout shortcuts
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name 'Toggle Layout'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command "sh -c 'layout=\$(setxkbmap -query | grep layout | cut -d: -f2 | tr -d \" \"); if [ \"\$layout\" = \"us\" ]; then setxkbmap ar; else setxkbmap us; fi'"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding '<Control><Alt>c'

# Enable custom keybindings while preserving existing ones
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "$FINAL_BINDINGS"
