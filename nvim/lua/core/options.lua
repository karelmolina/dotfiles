-- general
vim.cmd([[ set noswapfile ]])

-- trim whitespaces
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	pattern = { "*" },
	command = [[%s/\s\+$//e]],
})

vim.opt.backspace:append { "nostop" } -- don't stop backspace at insert

local options = {
  opt = {
    backspace = "indent,eol,start", -- allow backspace on indent, end of line or insert mode start position
    breakindent = true, -- wrap indent to match  line start
    clipboard = "unnamedplus", -- connection to the system clipboard
    cmdheight = 0, -- hide command line unless needed
    completeopt = { "menu", "menuone", "noselect" }, -- Options for insert mode completion
    copyindent = true, -- copy the previous indentation on autoindenting
    cursorline = true, -- highlight the text line of the cursor
    expandtab = true, -- enable the use of space in tab
    fileencoding = "utf-8", -- file content encoding for the buffer
    foldenable = true, -- enable fold for nvim-ufo
    foldlevel = 99, -- set high foldlevel for nvim-ufo
    foldlevelstart = 99, -- start with all code unfolded
    foldmethod = "manual",
    foldcolumn = vim.fn.has "nvim-0.9" == 1 and "1" or nil, -- show foldcolumn in nvim 0.9
    hlsearch = true, -- Make line numbers default
    history = 100, -- number of commands to remember in a history table
    ignorecase = true, -- case insensitive searching
    infercase = true, -- infer cases in keyword completion
    laststatus = 3, -- global statusline
    linebreak = true, -- wrap lines at 'breakat'
    mouse = "a", -- enable mouse support
    number = true, -- show numberline
    relativenumber = true, -- show relative numberline
    shiftwidth = 2, -- number of space inserted for indentation
    showmode = false, -- disable showing modes in command line
    showtabline = 0, --  disable display tabline
    sidescrolloff = 8, -- number of columns to keep at the sides of the cursor
    signcolumn = "yes", -- always show the sign column
    smartcase = true, -- case sensitive searching
    splitbelow = true, -- splitting a new window below the current one
    splitright = true, -- splitting a new window at the right of the current one
    swapfile = false,
    tabstop = 2, -- number of space in a tab
    termguicolors = true, -- enable 24-bit RGB color in the TUI
    timeoutlen = 300, -- shorten key timeout length a little bit for which-key
    undofile = true, -- enable persistent undo
    updatetime = 250, -- length of time to wait before triggering the plugin
    virtualedit = "block", -- allow going past end of line in visual block mode
    wrap = false, -- disable wrapping of lines longer than the width of window
    writebackup = false, -- disable making a backup before overwriting a file
    conceallevel = 1, -- so that `` is visible in markdown
  },
  g = {
    max_file = { size = 1024 * 100, lines = 10000 }, -- set global limits for large files
    -- mapleader = "\\", -- set leader key
    mapleader = " ", -- set leader key
    maplocalleader = ",", -- set default local leader key
    autoformat_enabled = true, -- enable or disable auto formatting at start (lsp.formatting.format_on_save must be enabled)
    autopairs_enabled = true, -- enable autopairs at start
    cmp_enabled = true, -- enable completion at start
    codelens_enabled = true, -- enable or disable automatic codelens refreshing for lsp that support it
    diagnostics_mode = 3, -- set the visibility of diagnostics in the UI (0=off, 1=only show in status line, 2=virtual text off, 3=all on)
    highlighturl_enabled = true, -- highlight URLs by default
    icons_enabled = true, -- disable icons in the UI (disable if no nerd font is available)
    inlay_hints_enabled = false, -- enable or disable LSP inlay hints on startup (Neovim v0.10 only)
    lsp_handlers_enabled = true, -- enable or disable default vim.lsp.handlers (hover and signature help)
    semantic_tokens_enabled = true, -- enable or disable LSP semantic tokens on startup
    git_worktrees = nil, -- enable git integration for detached worktrees (specify a table where each entry is of the form { toplevel = vim.env.HOME, gitdir=vim.env.HOME .. "/.dotfiles" })
  }
}

for key, table in pairs(options) do
  for setting, value in pairs(table) do
    vim[key][setting] = value
  end
end

-- Enable logging
-- vim.api.nvim_set_var('nvim_logfile', '~/nvim.log')
-- local logFilePath = vim.fn.expand(vim.g.nvim_logfile)
--vim.api.nvim_command('redir! >> ' .. logFilePath .. ' | silent! set verbosefile=' .. logFilePath .. ' | set verbose=15 | redir END')

