" ============================================================================
" 1. HABAMAX (Colorscheme - native to Vim 8.2+)
" ============================================================================
" Habamax is a modern high-contrast colorscheme built into Vim 8.2+
" No plugin needed - comes with Vim itself
set background=dark
try
  colorscheme habamax
catch
  " Fallback for older Vim versions
  colorscheme default
endtry

" ============================================================================
" 2. VIM-POLYGLOT (Syntax highlighting - zero config needed)
" ============================================================================
" Polyglot works out of the box, but we can tweak some settings:
let g:polyglot_disabled = ['autoindent']  " Use Vim's native autoindent

" ============================================================================
" 3. VIM-COMMENTARY (Comment toggling)
" ============================================================================
" gcc - comment line
" gc{motion} - comment motion (e.g. gcip for paragraph)
" gc in visual mode
" Additional filetype comment strings:
autocmd FileType ruby setlocal commentstring=#\ %s
autocmd FileType javascript setlocal commentstring=//\ %s
autocmd FileType typescript setlocal commentstring=//\ %s
autocmd FileType html setlocal commentstring=<!--\ %s\ -->
autocmd FileType css setlocal commentstring=/*\ %s\ */
autocmd FileType scss setlocal commentstring=//\ %s
autocmd FileType yaml setlocal commentstring=#\ %s
autocmd FileType dockerfile setlocal commentstring=#\ %s
autocmd FileType bash setlocal commentstring=#\ %s
autocmd FileType zsh setlocal commentstring=#\ %s
autocmd FileType vim setlocal commentstring=\"\ %s
autocmd FileType lua setlocal commentstring=--\ %s

" ============================================================================
" 4. VIM-SURROUND (Bracket manipulation)
" ============================================================================
" cs - change surrounding (cs"' changes " to ')
" ds - delete surrounding (ds" removes surrounding ")
" ys - add surrounding (ysiw" adds " around word)
" yS - add surrounding + indent (ySiw{)
" S - surround in visual mode
" Example: "Hello world" -> cs"' -> 'Hello world'
" Example: 'Hello' -> ds' -> Hello
" Example: Hello -> ysiw" -> "Hello"

" ============================================================================
" 5. VIM-FUGITIVE (Git integration)
" ============================================================================
" Keybindings are in key_remap.vim
" Commands:
" :Gstatus - git status (use - to add, p to patch, cc to commit)
" :Gdiff - git diff current file
" :Gblame - blame annotation
" :Glog - git log (open commits)
" :Gcommit - git commit
" :Gpush - git push
" :Gpull - git pull
" :Gwrite - git add current file
" :Gread - checkout file (revert changes)
" :Gremove - git rm
" :Gmove - git mv
set diffopt+=vertical  " Always vertical diff

" ============================================================================
" 6. VIM-UNIMPAIRED (Quick navigation)
" ============================================================================
" [q / ]q - previous/next quickfix
" [l / ]l - previous/next location list
" [b / ]b - previous/next buffer
" [t / ]t - previous/next tag
" [f / ]f - previous/next file in directory
" [<Space> / ]<Space> - add blank line above/below
" [e / ]e - exchange line with above/below
" [x / ]x - encode/decode XML
" [u / ]u - encode/decode URL
" yo - toggle options (yoh for hlsearch, yow for wrap, etc.)

" ============================================================================
" 7. VIM-REPEAT (Dot command support)
" ============================================================================
" Makes . (dot) repeat work with surround, commentary, etc.
" No configuration needed - just works!

" ============================================================================
" 8. VIM-SNEAK (Fast motion)
" ============================================================================
" Default: s{char}{char} to sneak forward
" S{char}{char} to sneak backward
" ; to repeat forward
" , to repeat backward
" After s/S, use s again to go to next match
let g:sneak#label = 1           " Enable "EasyMotion" style labels
let g:sneak#use_ic_scs = 1      " Use ignorecase + smartcase
let g:sneak#s_next = 1          " Press s again to go to next match
let g:sneak#f_reset = 1         " f/F/t/T are enhanced by sneak
let g:sneak#t_reset = 1
