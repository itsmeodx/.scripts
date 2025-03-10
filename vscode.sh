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
if ! curl -L --progress-bar -o "$tmpfile" "$url"; then
	echo "An error occurred while downloading the package!"
	echo "Please check your internet connection or your storage availability."
	exit 1
fi

echo -e "\033[1A\033[2KDownload complete"

# Verify the downloaded file
if [ ! -s "$tmpfile" ]; then
	echo "Error: Downloaded file is empty"
	rm -f "$tmpfile"
	exit 1
fi

# Extract the deb package
echo "Extracting the package..."
mkdir -p $dest
if ! dpkg -x $tmpfile $dest 2>/dev/null; then
	echo "Error: Extraction failed"
	rm -f "$tmpfile"
	exit 1
fi

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

# Checking the PATH variable
./checking_PATH.sh

# Clean up
echo "Cleaning up..."
rm $tmpfile

# Done
echo "Visual Studio Code has been successfully installed!"
