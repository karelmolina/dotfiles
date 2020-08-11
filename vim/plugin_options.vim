" colorscheme jellybeans
let g:gruvbox_contrast_dark = 'hard'
" SCHEME
colorscheme gruvbox

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

" Syntastic
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_ruby_checkers= ['rubocop']
" set statusline+=%#warningmsg#
" set statusline+=%{SyntasticStatuslineFlag()}
" set statusline+=%*

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

" vim-ruby
let g:ruby_indent_access_modifier_style = 'normal'
let g:ruby_indent_assignment_style = 'variable'
let g:ruby_indent_block_style = 'do'

" vim-pasta
let g:pasta_enabled_filetypes = ['ruby', 'javascript', 'css', 'sh', 'erb']

" gitgutter
let g:gitgutter_highlight_linenrs = 1
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

" vim airliniie
let g:airline_theme= 'base16'
let g:airline#extensions#tabline#formatter = 'unique_tail'
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

" powerline symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = '☰'
let g:airline_symbols.maxlinenr = ''
let g:airline_symbols.dirty='⚡'

let g:airline#extensions#branch#enabled = 1
function! AirlineInit()
  let g:airline_section_a = airline#section#create(['mode','  ', 'branch'])
  let g:airline_section_b = airline#section#create_left(['hunks', '%f'])
  let g:airline_section_c = airline#section#create(['filetype'])
  let g:airline_section_x = airline#section#create(['%P'])
  let g:airline_section_y = airline#section#create(['%B'])
  let g:airline_section_z = airline#section#create_right(['%l','%c'])
endfunction
autocmd VimEnter * call AirlineInit()

"  Vim commentary
noremap \c :Commentary<CR
autocmd FileType ruby setlocal commentstring=#\ %s

" rubocop
nmap <Leader>ru :RuboCop<CR>
" especificar la ruta del yml:
" let g:vimrubocop_config = 'path'
"let g:vimrubocop_keymap = 0

" Fzf

command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(<q-args>, fzf#vim#with_preview({'options': ['--layout=reverse', '--info=inline']}), <bang>0)

function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction

command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)

nnoremap <C-p> :Files <CR>
execute "set <M-f>=\ef"
nnoremap <M-f> f
nnoremap <M-f> :RG<CR>

" You can set up fzf window using a Vim command (Neovim or latest Vim 8 required)
let g:fzf_layout = { 'window': 'enew' }
let g:fzf_layout = { 'window': '-tabnew' }
let g:fzf_layout = { 'window': '10new' }

" Enable per-command history
" - History files will be stored in the specified directory
" - When set, CTRL-N and CTRL-P will be bound to 'next-history' and
"   'previous-history' instead of 'down' and 'up'.
let g:fzf_history_dir = '~/.local/share/fzf-history'

" Ruby Jump
" Se tiene que especificar la ruta de ruby y la el rubylibs
" para poder usar este plugin
" Si se genera un error al iniciar vim es porque no esta
" configurado correctamente esta ruta
let $RUBYHOME="$HOME/.rvm/rubies/default"
set rubydll=$HOME/.rvm/rubies/default/lib/libruby.so
" buscar metodo dentro de las ventanas abiertas
nmap <leader>sd <Plug>(rubyjump)
nmap <leader>sl <Plug>(rubyjump_local)
" mover al metodo previo o siguiente
nmap <silent> <C-n> <Plug>(rubyjump_next_forward)
nmap <silent> <C-m> <Plug>(rubyjump_prev_backward)

" Coc Vim
" use <tab> for trigger completion and navigate to the next complete item
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" use <c-space>for trigger completion
inoremap <silent> <NUL> coc#refresh()

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

let g:coc_global_extensions = [
  \ 'coc-snippets',
  \ 'coc-pairs',
  \ 'coc-tsserver',
  \ 'coc-json',
  \ 'coc-css',
  \ ]

" Emmet

" try complete html tag
" inoremap <buffer> > ></<C-x><C-o><C-y><C-o>%<CR><C-o>O

"  UndoTree
nnoremap <F5> :UndotreeToggle<cr>
if has("persistent_undo")
    set undodir=$HOME."/.vim/.undodir"
    set undofile
endif

" vim workspace
let g:workspace_autosave = 0
let g:workspace_session_directory = $HOME . '/.vim/sessions/'
nnoremap <leader>s :ToggleWorkspace<CR>
