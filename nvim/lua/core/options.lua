local opt = vim.opt
local g = vim.g

-- highlight URLs by default
g.highlighturl_enabled = true

-- disable notifications when toggling UI elements
g.ui_notifications_enabled = true

-- visual-multi
g.VM_maps["Add Cusor Up"] = "<C-S-up>"
g.VM_maps["Add Cusor Down"] = "<C-S-down>"

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

-- Decrease update time
opt.updatetime = 250
opt.timeout = true
opt.timeoutlen = 300

-- general
vim.cmd([[ set noswapfile ]])

-- trim whitespaces
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	pattern = { "*" },
	command = [[%s/\s\+$//e]],
})
