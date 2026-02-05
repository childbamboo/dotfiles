# ============================================
# 環境変数
# ============================================
export LANG=ja_JP.UTF-8
export EDITOR=vim

# ~/.local/bin をパスに追加（Claude CLI 等）
if [[ -d "$HOME/.local/bin" ]]; then
    export PATH="$HOME/.local/bin:$PATH"
fi

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
zstyle ':completion:*' menu select
zstyle ':completion:*' ignore-parents parent pwd ..

# zsh-completions
if type brew &>/dev/null; then
    FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
    FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
fi

# zsh-autosuggestions
if type brew &>/dev/null && [[ -f $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
    # macOS (Homebrew)
    source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
elif [[ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
    # Linux (apt)
    source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
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
setopt no_flow_control
setopt print_eight_bit
setopt interactive_comments
setopt extended_glob

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

# グローバルエイリアス
alias -g L='| less'
alias -g G='| grep'

# クリップボード
if which pbcopy >/dev/null 2>&1; then
    alias -g C='| pbcopy'
elif which xsel >/dev/null 2>&1; then
    alias -g C='| xsel --input --clipboard'
fi

# ============================================
# fzf
# ============================================
if command -v fzf &> /dev/null; then
    # fzf 0.48+ supports --zsh option
    if fzf --zsh &>/dev/null; then
        source <(fzf --zsh)
    # Linux (apt): use bundled scripts
    elif [[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]]; then
        source /usr/share/doc/fzf/examples/key-bindings.zsh
        [[ -f /usr/share/doc/fzf/examples/completion.zsh ]] && source /usr/share/doc/fzf/examples/completion.zsh
    fi
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
