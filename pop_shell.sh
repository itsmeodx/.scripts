#!/bin/zsh

# This script installs Pop!_OS Shell GNOME extension

# Custom variables
repo="https://github.com/pop-os/shell.git"
tmpdir="/tmp/pop-shell"
tmpdeps="${tmpdir}/pop-deps"
branch="master_jammy"

# Clone the repository
echo "Cloning the repository..."
rm -rf $tmpdir
git clone --branch $branch $repo $tmpdir || {
	echo "An error occurred while cloning the repository!"
	echo "Please check your internet connection or your storage availability."
	exit 1
}

# Install the dependencies
echo "Installing the dependencies..."
rm -rf $tmpdepsmkdir -p $tmpdeps
cd $tmpdeps
apt download node-typescript
dpkg -x node-typescript*.deb .
export PATH=$PATH:$tmpdeps/usr/bin

# Install the extension
echo "Installing the extension..."
cd $tmpdir
make local-install || {
	echo "An error occurred while installing the extension!"
	echo "Please check your internet connection or your storage availability."
	exit 1
}

# Clean up
echo "Cleaning up..."
rm -rf /tmp/pop-shell
