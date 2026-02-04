# dotfiles 改善タスク（最終版）

## 決定事項サマリ

| 項目 | 決定 |
|------|------|
| dotfiles 管理 | GNU Stow |
| シェル | 素の .zshrc（zprezto 削除） |
| プロンプト | starship |
| fuzzy finder | fzf（peco から移行） |
| 言語バージョン管理 | mise（nodenv/pyenv から統合） |
| Vim | 最小限（NeoBundle 削除） |

---

## ディレクトリ構成（stow 対応）

```
dotfiles/
├── zsh/
│   └── .zshrc
├── git/
│   └── .gitconfig
├── vim/
│   └── .vimrc
├── starship/
│   └── .config/
│       └── starship.toml
├── Brewfile
├── setup.sh
└── docs/
    ├── improvement-tasks.md
    ├── requirements-discussion.md
    └── brewfile-review.md
```

**使い方:**
```bash
cd ~/dotfiles
stow zsh git vim starship
```

---

## タスク一覧

### Phase 1: 構成変更

#### 1.1 zprezto 削除
```bash
git submodule deinit -f .zprezto
git rm -rf .zprezto
rm -rf .git/modules/.zprezto
```

#### 1.2 stow 用ディレクトリ作成
```bash
mkdir -p zsh git vim starship/.config
mv .zshrc zsh/
mv .gitconfig git/
mv .vimrc vim/
```

#### 1.3 setup.sh 更新
```bash
#!/bin/bash
set -e

cd "$(dirname "$0")"

# Homebrew がなければインストール
if ! command -v brew &> /dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# パッケージインストール
brew bundle

# stow で dotfiles をリンク
stow zsh git vim starship

echo "Setup complete!"
```

---

### Phase 2: 設定ファイル更新

#### 2.1 .gitconfig
```gitconfig
[user]
    name = childbamboo
    email = childbamboo1980@gmail.com
[push]
    default = current
[pull]
    rebase = true
[init]
    defaultBranch = main
[alias]
    st = status
    co = checkout
    br = branch
    lg = log --oneline --graph --decorate
    df = diff
    cm = commit
[core]
    editor = vim
    autocrlf = input
[merge]
    ff = false
[fetch]
    prune = true
```

#### 2.2 .vimrc（最小限）
```vim
set nocompatible
syntax on
filetype plugin indent on

set encoding=utf-8
set fileencoding=utf-8
set ts=2 sw=2 expandtab
set softtabstop=2
set ignorecase smartcase
set incsearch
set clipboard+=unnamed
set laststatus=2
set wrap

colorscheme desert
```

#### 2.3 .zshrc（新規）
```zsh
# ============================================
# 環境変数
# ============================================
export LANG=ja_JP.UTF-8
export EDITOR=vim

# ============================================
# Homebrew
# ============================================
if [[ -f /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -f /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
fi

# ============================================
# 補完
# ============================================
autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# zsh-completions
if type brew &>/dev/null; then
    FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
    FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
fi

# zsh-autosuggestions
if [[ -f $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
    source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# ============================================
# ヒストリ
# ============================================
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
setopt share_history
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_reduce_blanks

# ============================================
# オプション
# ============================================
setopt auto_cd
setopt auto_pushd
setopt pushd_ignore_dups
setopt no_beep
setopt print_eight_bit

# ============================================
# キーバインド
# ============================================
bindkey -e

# ============================================
# エイリアス
# ============================================
# eza (ls の代替)
if command -v eza &> /dev/null; then
    alias ls='eza'
    alias ll='eza -la'
    alias la='eza -la'
    alias tree='eza --tree'
else
    alias ll='ls -la'
    alias la='ls -la'
fi

# bat (cat の代替)
if command -v bat &> /dev/null; then
    alias cat='bat'
fi

# ripgrep
if command -v rg &> /dev/null; then
    alias grep='rg'
fi

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias mkdir='mkdir -p'

# ============================================
# fzf
# ============================================
if command -v fzf &> /dev/null; then
    source <(fzf --zsh)
    export FZF_DEFAULT_OPTS='--height 40% --reverse'
fi

# ghq + fzf
function ghq-fzf() {
    local repo=$(ghq list | fzf --preview "bat --color=always --style=header,grid $(ghq root)/{}/README.md 2>/dev/null || ls -la $(ghq root)/{}")
    if [[ -n "$repo" ]]; then
        cd "$(ghq root)/$repo"
    fi
}
alias g='ghq-fzf'

# ============================================
# zoxide (cd の代替)
# ============================================
if command -v zoxide &> /dev/null; then
    eval "$(zoxide init zsh)"
fi

# ============================================
# starship (プロンプト)
# ============================================
if command -v starship &> /dev/null; then
    eval "$(starship init zsh)"
fi

# ============================================
# mise (バージョン管理)
# ============================================
if command -v mise &> /dev/null; then
    eval "$(mise activate zsh)"
fi

# ============================================
# Google Cloud SDK (存在する場合のみ)
# ============================================
if [[ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]]; then
    source "$HOME/google-cloud-sdk/path.zsh.inc"
fi
if [[ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]]; then
    source "$HOME/google-cloud-sdk/completion.zsh.inc"
fi
```

#### 2.4 starship.toml
```toml
# ~/.config/starship.toml

format = """
$directory\
$git_branch\
$git_status\
$nodejs\
$python\
$line_break\
$character"""

[directory]
truncation_length = 3
truncate_to_repo = false

[git_branch]
symbol = " "

[git_status]
format = '([$all_status$ahead_behind]($style) )'

[nodejs]
symbol = " "

[python]
symbol = " "

[character]
success_symbol = "[❯](green)"
error_symbol = "[❯](red)"
```

---

## Brewfile（更新済み）

```ruby
tap "heroku/brew"
tap "homebrew/bundle"

# Shell
brew "zsh"
brew "zsh-completions"
brew "zsh-autosuggestions"
brew "starship"

# CLI Tools
brew "fzf"
brew "bat"
brew "eza"
brew "ripgrep"
brew "jq"
brew "zoxide"
brew "stow"
brew "ghq"
brew "gh"
brew "mas"

# Development
brew "mise"
brew "awscli"
brew "docker"
brew "heroku/brew/heroku"

# Applications
cask "authy"
cask "docker"
cask "google-chrome"
cask "google-japanese-ime"
cask "visual-studio-code"
cask "zoom"

# Mac App Store
mas "Kindle", id: 405399194
mas "LastPass", id: 926036361
mas "LINE", id: 539883307
mas "Slack", id: 803453959
mas "Xcode", id: 497799835
```

---

## 実装チェックリスト

### Phase 1: 構成変更
- [ ] zprezto サブモジュール削除
- [ ] stow 用ディレクトリ作成
- [ ] ファイル移動

### Phase 2: 設定ファイル
- [ ] .gitconfig 更新
- [ ] .vimrc 最小化
- [ ] .zshrc 新規作成
- [ ] starship.toml 作成

### Phase 3: セットアップ
- [ ] setup.sh 更新
- [ ] stow でリンク確認
- [ ] 動作確認

### Phase 4: クリーンアップ
- [ ] 不要ファイル削除
- [ ] git commit
- [ ] README.md 更新
