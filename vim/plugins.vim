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
Plugin 'tpope/vim-fugitive'
Plugin 'mhinz/vim-signify'

"" Quick comment toggling
Plugin 'tpope/vim-commentary'

" Multicursor
Plugin 'terryma/vim-multiple-cursors'

" Ident Line
Plugin 'Yggdroot/indentLine'

" Additional syntaxes and markup/programming languages
Plugin 'sheerun/vim-polyglot'

" Insert or delete brackets, parens, quotes in pair.
Plugin 'jiangmiao/auto-pairs'

" highlight trailing whitespace
Plugin 'bronson/vim-trailing-whitespace'

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

" colorize surroundings
Plugin 'kien/rainbow_parentheses.vim'

" underline word matches
Plugin 'itchyny/vim-cursorword'

" highlight tag
Plugin 'valloric/matchtagalways'

" complete html tags
Plugin 'alvan/vim-closetag'

" run test from vim
Plugin 'vim-test/vim-test'

" search and move faster
Plugin 'easymotion/vim-easymotion'

" Repeat vim actions
Plugin 'tpope/vim-repeat'

" editor config
Plugin 'editorconfig/editorconfig-vim'

" console log utils
Plugin 'glippi/lognroll-vim'

" markdown
Plugin 'instant-markdown/vim-instant-markdown'

" themes
Plugin 'mhartington/oceanic-next'

Plugin 'jpo/vim-railscasts-theme'

Plugin 'w0ng/vim-hybrid'

Plugin 'sonph/onehalf', { 'rtp': 'vim'  }

Plugin 'kaicataldo/material.vim', { 'branch': 'main' }

call vundle#end()            " required
