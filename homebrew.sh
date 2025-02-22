#!/bin/zsh

# Installing Homebrew
brewinstall () {
	local DIR=~/goinfre/homebrew
	local REMOVE=false

	while getopts ":r" opt; do
		case $opt in
			r)
				REMOVE=true
				;;
			\?)
				echo "Invalid option: -$OPTARG"
				return 1
				;;
		esac
	done
	shift $((OPTIND - 1))
	if [ "$REMOVE" = true ]; then
		# confirm if user wants to remove homebrew
		echo -n "Are you sure you want to remove Homebrew? [y/N]: " && read -r REPLY
		[[ ! $REPLY =~ ^[Yy]$ ]] && return 0
		# remove homebrew
		([ -d "$DIR" ] && rm -rf "$DIR" && echo "Homebrew removed") || echo "Homebrew is not installed"
	fi
	# check if homebrew is already installed
	[ -d $DIR ] && echo "Homebrew is already installed" && return 0
	# install homebrew
	mkdir -p $DIR && curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C $DIR
	# check if homebrew is in PATH
	if ! echo "$PATH" | grep -q $(realpath $DIR/bin); then
		export PATH=$(realpath $DIR/bin):$PATH
		echo "export PATH=$(realpath $DIR/bin):\$PATH" >> ~/.zshrc
	fi
	if ! echo "$PATH" | grep -q $(realpath $DIR/sbin); then
		export PATH=$(realpath $DIR/sbin):$PATH
		echo "export PATH=$(realpath $DIR/sbin):\$PATH" >> ~/.zshrc
	fi
	# install homebrew packages
	brew update && brew upgrade
}

# Installing my favorite packages with Homebrew
mybpkgs () {
	brew install zoxide tree bat fzf rm-improved bat ripgrep lsd yazi \
		tree onefetch lazydocker lazygit
}

# Main function to handle arguments
main () {
	if [ $# -eq 0 ]; then
		if [ -x "$(command -v brew)" ]; then
			echo "Homebrew is already installed"
		else
			brewinstall
		fi
		return
	fi

	while getopts ":p:r" opt; do
		case $opt in
			p)
				mybpkgs $OPTARG
				;;
			r)
				brewinstall -r
				;;
			\?)
				echo "Invalid option: -$OPTARG"
				return 1
				;;
		esac
	done
}

main "$@"
