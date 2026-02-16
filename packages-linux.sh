#!/bin/bash
# Linux 用パッケージインストールスクリプト

set -e

echo "=== Linux packages setup ==="

# ディストリビューション検出
if [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRO=$ID
else
    DISTRO="unknown"
fi

echo "Detected distro: $DISTRO"

# === 基本パッケージ（パッケージマネージャ経由） ===

ESSENTIAL_PACKAGES=(
    stow
    zsh
    zsh-autosuggestions
    git
    vim
    fzf
    ripgrep
    jq
    curl
    unzip
    xsel  # クリップボード連携
)

case "$DISTRO" in
    ubuntu|debian)
        echo "Installing packages via apt..."
        sudo apt update
        sudo apt install -y "${ESSENTIAL_PACKAGES[@]}"
        ;;
    arch|manjaro)
        echo "Installing packages via pacman..."
        sudo pacman -Syu --noconfirm "${ESSENTIAL_PACKAGES[@]}"
        ;;
    fedora)
        echo "Installing packages via dnf..."
        sudo dnf install -y "${ESSENTIAL_PACKAGES[@]}"
        ;;
    *)
        echo "Unknown distro: $DISTRO"
        echo "Please install manually: ${ESSENTIAL_PACKAGES[*]}"
        ;;
esac

# === 追加ツール（公式インストーラ使用） ===

echo ""
echo "=== Installing additional tools ==="

# mise (runtime version manager)
if ! command -v mise &> /dev/null; then
    echo "Installing mise..."
    curl https://mise.run | sh
    echo 'eval "$(~/.local/bin/mise activate bash)"' >> ~/.bashrc
else
    echo "mise: already installed"
fi

# starship (prompt)
if ! command -v starship &> /dev/null; then
    echo "Installing starship..."
    curl -sS https://starship.rs/install.sh | sh -s -- -y
else
    echo "starship: already installed"
fi

# zoxide (smart cd)
if ! command -v zoxide &> /dev/null; then
    echo "Installing zoxide..."
    curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
else
    echo "zoxide: already installed"
fi

# Claude CLI
if ! command -v claude &> /dev/null; then
    echo "Installing Claude CLI..."
    curl -fsSL https://claude.ai/install.sh | sh
else
    echo "claude: already installed"
fi

# GitHub CLI
if ! command -v gh &> /dev/null; then
    echo "Installing GitHub CLI..."
    case "$DISTRO" in
        ubuntu|debian)
            curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
            echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
            sudo apt update
            sudo apt install -y gh
            ;;
        arch|manjaro)
            sudo pacman -S --noconfirm github-cli
            ;;
        fedora)
            sudo dnf install -y gh
            ;;
        *)
            echo "Please install gh manually: https://github.com/cli/cli#installation"
            ;;
    esac
else
    echo "gh: already installed"
fi

# ghq (git repository manager)
if ! command -v ghq &> /dev/null; then
    echo "Installing ghq..."
    GHQ_VERSION=$(curl -sS https://api.github.com/repos/x-motemen/ghq/releases/latest | jq -r .tag_name | sed 's/^v//')
    ARCH=$(uname -m)
    case "$ARCH" in
        x86_64)  GHQ_ARCH="amd64" ;;
        aarch64) GHQ_ARCH="arm64" ;;
        *)       GHQ_ARCH="$ARCH" ;;
    esac
    curl -fsSL "https://github.com/x-motemen/ghq/releases/download/v${GHQ_VERSION}/ghq_linux_${GHQ_ARCH}.zip" -o /tmp/ghq.zip
    unzip -o /tmp/ghq.zip -d /tmp/ghq
    install -m 755 /tmp/ghq/ghq_linux_${GHQ_ARCH}/ghq ~/.local/bin/ghq
    rm -rf /tmp/ghq /tmp/ghq.zip
    echo "ghq ${GHQ_VERSION} installed to ~/.local/bin/ghq"
else
    echo "ghq: already installed"
fi

# Google Cloud CLI
if ! command -v gcloud &> /dev/null; then
    echo "Installing Google Cloud CLI..."
    case "$DISTRO" in
        ubuntu|debian)
            curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg
            echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee /etc/apt/sources.list.d/google-cloud-sdk.list > /dev/null
            sudo apt update
            sudo apt install -y google-cloud-cli
            ;;
        *)
            ARCH=$(uname -m)
            case "$ARCH" in
                x86_64)  GCLOUD_ARCH="x86_64" ;;
                aarch64) GCLOUD_ARCH="arm" ;;
                *)       GCLOUD_ARCH="$ARCH" ;;
            esac
            curl -fsSL "https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-linux-${GCLOUD_ARCH}.tar.gz" -o /tmp/google-cloud-cli.tar.gz
            tar -xf /tmp/google-cloud-cli.tar.gz -C ~/
            ~/google-cloud-sdk/install.sh --quiet --path-update true --command-completion true
            rm -f /tmp/google-cloud-cli.tar.gz
            ;;
    esac
    echo "gcloud installed. Run 'gcloud init' to configure."
else
    echo "gcloud: already installed"
fi

# === オプション: apt にないツール ===

echo ""
echo "=== Optional tools (manual install) ==="
echo ""
echo "The following tools may need manual installation:"
echo "  - eza: cargo install eza (or check https://eza.rocks)"
echo "  - bat: may be installed as 'batcat' on Debian/Ubuntu"
echo ""

# bat の batcat エイリアス対応（Debian/Ubuntu）
if command -v batcat &> /dev/null && ! command -v bat &> /dev/null; then
    echo "Note: 'bat' is installed as 'batcat'. Creating alias..."
    mkdir -p ~/.local/bin
    ln -sf "$(which batcat)" ~/.local/bin/bat
    echo "Symlink created: ~/.local/bin/bat -> batcat"
fi

echo ""
echo "=== Setup complete! ==="
echo ""
echo "Next steps:"
echo "  1. Run: source ~/.zshrc"
echo "  2. Run: gh auth login"
echo "  3. Optional: chsh -s \$(which zsh)"
