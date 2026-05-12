" encoding
scriptencoding utf-8
set encoding=utf-8

" basic behavior
set nocompatible
syntax on
set shell=zsh\ -l
set clipboard=unnamedplus
set shortmess-=S
set number
set updatetime=100
set nowrap
set background=dark
set hlsearch
set incsearch
set ignorecase
set smartcase
set wildmenu
set wildmode=longest:full,full
set lazyredraw
set cursorline
set showcmd
set noswapfile
set nobackup
set nowritebackup
set pastetoggle=<F10>
set mouse=a
set splitbelow
set splitright
set textwidth=120
set showmode

" GUI colors
if has('termguicolors')
  set termguicolors
endif

" filetype and indentation
filetype off
filetype plugin indent on

" Ruby indentation
autocmd FileType ruby setlocal expandtab shiftwidth=2 tabstop=2

" Tabs and spacing
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4

" search for visual selection
vnoremap // y/\V<C-R>=escape(@",'/\')<CR><CR>

" trim trailing whitespace on save
autocmd BufWritePre * %s/\s\+$//e

" support for tmux keys
if &term =~ '^tmux'
    execute "set <xUp>=\e[1;*A"
    execute "set <xDown>=\e[1;*B"
    execute "set <xRight>=\e[1;*C"
    execute "set <xLeft>=\e[1;*D"
endif

" cursor shape when inside tmux
if !empty($TMUX)
    let &t_SI .= "\e[3 q"
    let &t_SR .= "\e[5 q"
    let &t_EI .= "\e[4 q"
endif

" ============================================================================
" NATIVE STATUSLINE (minimalist, no airline)
" ============================================================================
set laststatus=2
set statusline=
set statusline+=%#StatusLine#
set statusline+=\ %n\                              " buffer number
set statusline+=%{&modified?'[+]':'\ '}             " modified flag
set statusline+=%{&readonly?'[RO]':'\ '}            " readonly flag
set statusline+=%<%F\                               " full path
set statusline+=%=                                  " right align
set statusline+=%{&filetype!=''?&filetype:'none'}\  " filetype
set statusline+=%{&fileencoding!=''?&fileencoding:&encoding}\  " encoding
set statusline+=%l/%L:%c\                           " line/total:column
set statusline+=%3p%%\                              " percentage

" ============================================================================
" NETRW (built-in file explorer)
" ============================================================================
let g:netrw_banner=0              " disable banner
let g:netrw_liststyle=3           " tree view
let g:netrw_browse_split=4        " open in previous window
let g:netrw_altv=1                " open splits to the right
let g:netrw_winsize=25            " width of netrw window
let g:netrw_keepdir=0             " keep current directory sync'd
let g:netrw_localcopydircmd='cp -r'
let g:netrw_fastbrowse=0          " close netrw after opening file

" ============================================================================
" COLORS
" ============================================================================
" Habamax colorscheme is loaded via plugin_options.vim (native to Vim 8.2+)
