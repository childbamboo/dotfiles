" neobundle settings {{{
if has('vim_starting')
  set nocompatible
  " neobundle をインストールしていない場合は自動インストール
  if !isdirectory(expand("~/.vim/bundle/neobundle.vim/"))
    echo "install neobundle..."
    " vim からコマンド呼び出しているだけ neobundle.vim のクローン
    :call system("git clone git://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim")
  endif
  " runtimepath の追加は必須
  set runtimepath+=~/.vim/bundle/neobundle.vim/
endif
call neobundle#begin(expand('~/.vim/bundle'))
let g:neobundle_default_git_protocol='https'

" neobundle#begin - neobundle#end の間に導入するプラグインを記載します。 
NeoBundleFetch 'Shougo/neobundle.vim'

NeoBundle 'nanotech/jellybeans.vim'

" filer
NeoBundle 'Shougo/unite.vim'
NeoBundle 'scrooloose/nerdtree'
NeoBundle 'ctrlpvim/ctrlp.vim'

" code check
NeoBundle 'kchmck/vim-coffee-script'
NeoBundle 'tpope/vim-endwise.git'

" rails
NeoBundle 'tpope/vim-rails'
NeoBundle 'ujihisa/unite-rake'
NeoBundle 'basyura/unite-rails'
NeoBundle 'ruby-matchit'

" vuejs
NeoBundle 'posva/vim-vue'

" typescript
NeoBundle 'leafgarland/typescript-vim'

" slim
NeoBundle 'slim-template/vim-slim'

" iceberg
NeoBundle 'cocopon/iceberg.vim'

" vimrc に記述されたプラグインでインストールされていないものがないかチェックする
NeoBundleCheck
call neobundle#end()

filetype plugin indent on
" どうせだから jellybeans カラースキーマを使ってみましょう
syntax on

set ts=2 sw=2
set softtabstop=2
set expandtab

set encoding=utf-8
set fileencodings=utf-8,sjis,euc-jp,latin1
set ignorecase
set smartcase
set nohlsearch
set incsearch
set wrap

set laststatus=2
set statusline=%<%f\ %m%r%h%w
set statusline+=%{'['.(&fenc!=''?&fenc:&enc).']['.&fileformat.']'}
set statusline+=%=%l/%L\ %c%V%8P

set foldmethod=syntax
let perl_fold=1
set foldlevel=100 "Don't autofold anything

" coffee
" vimにcoffeeファイルタイプを認識させる
au BufRead,BufNewFile,BufReadPre *.coffee   set filetype=coffee

" インデント設定
autocmd FileType coffee    setlocal sw=2 sts=2 ts=2 et
" オートコンパイル
  "保存と同時にコンパイルする
autocmd BufWritePost *.coffee silent make! 

" clipboard
set clipboard+=unnamed

let g:unite_enable_start_insert = 1
let g:unite_enable_split_vertically = 0
let g:unite_winwidth = 40
nnoremap <silent> ,ra :<C-u>Unite rails/app<CR>
nnoremap <silent> ,rc :<C-u>Unite rails/controller<CR>
nnoremap <silent> ,rm :<C-u>Unite rails/model<CR>
nnoremap <silent> ,rv :<C-u>Unite rails/view<CR>
nnoremap <silent> ,rh :<C-u>Unite rails/helper<CR>
nnoremap <silent> ,rs :<C-u>Unite rails/stylesheet<CR>
nnoremap <silent> ,rj :<C-u>Unite rails/javascript<CR>
nnoremap <silent> ,rr :<C-u>Unite rails/route<CR>
nnoremap <silent> ,rg :<C-u>Unite rails/gemfile<CR>
nnoremap <silent> ,rt :<C-u>Unite rails/spec<CR>

" escが遠いので代用する。
noremap <C-j> <esc>
noremap! <C-j> <esc>
