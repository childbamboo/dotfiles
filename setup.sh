#!/bin/bash
set -e

cd "$(dirname "$0")"

echo "=== dotfiles setup ==="

# Homebrew がなければインストール
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Homebrew のパスを設定
    if [[ -f /opt/homebrew/bin/brew ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -f /usr/local/bin/brew ]]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi
fi

# stow がなければインストール
if ! command -v stow &> /dev/null; then
    echo "Installing stow..."
    brew install stow
fi

# パッケージインストール
echo "Installing packages from Brewfile..."
brew bundle

# 必要なディレクトリを作成
mkdir -p ~/.config

# stow で dotfiles をリンク
echo "Linking dotfiles with stow..."
stow -v zsh git vim starship

echo ""
echo "=== Setup complete! ==="
echo ""
echo "Please restart your terminal or run: source ~/.zshrc"
