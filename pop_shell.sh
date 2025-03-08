#!/bin/zsh

# This script installs Pop!_OS Shell GNOME extension

# Custom variables
dest=$HOME/.local/share/gnome-shell/extensions
ext=./extensions/pop-shell@system76.com.tar.xz

# Install Pop!_OS Shell GNOME extension
mkdir -p $dest
tar -xf $ext -C $dest

# Restart GNOME Shell
echo "Press Alt+F2, type 'r' and press Enter to restart GNOME Shell"
echo "Then enable Pop!_OS Shell GNOME extension"
echo "by running:\vgnome-extensions enable pop-shell@system76.com"
