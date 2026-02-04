#!/bin/bash

DOTFILEDIR=$HOME/dotfiles

echo "# install dependency pkgs to setup for mac"

echo "## install homebrew"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

echo "## update homebrew"
brew update

echo "## install xcode"
xcode-select --install

echo "# deploy dotfiles"

echo "## brew bundle"
brew bundle --file $HOME/dotfiles/Brewfile

echo "## brew bundle"
$HOME/dotfiles/bin/install_dotfiles.sh

echo "# plugins for specified apps"

echo "## inkdrop plugins"
ipm install toc # table of contents

echo "## karabiner-elements config file"
mv $HOME/.config/karabiner/karabiner.json $HOME/.config/karabiner/karabiner.org.json 
ln -s $DOTFILEDIR/.config/karabiner/karabiner.json $HOME/.config/karabiner/karabiner.json