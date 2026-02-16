local setup, kulala = pcall(require, "kulala")
if not setup then
  return
end

kulala.setup({
  global_keymaps = false,
  global_keymaps_prefix = "<leader>R",
  kulala_keymaps_prefix = "",
  -- Enable syntax highlighting for HTTP files
  additional_curl_options = {},
})

-- Enable treesitter highlighting for HTTP files
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.http", "*.rest" },
  callback = function()
    -- Ensure treesitter highlighting is enabled
    local ok, parser = pcall(vim.treesitter.get_parser, 0)
    if ok and parser then
      pcall(vim.treesitter.highlighter.new, parser)
    end
  end,
})
