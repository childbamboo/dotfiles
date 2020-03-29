#!/bin/bash

DOTFILEDIR=$HOME/dotfiles

echo "# zsh setting"

echo "## change defaullt shell zsh"

chsh -s /usr/local/bin/zsh

echo "## set links of zsh configuration files of zprezto"

ln -s $DOTFILEDIR/.zprezto/runcoms/zshenv $HOME/.zshenv
ln -s $DOTFILEDIR/.zprezto/runcoms/zprofile $HOME/.zprofile
ln -s $DOTFILEDIR/.zprezto/runcoms/zshrc $HOME/.zshrc
ln -s $DOTFILEDIR/.zprezto/runcoms/zpreztorc $HOME/.zpreztorc
ln -s $DOTFILEDIR/.zprezto/runcoms/zlogin $HOME/.zlogin
ln -s $DOTFILEDIR/.zprezto/runcoms/zlogout $HOME/.zlogout

touch $HOME/.zsh_history

echo "# vim setting"

ln -s $DOTFILEDIR/.vimrc $HOME/.vimrc

echo "# git setting"

ln -s $DOTFILEDIR/.gitconfig $HOME/.gitconfig
ln -s $DOTFILEDIR/.gitignore_global $HOME/.gitignore_global

echo "# zsh completion setting"

mkdir -p $HOME/.zsh/completion

echo "## git command completion"

curl -o $HOME/.zsh/completion/_git https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.zsh

echo "## docker command completion"

curl -o $HOME/.zsh/completion/_docker https://raw.githubusercontent.com/docker/cli/master/contrib/completion/zsh/_docker
