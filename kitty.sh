#!/bin/zsh

# This script installs Kitty terminal on Linux x64

# Custom variables
dest="$HOME/Apps/kitty"
tmpfile="/tmp/kitty.txz"
tmpdir="/tmp/kitty"
url="https://github.com/kovidgoyal/kitty/releases/download"
applications_desktop_dir="$HOME/.local/share/applications"
icons_dir="$HOME/.local/share/icons"
bin_dir="$HOME/.local/bin"

# Get the latest version number
echo "Fetching latest Kitty version..."
latest_version=$(curl -s "https://sw.kovidgoyal.net/kitty/current-version.txt")

if [ -z "$latest_version" ]; then
    echo "Error: Could not determine latest version"
    exit 1
fi

# Construct the download URL exactly as in the original
url="${url}/v${latest_version}/kitty-${latest_version}-x86_64.txz"

# Download with progress bar and error checking
echo "Downloading Kitty terminal v${latest_version}..."
if ! wget -O $tmpfile $url 2>/dev/null; then
    echo "An error occurred while downloading the package!"
    echo "Please check your internet connection or your storage availability."
    exit 1
fi

# Verify the downloaded file
if [ ! -s "$tmpfile" ]; then
    echo "Error: Downloaded file is empty"
    rm -f "$tmpfile"
    exit 1
fi

# Extract the package
echo "Extracting the package..."
mkdir -p /tmp/kitty-extract
if ! tar -xJf "$tmpfile" -C "/tmp/kitty-extract" 2>/dev/null; then
    echo "Error: Extraction failed"
    rm -f "$tmpfile"
    rm -rf "/tmp/kitty-extract"
    exit 1
fi

# Copy the extracted files to the destination
cp -r /tmp/kitty-extract/* "$dest"

# Extract the desktop entry and icon
echo "Setting up desktop entry and icon..."
mkdir -p $applications_desktop_dir
cp $dest/share/applications/kitty.desktop $applications_desktop_dir
sed -i "s|Exec=kitty|Exec=$dest/bin/kitty|g" $applications_desktop_dir/kitty.desktop
sed -i "s|TryExec=kitty|TryExec=$dest/bin/kitty|g" $applications_desktop_dir/kitty.desktop
mkdir -p $icons_dir
cp $dest/share/icons/* $icons_dir/

# Create a symbolic link to the binary
echo "Creating a symbolic link to the binary..."
mkdir -p $bin_dir
ln -sf $dest/bin/kitty $bin_dir/kitty

# Clean up
echo "Cleaning up..."
rm -f $tmpfile
rm -rf "/tmp/kitty-extract"

echo "Kitty terminal has been successfully installed!"
