local opt = vim.opt

--line numers
opt.shell = "zsh -l"
opt.number = true

--indent
opt.autoindent = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true

--line wrapping
opt.wrap = false

--search
opt.ignorecase = true
opt.smartcase = true

-- cusor
opt.cursorline = true

--appearance
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"

--backspace
opt.backspace = "indent,eol,start"

-- clipboard
opt.clipboard:append("unnamedplus")

--split
opt.splitright = true
opt.splitbelow = true

opt.iskeyword:append("-")

-- general
vim.cmd [[ autocmd BufWritePre * %s/\\s\+$//e ]]
vim.cmd [[ set noswapfile ]]
