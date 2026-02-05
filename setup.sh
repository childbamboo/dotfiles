#!/bin/bash
set -e

cd "$(dirname "$0")"

echo "=== dotfiles setup ==="

OS="$(uname -s)"
echo "Detected OS: $OS"

# 共通の stow 対象
COMMON_PACKAGES="zsh git vim starship claude"

case "$OS" in
    Darwin)
        # === macOS ===

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

        # stow で dotfiles をリンク（karabiner 含む）
        echo "Linking dotfiles with stow..."
        stow -v $COMMON_PACKAGES karabiner
        ;;

    Linux)
        # === Linux ===

        # パッケージインストール
        SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
        if [[ -f "$SCRIPT_DIR/packages-linux.sh" ]]; then
            echo "Installing packages..."
            bash "$SCRIPT_DIR/packages-linux.sh"
        fi

        # stow がなければエラー（packages-linux.sh でインストール済みのはず）
        if ! command -v stow &> /dev/null; then
            echo "Error: stow is not installed."
            echo "Please install stow first:"
            echo "  Ubuntu/Debian: sudo apt install stow"
            echo "  Arch Linux:    sudo pacman -S stow"
            echo "  Fedora:        sudo dnf install stow"
            exit 1
        fi

        # 必要なディレクトリを作成
        mkdir -p ~/.config

        # stow で dotfiles をリンク（karabiner 除外）
        echo "Linking dotfiles with stow..."
        stow -v $COMMON_PACKAGES
        ;;

    *)
        echo "Unsupported OS: $OS"
        exit 1
        ;;
esac

echo ""
echo "=== Setup complete! ==="
echo ""
echo "Please restart your terminal or run: source ~/.zshrc"
