# .scripts

This directory contains various scripts designed to enhance productivity and workflow on a 42Network Linux environment.

## Scripts

### vscode.sh

This script installs Visual Studio Code on a Linux x64 system.

- Downloads the latest version of Visual Studio Code.
- Extracts the package and installs it to a custom directory.
- Sets up desktop entries and icons.
- Creates a symbolic link to the binary.

Usage:
```bash
./vscode.sh
```

### neovim.sh

This script installs NeoVim on a Linux x64 system.

- Downloads the latest version of NeoVim.
- Extracts the package and installs it to a custom directory.
- Sets up desktop entries and icons.
- Creates a symbolic link to the binary.

Usage:
```bash
./neovim.sh
```

### kitty.sh

This script installs the Kitty terminal emulator.

- Detects the operating system and architecture.
- Downloads the appropriate installer.
- Installs Kitty to a custom directory.
- Sets up desktop entries and icons.
- Creates a symbolic link to the binary.

Usage:
```bash
./kitty.sh
```

### homebrew.sh

This script installs Homebrew and some favorite packages.

- Installs Homebrew to a custom directory.
- Optionally removes Homebrew.
- Installs favorite packages using Homebrew.

Usage:
```bash
# Install Homebrew
./homebrew.sh

# Install favorite packages
./homebrew.sh -p

# Remove Homebrew
./homebrew.sh -r
```

## Notes

- These scripts are designed to run on a 42Network Linux environment.
- Ensure you have the necessary permissions to execute these scripts.
- Modify the custom directories in the scripts as needed.
