" Minimalist Vim Configuration - 8 Essential Plugins
" Using Vundle for plugin management

set nocompatible
set rtp+=~/.vim/bundle/Vundle.vim

call vundle#begin()

" Vundle manages itself
Plugin 'VundleVim/Vundle.vim'

" 1. Syntax highlighting for all languages
Plugin 'sheerun/vim-polyglot'

" 2. Comment toggling (gc)
Plugin 'tpope/vim-commentary'

" 3. Bracket/parentheses manipulation (cs, ds, ys)
Plugin 'tpope/vim-surround'

" 4. Git integration (:Gstatus, :Gdiff, etc.)
Plugin 'tpope/vim-fugitive'

" 5. Quick navigation ([q, ]q, [b, ]b, etc.)
Plugin 'tpope/vim-unimpaired'

" 6. Dot command support for plugins
Plugin 'tpope/vim-repeat'

" 7. Fast motion (s{char}{char})
Plugin 'justinmk/vim-sneak'

call vundle#end()
