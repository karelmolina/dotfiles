local status, noice = pcall(require, "noice")
if not status then
  return
end

noice.setup({
  cmdline = {
    view = "cmdline_popup",
  },
  messages = {
    view = "mini",
  },
  opts = {
    highlight = {
      background = "#1a1b45",
    }
  },
  -- stylua: ignore
  max_height = function() return math.floor(vim.o.lines * 0.75) end,
  -- stylua: ignore
  max_width = function() return math.floor(vim.o.columns * 0.75) end,
  lsp = {
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
      ["cmp.entry.get_documentation"] = true,
    },
  },
  views = {
    cmdline_popup = {
      position = {
        row = 5,
        col = "50%",
      },
      size = {
        width = 60,
        height = "auto",
      },
    },
    popupmenu = {
      relative = "editor",
      position = {
        row = 8,
        col = "50%",
      },
      size = {
        width = 60,
        height = 10,
      },
      border = {
        style = "rounded",
        padding = { 0, 1 },
      },
      win_options = {
        winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
      },
    },
  },
})
