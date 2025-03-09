#!/bin/zsh

# Set keybindings for Pop!_OS Shell
set_keybindings() {
	left="h"
	down="j"
	up="k"
	right="l"

	KEYS_GNOME_WM=/org/gnome/desktop/wm/keybindings
	KEYS_GNOME_SHELL=/org/gnome/shell/keybindings
	KEYS_MUTTER=/org/gnome/mutter/keybindings
	KEYS_MEDIA=/org/gnome/settings-daemon/plugins/media-keys
	KEYS_MUTTER_WAYLAND_RESTORE=/org/gnome/mutter/wayland/keybindings/restore-shortcuts

	# Disable incompatible shortcuts
	# Restore the keyboard shortcuts: disable <Super>Escape
	dconf write ${KEYS_MUTTER_WAYLAND_RESTORE} "@as []"
	# Hide window: disable <Super>h
	dconf write ${KEYS_GNOME_WM}/minimize "@as ['<Super>comma']"
	# Open the application menu: disable <Super>m
	dconf write ${KEYS_GNOME_SHELL}/open-application-menu "@as []"
	# Toggle message tray: disable <Super>m
	dconf write ${KEYS_GNOME_SHELL}/toggle-message-tray "@as ['<Super>v']"
	# Show the activities overview: disable <Super>s
	dconf write ${KEYS_GNOME_SHELL}/toggle-overview "@as []"
	# Maximize window: disable <Super>Up
	dconf write ${KEYS_GNOME_WM}/maximize "@as []"
	# Restore window: disable <Super>Down
	dconf write ${KEYS_GNOME_WM}/unmaximize "@as []"
	# Move to monitor up: disable <Super><Shift>Up
	dconf write ${KEYS_GNOME_WM}/move-to-monitor-up "@as []"
	# Move to monitor down: disable <Super><Shift>Down
	dconf write ${KEYS_GNOME_WM}/move-to-monitor-down "@as []"

	# Super + direction keys, move window left and right monitors, or up and down workspaces
	# Move window one monitor to the left
	dconf write ${KEYS_GNOME_WM}/move-to-monitor-left "@as []"
	# Move window one workspace down
	dconf write ${KEYS_GNOME_WM}/move-to-workspace-down "@as []"
	# Move window one workspace up
	dconf write ${KEYS_GNOME_WM}/move-to-workspace-up "@as []"
	# Move window one monitor to the right
	dconf write ${KEYS_GNOME_WM}/move-to-monitor-right "@as []"

	# Super + Ctrl + direction keys, change workspaces, move focus between monitors
	# Move to workspace left
	dconf write ${KEYS_GNOME_WM}/switch-to-workspace-left "['<Ctrl><Alt>Left', '<Ctrl><Alt>${left}']"
	# Move to workspace right
	dconf write ${KEYS_GNOME_WM}/switch-to-workspace-right "['<Ctrl><Alt>Right', '<Ctrl><Alt>${right}']"
	# Move window one workspace left
	dconf write ${KEYS_GNOME_WM}/move-to-workspace-left "['<Shift><Ctrl><Alt>Left', '<Shift><Ctrl><Alt>${left}']"
	# Move window one workspace right
	dconf write ${KEYS_GNOME_WM}/move-to-workspace-right "['<Shift><Ctrl><Alt>Right', '<Shift><Ctrl><Alt>${right}']"

	# Disable tiling to left / right of screen
	dconf write ${KEYS_MUTTER}/toggle-tiled-left "@as []"
	dconf write ${KEYS_MUTTER}/toggle-tiled-right "@as []"

	# Toggle maximization state
	dconf write ${KEYS_GNOME_WM}/toggle-maximized "['<Super>m']"
	# Lock screen
	dconf write ${KEYS_MEDIA}/screensaver "['<Super>Escape']"
	# Home folder
	dconf write ${KEYS_MEDIA}/home "['<Super>e']"
	# Launch web browser
	dconf write ${KEYS_MEDIA}/www "['<Super>b']"
	# Launch terminal
	dconf write ${KEYS_MEDIA}/terminal "['<Super>t']"
	# Rotate Video Lock
	dconf write ${KEYS_MEDIA}/rotate-video-lock-static "@as []"

	# Close Window
	dconf write ${KEYS_GNOME_WM}/close "['<Super>q', '<Alt>F4']"
}

# This script installs Pop!_OS Shell GNOME extension

# Custom variables
repo="https://github.com/pop-os/shell.git"
src="$PWD/extensions/pop-shell@system76.com.tar.xz"
dest="$HOME/.local/share/gnome-shell/extensions"
tmpdir="/tmp/pop-shell"
tmpdeps="${tmpdir}/pop-deps"
branch="master_jammy"

# Copy the extension to the GNOME extensions directory
echo "Copying the extension to the GNOME extensions directory..."
tar -xf $src -C $dest || {
	echo "An error occurred while copying the extension!"
	echo "Please check your storage availability."
	exit 1
}

# Set keybindings
echo "Setting keybindings..."
echo -n "Would you like to set custom keybindings for Pop!_OS Shell? [y/N] "
read keybindings
if [[ $keybindings =~ ^[Yy]$ ]]; then
	echo "Setting custom keybindings..."
	set_keybindings
fi

# Restarting GNOME Shell and enabling the extension
echo "Restarting GNOME Shell..."
pkill -HUP gnome-shell && sleep 3 && gnome-extensions enable pop-shell@system76.com

# Clean up
echo "Cleaning up..."
rm -rf /tmp/pop-shell/
