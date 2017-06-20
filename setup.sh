basepath=$(cd $(dirname $0);pwd)

# symlink dotfiles into ~files=.*
ln -sf $basepath/.zprezto ~
ln -sf $basepath/.zprezto/runcoms/zlogin ~/.zlogin
ln -sf $basepath/.zprezto/runcoms/zlogout ~/.zlogout
ln -sf $basepath/.zprezto/runcoms/zpreztorc ~/.zpreztorc
ln -sf $basepath/.zprezto/runcoms/zprofile ~/.zprofile
ln -sf $basepath/.zprezto/runcoms/zshenv ~/.zshenv
ln -sf $basepath/.zprezto/runcoms/zshrc ~/.zshrc

#setopt $EXTENDED_GLOB
#for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N) ; do
#  echo "ooooooooooo"
#  ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
#done

#files=.*
#for file in $files
#do
#  if [ ! -d $file -a $file != "." -a $file != ".." \
#         -a $file != ".git" -a $file != ".gitconfig" ] ; then
#    ln -sf $basepath/$file ~
#  fi
#done

# symlink zsh configuration files into ~/.zsh
#if [ ! -d ~/.zsh ] ; then
#  mkdir ~/.zsh
#fi
#for file in .zsh/.*
#do
#  if [ $file != "." -a $file != ".." -a $file != ".git" ] ; then
#    ln -sf $basepath/$file ~/.zsh/
#  fi
#done
