" Minimal vimrc
set nocompatible
syntax on
filetype plugin indent on

" Encoding
set encoding=utf-8
set fileencoding=utf-8

" Indent
set ts=2 sw=2 expandtab
set softtabstop=2
set autoindent
set smartindent

" Search
set ignorecase
set smartcase
set incsearch
set hlsearch

" Display
set wrap
set number
set laststatus=2
set statusline=%<%f\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&fileformat.']'}%=%l/%L\ %c%V%8P

" Clipboard
set clipboard+=unnamed

" Misc
set backspace=indent,eol,start
set wildmenu

" Color scheme
colorscheme desert
