#!/bin/zsh

# Check if gnome-shell is running
if ! pgrep -x "gnome-shell" > /dev/null; then
    echo "gnome-shell is not running"
    exit 1
fi

# Get existing custom keybindings and strip GVariant type annotation
CURRENT_BINDINGS=$(gsettings get org.gnome.settings-daemon.plugins.media-keys custom-keybindings | sed 's/^@as //')
# Remove the brackets from the current bindings string
CURRENT_BINDINGS=${CURRENT_BINDINGS:1:-1}

# Add our new binding path, avoiding duplicates
NEW_BINDING="'/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/'"
typeset -A SEEN
FINAL_ARRAY=()

if [[ -n "$CURRENT_BINDINGS" ]]; then
    for entry in ${(s:,:)CURRENT_BINDINGS}; do
        entry=${entry## }   # trim leading space
        entry=${entry%% }   # trim trailing space
        if [[ -n "$entry" && -z ${SEEN[$entry]} ]]; then
            FINAL_ARRAY+=$entry
            SEEN[$entry]=1
        fi
    done
fi

if [[ -z ${SEEN[$NEW_BINDING]} ]]; then
    FINAL_ARRAY+=$NEW_BINDING
fi

FINAL_BINDINGS="[${(j:, :)FINAL_ARRAY}]"

# Set Layout shortcuts
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name 'Toggle Layout'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command "sh -c 'layout=\$(setxkbmap -query | grep layout | cut -d: -f2 | tr -d \" \"); if [ \"\$layout\" = \"us\" ]; then setxkbmap ar; else setxkbmap us; fi'"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding '<Control><Alt>c'

# Enable custom keybindings while preserving existing ones
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "$FINAL_BINDINGS"
