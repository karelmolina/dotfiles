" leader key to space
let mapleader=" "

" Save
nnoremap<C-s> <ESC>:w<CR>
inoremap<C-s> <ESC>:w<CR>
vnoremap<C-s> <ESC>:w!<CR>

" Window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" ============================================================================
" NETRW (file explorer - replaces NERDTree)
" ============================================================================
nmap <leader>e :Lexplore<CR>
nmap <leader>E :Lexplore %:p:h<CR>

" In netrw: press 't' to open in new tab, 'v' for vertical split, 'o' for horizontal
" Use '-' to go up a directory, <CR> to enter directory or open file

" ============================================================================
" VIM-SNEAK (fast motion with s{char}{char})
" ============================================================================
" Default: s{char}{char} to sneak forward, S{char}{char} to sneak backward
" ; to repeat forward, , to repeat backward
" f/F/t/T extended to work across lines (1 character sneak)
nmap f <Plug>Sneak_f
nmap F <Plug>Sneak_F
nmap t <Plug>Sneak_t
nmap T <Plug>Sneak_T

" Move lines
nnoremap <leader>k :m .-2<CR>==
nnoremap <leader>j :m .+1<CR>==
inoremap <leader>k <Esc>:m .-2<CR>==gi
inoremap <leader>j <Esc>:m .+1<CR>==gi
vnoremap <leader>k :m '<-2<CR>gv=gv
vnoremap <leader>j :m '>+1<CR>gv=gv

" Clear search highlights
nnoremap <leader>h :nohlsearch<CR>

" Reload Vim config
nnoremap <Leader>r :so ~/.vimrc<CR>

" Tabs
nnoremap <leader>tt :tabprevious<CR>
nnoremap <leader>t :tabnext<CR>
inoremap <leader>tt <Esc>:tabprevious<CR>
inoremap <leader>t <Esc>:tabnext<CR>
nnoremap <C-t> :tabnew<CR>
inoremap <C-t> :tabnew<CR>

" Resize panes
nnoremap <silent> <Leader>+ :exe "vertical resize " . (winheight(0) * 3/2)<CR>
nnoremap <silent> <Leader>- :exe "vertical resize " . (winheight(0) * 2/3)<CR>

" Copy/paste
inoremap <C-v> <ESC>"+pa
vnoremap y "+y
vnoremap <C-x> "+d

" Copy filename and filepath
nmap <leader>cn :let @*=expand("%")<CR>
nmap <leader>cp :let @*=expand("%:p")<CR>

" Close/quit
nnoremap<leader>w <ESC>:w<CR>
vnoremap<leader>w <ESC>:w<CR>
nnoremap<leader>q <ESC>:q<CR>
inoremap<leader>q <ESC>:q<CR>
vnoremap<leader>q <ESC>:q<CR>
nnoremap<C-q> <ESC>:qa!<CR>
inoremap<C-q> <ESC>:qa!<CR>
vnoremap<C-q> <ESC>:qa!<CR>

" ============================================================================
" VIM-FUGITIVE (Git)
" ============================================================================
nnoremap <leader>gs :Gstatus<CR>
nnoremap <leader>gd :Gdiff<CR>
nnoremap <leader>gb :Gblame<CR>
nnoremap <leader>gl :Glog<CR>
nnoremap <leader>gc :Gcommit<CR>
nnoremap <leader>gp :Gpush<CR>
