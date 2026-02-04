# dotfiles

macOS / Linux 用の dotfiles。GNU Stow でシンボリックリンクを管理。

## Setup

```bash
# 1. Clone
git clone https://github.com/childbamboo/dotfiles.git ~/dotfiles
cd ~/dotfiles

# 2. Run setup
./setup.sh
```

`setup.sh` は以下を実行します：
- Homebrew のインストール（未インストールの場合）
- `brew bundle` でパッケージインストール
- `stow` で dotfiles をホームディレクトリにリンク

## Structure

```
dotfiles/
├── zsh/.zshrc                    # Zsh 設定
├── git/.gitconfig                # Git 設定
├── vim/.vimrc                    # Vim 設定（最小限）
├── starship/.config/starship.toml # プロンプト設定
├── claude/.claude/CLAUDE.md      # Claude Code 設定
├── Brewfile                      # Homebrew パッケージ
├── setup.sh                      # セットアップスクリプト
└── docs/                         # ドキュメント
```

### Stow の使い方

```bash
cd ~/dotfiles

# リンク作成
stow zsh          # ~/.zshrc を作成
stow git          # ~/.gitconfig を作成
stow starship     # ~/.config/starship.toml を作成

# リンク解除
stow -D zsh

# 全部まとめて
stow zsh git vim starship claude
```

## Design

### GNU Stow による管理

手書きのシンボリックリンクスクリプトではなく、Stow を採用。
- 冪等性がある（何度実行しても安全）
- ディレクトリ構造をそのまま `$HOME` に展開
- パッケージ単位で有効/無効を切り替え可能

### シンプルな Zsh 設定

フレームワーク（oh-my-zsh, prezto 等）は使わず、素の `.zshrc` で管理。
- 依存が少なく、起動が速い
- 何が起きているか把握しやすい
- 必要な機能だけを追加

### モダン CLI ツール

| ツール | 用途 |
|--------|------|
| fzf | Fuzzy finder（履歴検索、ファイル検索） |
| bat | cat の代替（シンタックスハイライト） |
| eza | ls の代替（アイコン、Git 連携） |
| ripgrep | grep の代替（高速） |
| zoxide | cd の代替（履歴学習） |
| starship | プロンプト（Git 状態、言語バージョン表示） |
| mise | 言語バージョン管理（Node.js, Python 等） |

### 存在チェックによるフォールバック

ツールがインストールされていない環境でもエラーにならないよう、存在チェックを行う。

```zsh
if command -v eza &> /dev/null; then
    alias ls='eza'
else
    alias ll='ls -la'
fi
```

## Key Bindings

| キー | 機能 |
|------|------|
| `Ctrl+R` | 履歴検索（fzf） |
| `Ctrl+T` | ファイル検索（fzf） |
| `Alt+C` | ディレクトリ移動（fzf） |
| `g` | ghq リポジトリ選択 |
| `z <dir>` | zoxide でジャンプ |

## Requirements

- macOS or Linux
- Homebrew（macOS）または対応するパッケージマネージャー
- Git
