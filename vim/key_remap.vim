" leader key to space
let mapleader=","

nnoremap<C-s> <ESC>:w<CR>
inoremap<C-s> <ESC>:w<CR>
vnoremap<C-s> <ESC>:w!<CR>

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
" Normal Mode
nnoremap <M-k> :m .-2<CR>==
nnoremap <M-j> :m .+1<CR>==
" Insert Mode
inoremap <M-k> <Esc>:m .-2<CR>==gi
inoremap <M-j> <Esc>:m .+1<CR>==gi
" Visual Mode
vnoremap <M-k> :m '<-2<CR>gv=gv
vnoremap <M-j> :m '>+1<CR>gv=gv

" turn off search highlights
nnoremap <leader> h :nohlsearch<CR>

" Reload Vim config
nnoremap <Leader>r :so ~/.vimrc<CR>

" Tabs
nnoremap <leader>tt :tabprevious<CR>
nnoremap <leader>t :tabnext<CR>
inoremap <leader>t <Esc>:tabprevious<CR>
inoremap <leader>t <Esc>:tabnext<CR>
nnoremap <C-t> :tabnew<CR>
inoremap <C-t> :tabnew<CR>

