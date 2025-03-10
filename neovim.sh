#!/bin/zsh

# This script installs NeoVim on Linux x64

# Custom variables
dest="$HOME/goinfre/Apps/neovim"
tmpfile="/tmp/neovim.tar.gz"
url="https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz"
applications_desktop_dir="$HOME/.local/share/applications"
icons_dir="$HOME/.local/share/icons"
bin_dir="$HOME/.local/bin"

# Download the latest version of NeoVim for Linux x64
echo "Downloading the latest version of NeoVim for Linux x64..."
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

# Extract the tarball
echo "Extracting the package..."
mkdir -p $dest
tar -xzf $tmpfile -C /tmp
cp -r /tmp/nvim-linux-x86_64/* $dest

# Extract the desktop entry and icon
echo "Extracting the desktop entry and icon..."
mkdir -p $applications_desktop_dir
cp $dest/share/applications/nvim.desktop $applications_desktop_dir
sed -i "s|Exec=nvim|Exec=$dest/bin/nvim|g" $applications_desktop_dir/nvim.desktop
sed -i "s|TryExec=nvim|TryExec=$dest/bin/nvim|g" $applications_desktop_dir/nvim.desktop
sed -i "s|Name=Neovim|Name=NVim|g" $applications_desktop_dir/nvim.desktop
mkdir -p $icons_dir
cp -r $dest/share/icons/* $icons_dir

# Create a symbolic link to the binary
echo "Creating a symbolic link to the binary..."
mkdir -p $bin_dir
ln -sf $dest/bin/nvim $bin_dir/nvim

# Checking the PATH variable
./checking_PATH.sh

# Clean up
echo "Cleaning up..."
rm -f $tmpfile
rm -rf /tmp/nvim-linux-x86_64

echo "NeoVim has been successfully installed!"
