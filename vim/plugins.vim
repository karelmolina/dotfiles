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
Plugin 'Xuyuanp/nerdtree-git-plugin'

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

" status/tabline for vim
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'

" Fzf
Plugin 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plugin 'junegunn/fzf.vim'

" surround
Plugin 'tpope/vim-surround'

" colorize surroundings
Plugin 'kien/rainbow_parentheses.vim'

" underline word matches
Plugin 'itchyny/vim-cursorword'

" highlight tag
Plugin 'valloric/matchtagalways'

" themes
Plugin 'w0ng/vim-hybrid'
Plugin 'ghifarit53/tokyonight-vim'
Plugin 'catppuccin/vim'

" Which-key alternative
Plugin 'liuchengxu/vim-which-key'

" Floating terminal
Plugin 'voldikss/vim-floaterm'

" Colorizer for hex colors
Plugin 'chrisbra/Colorizer'

" Markdown previewer for Vim
Plugin 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install' }

" Optional for autocompletion (alternative to nvim-cmp)
Plugin 'Shougo/neocomplete.vim'

" Optional: Linting support
Plugin 'dense-analysis/ale'

call vundle#end()            " required
