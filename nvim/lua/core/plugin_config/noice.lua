local status, noice = pcall(require, "noice")
if not status then
  return
end

noice.setup({
  cmdline = {
    view = "cmdline_popup",
  },
  lsp = {
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
      ["cmp.entry.get_documentation"] = true,
    },
  },
})
