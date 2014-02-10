#!/bin/bash
cd "$(dirname "$0")"
git pull
function doIt() {
	# prepare all dirs and installs
        if [ ! -d ~/code ]; then
          mkdir ~/code
        fi
        if [ ! -d ~/code/z ]; then
          git clone https://github.com/rupa/z.git ~/code/z
        fi
        if [ ! -d ~/.vim/bundle/vundle ]; then
          git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
        fi
        if [ ! -d ~/.vim/bundle/YouCompleteMe ]; then
          sudo apt-get install -y build-essential cmake python-dev
          git clone https://github.com/Valloric/YouCompleteMe.git ~/.vim/bundle/YouCompleteMe
          (cd ~/.vim/bundle/YouCompleteMe && git submodule update --init --recursive && ./install.sh --clang-completer)
        fi
        if [ ! -d /usr/local/rvm ]; then
          # https://rvm.io
          # rvm for the rubiess
          curl -L https://get.rvm.io | sudo bash -s stable --ruby
        fi

	# sync all files to our $HOME directory ~/
	rsync \
	--exclude ".git/" \
	--exclude ".gitignore" \
	--exclude ".gitkeep" \
	--exclude ".DS_Store" \
	--exclude "sync.sh" \
	--exclude "README.md" \
	--exclude "LICENSE" \
	-av . ~

	# Vundle install all defined Bundles
        vim +BundleInstall +qall

        # set some OSX defaults
        ###bash ~/.dotfiles/osx-set-terminal-defaults.sh

}
if [ "$1" == "--force" -o "$1" == "-f" ]; then
	doIt
else
	read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1
	echo
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		doIt
	fi
fi
unset doIt
source ~/.bash_profile
