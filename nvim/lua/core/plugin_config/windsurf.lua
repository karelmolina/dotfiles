-- Windsurf (formerly Codeium) configuration
-- Disable autocomplete in specific filetypes/buffers

-- Check if we're using windsurf.nvim (Lua) or windsurf.vim (Vimscript)
local has_windsurf_nvim, windsurf = pcall(require, "codeium")

if has_windsurf_nvim then
  -- windsurf.nvim - Use setup() to configure
  windsurf.setup({
    virtual_text = {
      -- Enable by default for all filetypes
      default_filetype_enabled = true,
    },
  })
end
