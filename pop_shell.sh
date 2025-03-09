#!/bin/zsh

# This script installs Pop!_OS Shell GNOME extension

# Custom variables
repo="https://github.com/pop-os/shell.git"
src="$PWD/extensions/pop-shell@system76.com.tar.xz"
dest="$HOME/.local/share/gnome-shell/extensions"
tmpdir="/tmp/pop-shell"
tmpdeps="${tmpdir}/pop-deps"
branch="master_jammy"

# Clone the repository
echo "Cloning the repository..."
rm -rf $tmpdir
git clone $repo $tmpdir || {
	echo "An error occurred while cloning the repository!"
	echo "Please check your internet connection or your storage availability."
	exit 1
}

# Install the dependencies
echo "Installing the dependencies..."
mkdir -p $tmpdeps
cd $tmpdeps
apt download node-typescript
dpkg -x node-typescript*.deb .
export PATH=$PATH:$tmpdeps/usr/bin

# Install the extension
echo "Installing the extension..."
cd $tmpdir
make configure || {
	echo "An error occurred while installing the extension!"
	echo "Please check your internet connection or your storage availability."
	exit 1
}

# Copy the extension to the GNOME extensions directory
echo "Copying the extension to the GNOME extensions directory..."
tar -xf $src -C $dest || {
	echo "An error occurred while copying the extension!"
	echo "Please check your storage availability."
	exit 1
}

# Restarting GNOME Shell and enabling the extension
echo "Restarting GNOME Shell..."
pkill -HUP gnome-shell
sleep 3
gnome-extensions enable pop-shell@system76.com

# Clean up
echo "Cleaning up..."
rm -rf /tmp/pop-shell/
