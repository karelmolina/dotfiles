local default = "rose-pine"
local theme = vim.env.theme or default

pcall(vim.cmd.colorscheme, theme)
