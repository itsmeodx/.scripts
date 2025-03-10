#!/bin/zsh

# This script installs Clipboard Indicator GNOME extension

# Custom variables
src="$PWD/extensions/clipboard-history@alexsaveau.dev.tar.xz"
dest="$HOME/.local/share/gnome-shell/extensions"

# Copy the extension to the GNOME extensions directory
echo "Copying the extension to the GNOME extensions directory..."
mkdir -p $dest
tar -xf $src -C $dest || {
	echo "An error occurred while copying the extension!"
	echo "Please check your storage availability."
	exit 1
}

# Restarting GNOME Shell and enabling the extension
echo "Restarting GNOME Shell..."
pkill -HUP gnome-shell && sleep 3 && gnome-extensions enable pop-shell@system76.com

# Done
echo "Clipboard Indicator GNOME extension has been installed successfully!"
