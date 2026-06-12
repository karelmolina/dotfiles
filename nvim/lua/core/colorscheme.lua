require("core.colorschemes")

-- colorscheme
local default = "cyberdream"
local theme = vim.env.theme or default

pcall(vim.cmd.colorscheme, theme)
