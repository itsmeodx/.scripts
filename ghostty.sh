#!/bin/zsh

# This script installs Ghostty terminal on Linux x64

# Custom variables
dest="$HOME/goinfre/Apps/ghostty"
tmpfile="/tmp/ghostty.AppImage"
tmpdir="/tmp/ghostty"
url="https://github.com/pkgforge-dev/ghostty-appimage/releases/download"
applications_desktop_dir="$HOME/.local/share/applications"
icons_dir="$HOME/.local/share/icons"
bin_dir="$HOME/.local/bin"

# Get the latest version number
echo "Fetching latest Ghostty version..."
latest_version=$(curl -s "https://api.github.com/repos/pkgforge-dev/ghostty-appimage/releases/latest" | grep -Po '"tag_name": "v\K[^"]*' | cut -d'+' -f1)
if [ -z "$latest_version" ]; then
	echo "Error: Could not determine latest version"
	exit 1
fi

# Construct the download URL exactly as in the original
url="${url}/v${latest_version}/ghostty-${latest_version}-x86_64.AppImage"

# Download with progress bar and error checking
echo "Downloading Ghostty terminal v${latest_version}..."
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

# Extract the package
echo "Extracting the package..."
mkdir -p "$tmpdir"
cd "$tmpdir" || (echo "Error: Could not change directory to $tmpdir" && exit 1)
chmod +x "$tmpfile"
$tmpfile --appimage-extract 1>/dev/null 2>/dev/null
if [ $? -ne 0 ]; then
	echo "Error: Extraction failed"
	rm -f "$tmpfile"
	exit 1
fi

# Copy the extracted files to the destination
mkdir -p $dest
cp -r squashfs-root/* $dest

# Extract the desktop entry and icon
echo "Setting up desktop entry and icon..."
mkdir -p $applications_desktop_dir
cp $dest/share/applications/* $applications_desktop_dir
sed -i "s|Exec=ghostty|Exec=$dest/bin/ghostty|g" $applications_desktop_dir/ghostty.desktop
sed -i "s|TryExec=ghostty|TryExec=$dest/bin/ghostty|g" $applications_desktop_dir/ghostty.desktop
mkdir -p $icons_dir
cp -r $dest/share/icons/* $icons_dir

# Create a symbolic link to the binary
echo "Creating symbolic link to the binary..."
mkdir -p $bin_dir
ln -sf $dest/bin/ghostty $bin_dir/ghostty

# Checking the PATH variable
echo "Checking if the bin directory is in the PATH variable..."
if [[ ":$PATH:" != *":$bin_dir:"* ]]; then
	echo "Warning: $bin_dir is not in your PATH"
	echo "Would you like to add it to your PATH? [y/N]"
	read add_to_path
	if [[ $add_to_path =~ ^[Yy]$ ]]; then
		echo "export PATH=\$PATH:$bin_dir" >> $HOME/.zshrc
		echo "PATH variable updated. Please restart your shell to apply the changes."
	fi
else
	echo "The bin directory is in your PATH"
fi

# Clean up
echo "Cleaning up..."
rm -f $tmpfile
rm -rf $tmpdir

# Done
echo "Ghostty terminal has been installed successfully!"
