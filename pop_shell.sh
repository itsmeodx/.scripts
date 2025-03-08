#!/bin/zsh

# This script installs Pop!_OS Shell GNOME extension

# Custom variables
dest=$HOME/.local/share/gnome-shell/extensions
ext=./extensions/pop-shell@system76.com.tar.xz

# Install Pop!_OS Shell GNOME extension
mkdir -p $dest
tar -xf $ext -C $dest

# Restart GNOME Shell
gnome-shell --replace & disown

# Enable Pop!_OS Shell GNOME extension
gnome-extensions enable pop-shell@system76.com
