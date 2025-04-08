" leader key to space
let mapleader=" "

nnoremap<C-s> <ESC>:w<CR>
inoremap<C-s> <ESC>:w<CR>
vnoremap<C-s> <ESC>:w!<CR>

" remap splitting windows
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" NERDTree
map <leader>e :NERDTreeToggle %<CR>

" Move lines
" Normal Mode
nnoremap <leader>k :m .-2<CR>==
nnoremap <leader>j :m .+1<CR>==
" Insert Mode
inoremap <leader>k <Esc>:m .-2<CR>==gi
inoremap <leader>j <Esc>:m .+1<CR>==gi
" Visual Mode
vnoremap <leader>k :m '<-2<CR>gv=gv
vnoremap <leader>j :m '>+1<CR>gv=gv

" turn off search highlights
nnoremap <leader>h :nohlsearch<CR>

" Reload Vim config
nnoremap <Leader>r :so ~/.vimrc<CR>

" Tabs
nnoremap <leader>tt :tabprevious<CR>
nnoremap <leader>t :tabnext<CR>
inoremap <leader>t <Esc>:tabprevious<CR>
inoremap <leader>t <Esc>:tabnext<CR>
nnoremap <C-t> :tabnew<CR>
inoremap <C-t> :tabnew<CR>

" resize pane
nnoremap <silent> <Leader>+ :exe "vertical resize " . (winheight(0) * 3/2)<CR>
nnoremap <silent> <Leader>- :exe "vertical resize " . (winheight(0) * 2/3)<CR>

" copy
inoremap <C-v> <ESC>"+pa
vnoremap y "+y
vnoremap <C-x> "+d

" copy filename and filepath
nmap <leader>cn :let @*=expand("%")<CR>
nmap <leader>cp :let @*=expand("%:p")<CR>

" close
nnoremap<leader>w <ESC>:w<CR>
vnoremap<leader>w <ESC>:w<CR>

nnoremap<leader>q <ESC>:q<CR>
inoremap<leader>q <ESC>:q<CR>
vnoremap<leader>q <ESC>:q<CR>
nnoremap<C-q> <ESC>:qa!<CR>
inoremap<C-q> <ESC>:qa!<CR>
vnoremap<C-q> <ESC>:qa!<CR>

" fzf
nnoremap <leader>ff :GFiles <CR>
nnoremap <leader>fF :Files<CR>
nnoremap <leader>fr :RG<CR>
map <Leader>ag :Ag<CR>

" buffers
map <Leader>ob :Buffers<cr>

" Signify
nnoremap ghu :SignifyHunkUndo<CR>
nnoremap ghd :SignifyHunkDiff<CR>
nmap <leader>n <plug>(signify-next-hunk)
nmap <leader>p <plug>(signify-prev-hunk)
omap ghv <plug>(signify-motion-inner-pending)
xmap ghv <plug>(signify-motion-inner-visual)
