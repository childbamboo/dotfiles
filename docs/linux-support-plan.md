# Linux サポート計画

## 概要

macOS 向けに整備してきた dotfiles を Linux（WSL2 含む）でも利用できるようにする。

## 現状分析

### シンボリックリンク状態（Linux 環境）

| ファイル | 状態 |
|---------|------|
| `.zshrc` | 未リンク |
| `.vimrc` | 未リンク |
| `.gitconfig` | 手動作成（dotfiles と内容が異なる） |
| `.config/starship.toml` | 未リンク |
| `.claude/` | 存在（手動設定） |

### クロスプラットフォーム対応状況

| ファイル | 対応状況 | 備考 |
|---------|----------|------|
| `zsh/.zshrc` | ✅ 良好 | pbcopy/xsel 分岐、ツール存在チェックあり |
| `vim/.vimrc` | ✅ 問題なし | OS 依存なし |
| `git/.gitconfig` | ✅ 問題なし | OS 依存なし |
| `git/.config/git/ignore` | ✅ 問題なし | macOS/Linux/Windows 対応済み |
| `starship/.config/starship.toml` | ✅ 問題なし | OS 依存なし |
| `claude/` | ✅ 問題なし | OS 依存なし |
| `setup.sh` | ⚠️ 要修正 | Homebrew 前提、OS 分岐なし |
| `Brewfile` | ❌ macOS 専用 | mas, cask 等 macOS 固有 |
| `.config/karabiner/` | ❌ macOS 専用 | Karabiner-Elements は macOS のみ |
| `bin/setup_mac.sh` | ❌ deprecated | 削除候補 |
| `bin/install_dotfiles.sh` | ❌ deprecated | zprezto 時代の遺産、削除候補 |

### zsh/.zshrc の良好な点

既に以下のクロスプラットフォーム対応が実装済み：

```bash
# クリップボード分岐
if which pbcopy >/dev/null 2>&1; then      # macOS
    alias -g C='| pbcopy'
elif which xsel >/dev/null 2>&1; then      # Linux
    alias -g C='| xsel --input --clipboard'
fi

# ツール存在チェック（graceful degradation）
if command -v eza &> /dev/null; then
    alias ls='eza'
fi
```

## 修正計画

### Phase 1: 即時対応（共通設定の適用）

Linux 環境で今すぐ stow 可能な設定を適用。

```bash
cd ~/dotfiles
stow zsh git vim starship claude
```

**注意**: karabiner は stow しない（macOS 専用のため）

### Phase 2: setup.sh の OS 分岐追加

```bash
#!/bin/bash
set -euo pipefail

OS="$(uname -s)"

# 共通の stow 対象
COMMON_PACKAGES="zsh git vim starship claude"

case "$OS" in
    Darwin)
        # Homebrew 初期化
        if [[ -f /opt/homebrew/bin/brew ]]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        elif [[ -f /usr/local/bin/brew ]]; then
            eval "$(/usr/local/bin/brew shellenv)"
        fi

        # パッケージインストール
        brew install stow
        brew bundle

        # stow 実行（karabiner 含む）
        stow $COMMON_PACKAGES karabiner
        ;;

    Linux)
        # stow インストール確認
        if ! command -v stow &> /dev/null; then
            echo "Please install stow first:"
            echo "  Ubuntu/Debian: sudo apt install stow"
            echo "  Arch: sudo pacman -S stow"
            exit 1
        fi

        # stow 実行（karabiner 除外）
        stow $COMMON_PACKAGES
        ;;
esac

echo "Setup completed for $OS"
```

### Phase 3: Linux 用パッケージリスト作成

新規ファイル `packages-linux.sh`:

```bash
#!/bin/bash
# Linux 用パッケージインストールスクリプト

set -euo pipefail

# 必須パッケージ（APT）
ESSENTIAL_PACKAGES=(
    stow
    zsh
    git
    vim
    fzf
    ripgrep
    jq
    curl
    unzip
)

# Debian/Ubuntu
if command -v apt &> /dev/null; then
    sudo apt update
    sudo apt install -y "${ESSENTIAL_PACKAGES[@]}"
fi

# 追加ツール（公式インストーラ使用）
# mise
curl https://mise.run | sh

# starship
curl -sS https://starship.rs/install.sh | sh

# zoxide
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh

# GitHub CLI
# https://github.com/cli/cli/blob/trunk/docs/install_linux.md

# bat (batcat として提供される場合あり)
# eza (cargo install 推奨)
```

### Phase 4: 整理・クリーンアップ

#### 削除対象

- `bin/setup_mac.sh` - deprecated、setup.sh に統合済み
- `bin/install_dotfiles.sh` - zprezto 時代の遺産

#### Brewfile の整理

macOS 専用セクションを明示的にコメント:

```ruby
# === Cross-platform CLI tools ===
brew "fzf"
brew "bat"
brew "eza"
brew "ripgrep"
brew "jq"
brew "zoxide"
brew "stow"
brew "ghq"
brew "gh"
brew "mise"
brew "starship"

# === macOS only ===
brew "mas"  # Mac App Store CLI

cask "google-japanese-ime"
cask "karabiner-elements"
# ...

mas "Kindle", id: 302584613
mas "Xcode", id: 497799835
# ...
```

## タスクリスト

- [ ] Phase 1: 共通設定を stow で適用
- [ ] Phase 2: setup.sh に OS 分岐を追加
- [ ] Phase 3: packages-linux.sh を作成
- [ ] Phase 4: deprecated スクリプトを削除
- [ ] Phase 4: Brewfile にセクションコメントを追加
- [ ] ドキュメント: CLAUDE.md に Linux サポート状況を明記

## 参考: Linux で必要なツールのインストール方法

| ツール | Ubuntu/Debian | 備考 |
|--------|---------------|------|
| stow | `apt install stow` | |
| zsh | `apt install zsh` | |
| fzf | `apt install fzf` | |
| bat | `apt install bat` | `batcat` としてインストールされる場合あり |
| eza | cargo install | `apt` にない場合が多い |
| ripgrep | `apt install ripgrep` | |
| jq | `apt install jq` | |
| zoxide | 公式スクリプト | |
| starship | 公式スクリプト | |
| mise | 公式スクリプト | |
| gh | GitHub 公式リポジトリ追加 | |
| xsel | `apt install xsel` | クリップボード連携用 |

## 備考

- WSL2 環境では Windows 側のフォント設定が優先されるため、`font-plemol-jp-*` は Windows Terminal 側で設定
- Karabiner の代替として Linux では `keyd` や `xremap` が利用可能（必要に応じて検討）
