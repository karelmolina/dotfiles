local status, cyberdream = pcall(require, "cyberdream")

if not status then
  return
end

cyberdream.setup({
  theme = "auto",
  hide_fillchars = true,
  transparent = true,
  italic_comments = true,
  borderless_telescope = false,
  terminal_colors = true,
  cache = true,
  borderless_pickers = true,
  overrides = function(c)
    return {
      CursorLine = { bg = c.bg },
      CursorLineNr = { fg = c.magenta },
    }
  end,
})

vim.cmd [[
  highlight Normal guibg=none
  highlight NonText guibg=none
  highlight Normal ctermbg=none
  highlight NonText ctermbg=none
]]

