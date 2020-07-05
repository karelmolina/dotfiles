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
Plugin 'tpope/vim-fugitive'
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

" vim Theme
Plugin 'morhetz/gruvbox'

"" Quick comment toggling
Plugin 'tpope/vim-commentary'

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

"  undotree
Plugin 'mbbill/undotree'

call vundle#end()            " required
