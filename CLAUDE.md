# Dotfiles Repository

macOS/Linux 向け個人設定ファイル管理リポジトリ。GNU Stow によるシンボリックリンク管理。

## Structure

```
dotfiles/
├── zsh/          # .zshrc - シェル設定
├── git/          # .gitconfig, .config/git/ignore
├── vim/          # .vimrc - 最小限のVim設定
├── starship/     # .config/starship.toml - プロンプト
├── claude/       # .claude/CLAUDE.md - Claude個人設定
├── Brewfile      # Homebrew パッケージ定義
└── setup.sh      # インストールスクリプト
```

## Development Guidelines

### Testing Changes

設定変更後の検証方法：

```bash
# zsh: 新しいシェルで確認
zsh -l

# git: 設定確認
git config --list --show-origin

# stow: dry-run で確認
stow -n -v zsh  # -n = no-action, -v = verbose
```

### Stow Operations

```bash
# リンク作成
stow zsh git vim starship claude

# リンク解除
stow -D zsh

# 再リンク（変更時）
stow -R zsh
```

### Adding New Config

1. `newconfig/.configfile` のようにディレクトリ構造を作成
2. `setup.sh` の stow コマンドに追加
3. README.md の構造説明を更新

## Key Files

- `zsh/.zshrc` - fzf, zoxide, mise, ghq 統合。ツール存在チェックで graceful degradation
- `Brewfile` - `brew bundle` で一括インストール。renovate.json で自動更新
- `.config/karabiner/karabiner.json` - Caps Lock → Ctrl 等のキーマッピング

## Notes

- `bin/` 配下のスクリプトは deprecated（zprezto時代の遺産）
- フォントは `font-plemonl-jp-*` を使用（cask-fonts tap は廃止済み）
- 環境依存の設定は `command -v` でチェックしてから適用
