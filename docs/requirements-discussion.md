# dotfiles 改善要件 - 壁打ちメモ

## 1. 現状の確認

### 使用環境
- [ ] macOS のみ
- [x] macOS + Linux
- [x] 複数マシンで共有

### 用途
- [ ] 個人開発（趣味・副業）
- [ ] 業務開発
- [ ] 両方
- [ ] 新規マシンセットアップ用（たまにしか使わない）

### メインエディタ
- [ ] VS Code
- [ ] Vim/Neovim
- [ ] 両方使い分け
- [ ] その他（JetBrains等）

### よく使う言語/フレームワーク
- [ ] Ruby/Rails（.vimrc に設定あり）
- [ ] JavaScript/TypeScript
- [ ] Python
- [ ] Go
- [ ] その他: _______________

---

## 2. 改善の方向性を決める

### 優先度の確認

**すぐ直すべき（バグ・非推奨）:**
| 項目 | 対応する？ | メモ |
|------|-----------|------|
| `.zshrc` rbenv 2回呼び出し | Yes / No / 要検討 | |
| `.zshrc` ハードコードパス修正 | Yes / No / 要検討 | |
| `.gitconfig` email 追加 | Yes / No / 要検討 | |
| `Brewfile` hub → gh | Yes / No / 要検討 | |
| `Brewfile` zoomus → zoom | Yes / No / 要検討 | |

**中期的な改善:**
| 項目 | 対応する？ | メモ |
|------|-----------|------|
| NeoBundle → vim-plug 移行 | Yes / No / 要検討 | Vim 使う頻度による |
| setup.sh 書き直し | Yes / No / 要検討 | |
| zprezto サブモジュール整理 | Yes / No / 要検討 | |

**やるかどうか検討:**
| 項目 | 対応する？ | メモ |
|------|-----------|------|
| モダン CLI ツール導入 (bat, eza, fd, ripgrep) | Yes / No / 要検討 | |
| starship プロンプト導入 | Yes / No / 要検討 | |
| XDG Base Directory 準拠 | Yes / No / 要検討 | |
| macOS defaults 設定追加 | Yes / No / 要検討 | |
| README.md 充実 | Yes / No / 要検討 | |

---

## 3. 設計方針（決定済み）

### GNU Stow の導入

**理由:** dotfiles の更新反映を簡単にしたい

**stow とは:**
- シンボリックリンクを自動管理するツール
- ディレクトリ構造をそのまま `$HOME` にリンク
- `stow <package>` でリンク作成、`stow -D <package>` で削除
- 冪等性があり、何度実行しても安全

**ディレクトリ構成案:**
```
dotfiles/
├── zsh/
│   └── .zshrc           → ~/.zshrc
├── git/
│   └── .gitconfig       → ~/.gitconfig
├── vim/
│   └── .vimrc           → ~/.vimrc
├── Brewfile             # stow 対象外
├── setup.sh             # stow 対象外
└── docs/
```

**使い方:**
```bash
cd ~/dotfiles
stow zsh      # ~/.zshrc をリンク
stow git      # ~/.gitconfig をリンク
stow -D zsh   # リンク解除
```

**macOS / Linux 両対応:**
- macOS: `brew install stow`
- Linux: `apt install stow` / `pacman -S stow`

---

### Vim は最小限に

**方針:** ほとんど使わなくなったので最小限の整備でOK

**最小限の .vimrc:**
```vim
" 最小限の設定
set nocompatible
syntax on
filetype plugin indent on

set encoding=utf-8
set ts=2 sw=2 expandtab
set ignorecase smartcase
set incsearch
set clipboard+=unnamed
set laststatus=2

" カラースキーム（お好みで）
colorscheme desert
```

- NeoBundle は削除（プラグイン管理なし or 必要なら vim-plug を後で追加）
- Rails 関連プラグインは削除

---

### peco → fzf への移行

**現状:** peco + anyframe でコマンドサジェスト

**モダンな代替:**
| 現在 | 移行先 | 理由 |
|------|--------|------|
| peco | **fzf** | エコシステム充実、シェル統合が優秀 |
| anyframe | **fzf 標準機能** | Ctrl+R, Ctrl+T, Alt+C が標準で付属 |

**fzf の特徴:**
- Ctrl+R: 履歴検索（peco-select-history の代替）
- Ctrl+T: ファイル検索
- Alt+C: ディレクトリ移動
- `ghq` + `fzf` 連携も簡単
- `bat` と組み合わせてプレビュー付き検索

**zsh-autosuggestions も併用推奨:**
- 入力中にグレーで候補表示
- → キーで補完確定

---

## 4. 質問・検討事項

### Q1: zprezto はまだ使いたい？

**現状:** setup.sh で zprezto をリンクしているが、git status で大量の削除が出ている

**選択肢:**
- A) zprezto を引き続き使う → サブモジュール修復
- B) zprezto をやめて素の zsh + プラグイン管理（zinit, sheldon 等）
- C) zprezto をやめて oh-my-zsh
- D) シンプルに自前の .zshrc だけで管理（fzf + zsh-autosuggestions だけ）

**決定:** D) zprezto 削除、素の .zshrc + fzf + zsh-autosuggestions

---

### Q2: バージョン管理ツールはどれを残す？

**現状の .zshrc:**
- rbenv (Ruby)
- pyenv (Python)
- plenv (Perl)
- goenv (Go)
- ndenv (非推奨) → nodenv に変更？

**mise とは:**
rbenv, pyenv, nodenv, goenv などを **1つに統合** したツール。
- `.tool-versions` 1ファイルで全言語のバージョン管理
- シェル起動が速くなる（init が1回で済む）
- プロジェクトごとにバージョン指定可能

**選択肢:**
- A) 使っている言語のツールだけ残す（個別管理維持）
- B) mise に統合する（シンプル）
- C) 全部消す（Docker 等で管理するなら不要）

**実際に使っているもの:**
- [ ] rbenv
- [x] pyenv
- [ ] plenv
- [ ] goenv
- [x] nodenv / nvm

**決定:** B) mise に統合（nodenv, pyenv → mise に移行、他は削除）

---

### Q3: 追加したいツール

**検討中のモダンツール:**
| ツール | 用途 | 入れる？ |
|--------|------|---------|
| `fzf` | fuzzy finder（peco 代替）| **Yes** |
| `zsh-autosuggestions` | 入力補完サジェスト | **Yes** |
| `bat` | cat の代替、シンタックスハイライト | **Yes** |
| `eza` | ls の代替、アイコン表示 | **Yes** |
| `fd` | find の代替、高速 | No |
| `ripgrep` | grep の代替、高速 | **Yes** |
| `jq` | JSON 処理 | **Yes** |
| `starship` | プロンプト | **Yes** |
| `lazygit` | Git TUI | No |
| `zoxide` | cd の代替、学習型 | **Yes** |
| `mise` | バージョン管理統合 | **Yes**

---

## 5. 決定事項まとめ

### フェーズ 1（今すぐ）
1. [x] GNU Stow 導入を決定
2. [x] peco → fzf 移行を決定
3. [x] Vim は最小限に（NeoBundle 削除）
4. [x] zprezto 削除、素の .zshrc で管理
5. [x] mise に統合（nodenv, pyenv → mise）
6. [ ] ディレクトリ構成を stow 向けに再編成
7. [ ] .zshrc 刷新（バグ修正 + fzf + zsh-autosuggestions + mise）

### フェーズ 2（近いうち）
1. [ ] Brewfile 更新（新ツール追加、不要なもの削除）
2. [ ] エイリアス設定（bat, eza, ripgrep 等）

### フェーズ 3（時間があれば）
1. [ ] README.md 充実
2. [ ] macOS / Linux 分岐の整理

---

## 6. メモ・議論ログ

### 2026-02-04
- macOS + Linux 両対応、複数マシンで共有する前提
- **stow 導入決定**: dotfiles の更新反映を簡単にしたい
- **Vim は最小限**: ほとんど使わなくなったので NeoBundle 削除、最小限の .vimrc に
- **peco → fzf 移行**: モダンな fuzzy finder に統一
- **zprezto 削除決定**: 素の .zshrc + fzf + zsh-autosuggestions で管理
- **モダン CLI ツール導入決定**: bat, eza, ripgrep, zsh-autosuggestions

**決定追加:**
- **mise に統合**: nodenv, pyenv → mise に移行。rbenv, plenv, goenv は削除
- **追加ツール確定**: jq, starship, zoxide を追加。fd, lazygit は不要
