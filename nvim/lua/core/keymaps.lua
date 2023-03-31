vim.g.mapleader = " "

local remap = vim.keymap

-- common
remap.set("i", "<C-s>", "<ESC>:w<CR>")
remap.set("n", "<C-s>", "<ESC>:w<CR>")
remap.set("v", "<C-s>", "<ESC>:w<CR>")

remap.set("n", "<C-q>", "<ESC>:qa!<CR>")
remap.set("v", "<C-q>", "<ESC>:qa!<CR>")

remap.set("n", "<c-w>", "<ESC>:q!<CR>")
remap.set("v", "<c-w>", "<ESC>:q!<CR>")

-- window movement
remap.set("n", "<C-h>", "<C-w>h")
remap.set("n", "<C-j>", "<C-w>j")
remap.set("n", "<C-k>", "<C-w>k")
remap.set("n", "<C-l>", "<C-w>l")

-- numbers increase - decrease
remap.set("n", "<leader>+", "<C-a>")
remap.set("n", "<leader>-", "<C-x>")

--buffer
remap.set("n", "<leader>b", ":Buffers<cr>")

--move lines
remap.set("n", "<leader>k", ":m .-2<CR>==")
remap.set("i", "<leader>k", ":m .-2<CR>==gi")
remap.set("v", "<leader>k", ":m '<-2<CR>==gv")

remap.set("n", "<leader>j", ":m .+1<CR>==")
remap.set("i", "<leader>j", ":m .+1<CR>==")
remap.set("v", "<leader>j", ":m '>+1<CR>==")

--nvim-tree
remap.set("n", "<c-b>", ":NvimTreeFindFileToggle<CR>")

--telescope
remap.set("n", "<c-p>", "<cmd>Telescope find_files<cr>") -- find files within current working directory, respects .gitignore
remap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>") -- find string in current working directory as you type
remap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>") -- find string under cursor in current working directory
remap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>") -- list open buffers in current neovim instance
remap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>") -- list available help tags

-- telescope git commands
remap.set("n", "<leader>gc", "<cmd>Telescope git_commits<cr>") -- list all git commits (use <cr> to checkout) ["gc" for git commits]
remap.set("n", "<leader>gfc", "<cmd>Telescope git_bcommits<cr>") -- list git commits for current file/buffer (use <cr> to checkout) ["gfc" for git file commits]
remap.set("n", "<leader>gb", "<cmd>Telescope git_branches<cr>") -- list git branches (use <cr> to checkout) ["gb" for git branch]
remap.set("n", "<leader>gs", "<cmd>Telescope git_status<cr>") -- list current changes per file with diff preview ["gs" for git status]
