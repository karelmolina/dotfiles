set encoding=UTF-8
set nocompatible              " be iMproved, required
filetype off                    " required
syntax enable
set shell=bash\ -l
syntax on
set clipboard=unnamedplus
set background=dark " Setting dark mode"
set shortmess-=S
set number
set t_Co=256
set updatetime=100
set nowrap

" Do not redraw screen in the middle of a macro. Makes them complete faster.
set lazyredraw

" Show leader key
set showcmd

set noswapfile " No swap file
set nobackup
set nowritebackup
set pastetoggle=<F10>

filetype plugin indent on
filetype indent on
filetype plugin on
" set mouse to all for uset inside tmux
" scroll vim instead tmux
set mouse=a
autocmd FileType ruby setlocal expandtab shiftwidth=2 tabstop=2

" #TABS AND SPACES {{{
set expandtab " On pressing tab, insert 2 spaces
set tabstop=2 " show existing tab with 2 spaces width
set softtabstop=2
set shiftwidth=2 " when indenting with '>', use 2 spaces width
"}}}"}}

" set more natural split screen
set splitbelow
set splitright

" max text length
set textwidth=120

" get rid of trailing whitespace on :w
autocmd BufWritePre * %s/\s\+$//e

au BufRead,BufNewFile,BufReadPost *.json set syntax=json
