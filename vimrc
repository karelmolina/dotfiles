" Instalar primero
" vundle vim
" pathogen
set encoding=UTF-8
set nocompatible              " be iMproved, required
filetype off                  " required
syntax enable
set shell=bash\ -l
syntax on
set clipboard=unnamedplus
set background=dark " Setting dark mode"
set shortmess-=S
set number
set t_Co=256
set updatetime=100

" leader key to space
let mapleader=" "

" Show leader key
set showcmd

set noswapfile " No swap file
set nobackup
set nowritebackup
set pastetoggle=<F10>

filetype plugin indent on
filetype on
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

nnoremap<C-s> <Esc>:w<CR>
inoremap<C-s> <Esc>:w<CR>

" max text length
au BufRead,BufNewFile *.rb setlocal textwidth=120

" get rid of trailing whitespace on :w
autocmd BufWritePre * %s/\s\+$//e

" remap splitting windows
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Map Alt key
" en la terminal ALT+J era igual al ^[j
" con este mapeo se cambia a \ej
execute "set <M-j>=\ej"
nnoremap <M-j> j
execute "set <M-k>=\ek"
nnoremap <M-k> k

" Move lines
inoremap <M-k> <Esc>:m .-2<CR>==gi
vnoremap <M-k> :m '<-2<CR>gv=gv
nnoremap <M-k> :m .-2<CR>==
nnoremap <M-j> :m .+1<CR>==
inoremap <M-j> <Esc>:m .+1<CR>==gi
vnoremap <M-j> :m '>+1<CR>gv=gv


" colorscheme jellybeans
let g:gruvbox_contrast_dark = 'hard'

" nnoremap <C-a> <C-w>
" Pathogen
set nocp
call pathogen#infect()

" set the runtime path to include Vundle and initialize

set rtp+=~/.vim/bundle/Vundle.vim

call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" Files stucture tree
Plugin 'preservim/nerdtree'

" Git
Plugin 'airblade/vim-gitgutter'
Plugin 'Xuyuanp/nerdtree-git-plugin'

" Ruby
Plugin 'tpope/vim-rake'
Plugin 'tpope/vim-bundler'
Plugin 'tpope/vim-rvm'
Plugin 'ngmy/vim-rubocop'
Plugin 'vim-ruby/vim-ruby'
Plugin 'tpope/vim-rails'
Plugin 'tpope/vim-endwise'
" go to definition ruby
Plugin 'xmisao/rubyjump.vim'

" vim icons
"Plugin 'ryanoasis/vim-devicons'

" vim Theme
Plugin 'morhetz/gruvbox'

"" Quick comment toggling
Plugin 'tpope/vim-commentary'
noremap \c :Commentary<CR
autocmd FileType ruby setlocal commentstring=#\ %s

" Surround
Plugin 'tpope/vim-surround'

" Multicursor
Plugin 'terryma/vim-multiple-cursors'

" Ident Line
Plugin 'Yggdroot/indentLine'

" Syntax checker
Plugin 'scrooloose/syntastic'

" Additional syntaxes and markup/programming languages
Plugin 'sheerun/vim-polyglot'

" provides automatic closing of quotes, parenthesis, brackets, etc..
Plugin 'Raimondi/delimitMate'

" ident on paste in certain extention files
Plugin 'sickill/vim-pasta'

" transform one line statement into a multiline statement
Plugin 'AndrewRadev/splitjoin.vim'

" call :ChangeHashSyntax to use hash syntax >ruby 1.9
Plugin 'ck3g/vim-change-hash-syntax'

" highlight trailing whitespace
Plugin 'bronson/vim-trailing-whitespace'

" Mark lines for quick access
Plugin 'kshenoy/vim-signature'

" Configure tab labels within Terminal Vim with a very succinct output.
Plugin 'mkitt/tabline.vim'

" Go to line from vim file:n
Plugin 'bogado/file-line'

" Match tags
Plugin 'gregsexton/MatchTag'

" Vim + tmux
Plugin 'benmills/vimux'

" status/tabline for vim
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'

" Fzf
Plugin 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plugin 'junegunn/fzf.vim'

" deoplete
" Plugin 'Shougo/deoplete.nvim'
" Plugin 'roxma/nvim-yarp'
" Plugin 'roxma/vim-hug-neovim-rpc'

" Coc Vim
" to use coc.vim install nodejs and yarn
Plugin 'neoclide/coc.nvim', {'branch': 'release'}

" emmet -- javascript
Plugin 'mattn/emmet-vim'

call vundle#end()            " required
filetype plugin indent on    " required

" NerdTree
let NERDTreeShowHidden=1
let g:NERDTreeIndicatorMapCustom = {
    \ "Modified"  : "✹",
    \ "Staged"    : "✚",
    \ "Untracked" : "✭",
    \ "Renamed"   : "➜",
    \ "Unmerged"  : "═",
    \ "Deleted"   : "✖",
    \ "Dirty"     : "✗",
    \ "Clean"     : "✔︎",
    \ 'Ignored'   : '☒',
    \ "Unknown"   : "?"
    \}
map <C-b> :NERDTreeToggle %<CR>
let g:NERDTreeDirArrowExpandable = '->'
let g:NERDTreeDirArrowCollapsible = '➘'
nnoremap <C-S-Tab> :tabprevious<CR>
nnoremap <C-Tab> :tabnext<CR>
nnoremap <C-t> :tabnew<CR>


set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:suntastic_ruby_checkers= ['rubocop']
"let g:syntastic_ignore_files = ['([a-zA-Z0-9\s_\\.\-\(\):])+(.feature)$']
"let g:syntastic_ignore_files = ['\m^/features/step_definitions/', '\m\c\.rb$']
"let g:syntastic_ignore_files = ['\m^/features/step_definitions2/', '\m\c\.rb$']

" Multicursor config keybinding
let g:multi_cursor_use_default_mapping=0

" Default mapping
let g:multi_cursor_start_word_key      = '<C-d>'
let g:multi_cursor_select_all_word_key = '<A-d>'
let g:multi_cursor_start_key           = 'g<C-n>'
let g:multi_cursor_select_all_key      = 'g<A-n>'
let g:multi_cursor_next_key            = '<C-d>'
let g:multi_cursor_prev_key            = '<C-S-d>'
let g:multi_cursor_skip_key            = '<C-x>'
let g:multi_cursor_quit_key            = '<Esc>'

" SCHEME
colorscheme gruvbox
" colorscheme atom-dark-256


" vim-ruby
let g:ruby_indent_access_modifier_style = 'normal'
let g:ruby_indent_assignment_style = 'variable'
let g:ruby_indent_block_style = 'do'

let g:pasta_enabled_filetypes = ['ruby', 'javascript', 'css', 'sh', 'erb']

" gitgutter
let g:gitgutter_highlight_linenrs = 1
"nmap ]h <Plug>(GitGutterNextHunk)
"nmap [h <Plug>(GitGutterPrevHunk)
nmap <leader>n <Plug>(GitGutterNextHunk)
nmap <leader>p <Plug>(GitGutterPrevHunk)
let g:gitgutter_override_sign_column_highlight = 0
let g:gitgutter_sign_added = '++'
let g:gitgutter_sign_modified = '~~'
let g:gitgutter_sign_removed = '--'
nmap ghs <Plug>(GitGutterStageHunk)
nmap ghu <Plug>(GitGutterUndoHunk)

" Vimux
let g:VimuxHeight = "30"
let g:VimuxOrientation = "v"
let g:VimuxUseNearest = 0
map <leader>vp :VimuxPromptCommand<CR>

" Ident line config
" LeadingSpaceEnable <-- to enabled it
" let g:indentLine_color_term = 239

" vim airliniie
"let g:airline#extensions#tabline#enabled = 1
let g:airline_theme='minimalist'
let g:airline#extensions#tabline#formatter = 'unique_tail'


" rubocop
" especificar la ruta del yml: let g:vimrubocop_config

" Fzf
nnoremap <C-p> :FZF <CR>

" Ruby Jump
" Se tiene que especificar la ruta de ruby y la el rubylibs
" para poder usar este plugin
" Si se genera un error al iniciar vim es porque no esta
" configurado correctamente esta ruta
let $RUBYHOME=$HOME."/.rvm/rubies/default"
set rubydll=$HOME/.rvm/rubies/default/lib/libruby.so.2.6
" buscar metodo dentro de las ventanas abiertas
nmap <leader>sd <Plug>(rubyjump)
nmap <leader>sl <Plug>(rubyjump_local)
" mover al metodo previo o siguiente
nmap <silent> <C-n> <Plug>(rubyjump_next_forward)
nmap <silent> <C-m> <Plug>(rubyjump_prev_backward)

" Coc Vim
" use <tab> for trigger completion and navigate to the next complete item
function! s:check_back_space() abort
  let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
    endfunction

    inoremap <silent><expr> <Tab>
          \ pumvisible() ? "\<C-n>" :
          \ <SID>check_back_space() ? "\<Tab>" :
          \ coc#refresh()

" use <c-space>for trigger completion
inoremap <silent><expr> <c-space> coc#refresh()

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)


" Emmet

" try complete html tag
" inoremap <buffer> > ></<C-x><C-o><C-y><C-o>%<CR><C-o>O
