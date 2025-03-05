#!/bin/zsh

# This script installs Floorp Browser on Linux x64

# Custom variables
dest="$HOME/goinfre/Apps/floorp"
tmpfile="/tmp/floorp.tar.bz2"
url="https://github.com/Floorp-Projects/Floorp/releases/download"
applications_desktop_dir="$HOME/.local/share/applications"
icons_dir="$HOME/.local/share/icons"
bin_dir="$HOME/.local/bin"

# Get the latest version number
echo "Fetching latest Floorp version..."
latest_version=$(curl -s https://api.github.com/repos/Floorp-Projects/Floorp/releases/latest \
					| grep -Po '"tag_name": "v\K[^"]*')

if [ -z "$latest_version" ]; then
	echo "Error: Could not determine latest version"
	exit 1
fi

# Construct the download URL
url="${url}/v${latest_version}/floorp-${latest_version}.linux-x86_64.tar.bz2"

# Download with progress bar and error checking
echo "Downloading Floorp Browser v${latest_version}..."
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

# Test archive integrity
if ! bzip2 -t "$tmpfile" 2>/dev/null; then
    echo "Error: Downloaded archive is corrupted"
    rm -f "$tmpfile"
    exit 1
fi

# Extract the tarball with verbose output
echo "Extracting the package..."
mkdir -p "$dest"
if ! tar -xjf "$tmpfile" -C "/tmp" 2>/dev/null; then
	echo "Error: Extraction failed"
	rm -f "$tmpfile"
	exit 1
fi

# Copy the extracted files to the destination
cp -r /tmp/floorp/* "$dest"

# Extract the desktop entry and icon
echo "Creating the desktop entry and icon..."
mkdir -p $applications_desktop_dir
touch $applications_desktop_dir/floorp.desktop
echo "[Desktop Entry]
Version=$latest_version
Name=Floorp Browser
GenericName=Web Browser
Comment=Browse the World Wide Web
Exec=$dest/floorp %u
Icon=$icons_dir/floorp.png
Terminal=false
Type=Application
Categories=Network;WebBrowser;
Keywords=Internet;WWW;Browser;Web;Explorer
MimeType=text/html;text/xml;application/xhtml+xml;x-scheme-handler/http;x-scheme-handler/https;application/x-xpinstall;
StartupNotify=true
Actions=new-window;new-private-window;

[Desktop Action new-window]
Name=New Window
Exec=$dest/floorp --new-window

[Desktop Action new-private-window]
Name=New Private Window
Exec=$dest/floorp --private-window" > "$applications_desktop_dir/floorp.desktop"
mkdir -p $icons_dir
cp $dest/browser/chrome/icons/default/default128.png $icons_dir/floorp.png

# Create a symbolic link to the binary
echo "Creating a symbolic link to the binary..."
mkdir -p $bin_dir
ln -sf $dest/floorp $bin_dir/floorp

# Clean up
echo "Cleaning up..."
rm $tmpfile

