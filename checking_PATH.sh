#!/bin/zsh

# This script checks if the bin directory is in the PATH variable

# Custom variables
bin_dir="$HOME/.local/bin"

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

# Done
