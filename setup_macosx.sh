#!/bin/bash

ask() {
    printf "$* [y/n] "
    local answer
    read answer
  
    case $answer in
        "yes" ) return 0 ;;
        "y" )   return 0 ;;
        * )     return 1 ;;
    esac
}

set -e

# コマンドラインツールのインストール
if ask 'Xcode'; then
    xcode-select --install
fi

if ask 'Homebrew'; then
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    brew doctor
fi

if ask 'Homebrew bundle?'; then
    brew tap Homebrew/bundle
    brew bundle
fi
