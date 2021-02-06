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

" Ruby
Plugin 'ngmy/vim-rubocop'
Plugin 'vim-ruby/vim-ruby'
Plugin 'tpope/vim-rails'
Plugin 'tpope/vim-endwise'

" vim Theme
Plugin 'morhetz/gruvbox'

"" Quick comment toggling
Plugin 'tpope/vim-commentary'

" Multicursor
Plugin 'terryma/vim-multiple-cursors'

" Ident Line
Plugin 'Yggdroot/indentLine'

" Additional syntaxes and markup/programming languages
Plugin 'sheerun/vim-polyglot'

" provides automatic closing of quotes, parenthesis, brackets, etc..
Plugin 'Raimondi/delimitMate'

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

" status/tabline for vim
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'

" Fzf
Plugin 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plugin 'junegunn/fzf.vim'

" Coc Vim
" to use coc.vim install nodejs and yarn
Plugin 'neoclide/coc.nvim', {'branch': 'release'}

" emmet -- javascript
Plugin 'mattn/emmet-vim'

" surround
Plugin 'tpope/vim-surround'

" themes
Plugin 'mhartington/oceanic-next'

Plugin 'jpo/vim-railscasts-theme'

Plugin 'w0ng/vim-hybrid'

Plugin 'kien/rainbow_parentheses.vim'

Plugin 'valloric/matchtagalways'

Plugin 'itchyny/vim-cursorword'

call vundle#end()            " required
