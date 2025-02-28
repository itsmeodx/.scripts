#!/bin/zsh

# This script installs Visual Studio Code on Linux x64

# Custom variables
dest="$HOME/Apps/vscode"
tmpfile="/tmp/vscode.deb"
url="https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"
applications_desktop_dir="$HOME/.local/share/applications"
icons_dir="$HOME/.local/share/icons"
bin_dir="$HOME/.local/bin"

# Download the latest version of Visual Studio Code for Linux x64
echo "Downloading the latest version of Visual Studio Code for Linux x64..."
wget -O $tmpfile $url 2>/dev/null

# Extract the deb package
echo "Extracting the package..."
mkdir -p $dest
dpkg -x $tmpfile $dest

# Extract the desktop entry and icon
echo "Extracting the desktop entry and icon..."
mkdir -p $applications_desktop_dir
cp $dest/usr/share/applications/code.desktop $applications_desktop_dir
sed -i "s|Exec=/usr/share/code/code|Exec=$dest/usr/share/code/code|g" $applications_desktop_dir/code.desktop
sed -i "s|Name=Visual Studio Code|Name=VSCode|g" $applications_desktop_dir/code.desktop
cp $dest/usr/share/applications/code-url-handler.desktop $applications_desktop_dir
sed -i "s|Exec=/usr/share/code/code|Exec=$dest/usr/share/code/code|g" $applications_desktop_dir/code-url-handler.desktop
sed -i "s|Name=Visual Studio Code|Name=VSCode|g" $applications_desktop_dir/code-url-handler.desktop
mkdir -p $icons_dir
cp $dest/usr/share/pixmaps/vscode.png $icons_dir/vscode.png

# Create a symbolic link to the binary
echo "Creating a symbolic link to the binary..."
mkdir -p $bin_dir
ln -sf $dest/usr/share/code/bin/code $bin_dir/code

# Clean up
echo "Cleaning up..."
rm $tmpfile

echo "Visual Studio Code has been successfully installed!"
