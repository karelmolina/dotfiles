-- Windsurf (formerly Codeium) configuration
-- Disable autocomplete in specific filetypes/buffers

-- IMPORTANT: Must be set BEFORE windsurf loads
vim.g.codeium_filetypes = {
  opencode_output = false,
  opencode_input = false,
  opencode_ask = false,
  opencode_terminal = false,
}

-- Check if we're using windsurf.nvim (Lua) or windsurf.vim (Vimscript)
local has_windsurf_nvim, windsurf = pcall(require, "codeium")

if has_windsurf_nvim then
  -- windsurf.nvim - Use setup() to configure
  windsurf.setup({
    -- Disable in specific filetypes
    virtual_text = {
      filetypes = {
        opencode_output = false,
        opencode_input = false,
        opencode_ask = false,
        opencode_terminal = false,
      },
      -- Enable by default for other filetypes
      default_filetype_enabled = true,
    },
  })
end

-- Aggressive disable via autocmd for both variants
-- Use BufEnter to catch all opencode buffers as early as possible
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter", "FileType" }, {
  pattern = { "*" },
  callback = function(args)
    local buf_ft = vim.bo[args.buf].filetype
    -- Check if this is an opencode buffer
    if buf_ft:match("^opencode") then
      -- Disable windsurf for this buffer
      vim.b[args.buf].codeium_enabled = false
      -- Disable buffer variable
      vim.b.codeium_enabled = false
    else
      -- Re-enable for non-opencode buffers (if globally enabled)
      if vim.g.codeium_enabled ~= false then
        vim.b[args.buf].codeium_enabled = true
      end
    end
  end,
  desc = "Disable Windsurf autocomplete in opencode.nvim buffers",
})
