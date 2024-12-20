local status, indent = pcall(require, "ibl")

if not status then
    return
end

vim.opt.list = true
-- vim.opt.listchars:append("space:⋅")
vim.opt.listchars:append("eol:↴")

local highlight = {
    "CursorColumn",
    "Whitespace",
}

indent.setup {
    indent = { highlight = highlight, char = "┊" },
    whitespace = {
        highlight = highlight,
        remove_blankline_trail = false,
    },
    exclude = {
        filetypes = { "dashboard" },
        buftypes = { "nofile" },
    }
}
