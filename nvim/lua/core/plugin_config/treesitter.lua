-- import nvim-treesitter plugin safely
local status, treesitter = pcall(require, "nvim-treesitter.configs")
if not status then
  return
end

-- configure treesitter with RAM optimizations
treesitter.setup({
  -- enable syntax highlighting
  highlight = {
    enable = true,
    -- Disable highlighting for large files
    disable = function(lang, buf)
      local max_filesize = 100 * 1024 -- 100 KB
      local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
      if ok and stats and stats.size > max_filesize then
        return true
      end
    end,
  },
  -- enable indentation
  indent = { enable = true },
  -- Only install parsers on demand, not all at once
  sync_install = false,
  -- Reduced list of essential parsers
  ensure_installed = {
    "json",
    "javascript",
    "typescript",
    "tsx",
    "yaml",
    "html",
    "css",
    "bash",
    "lua",
    "go",
    "python",
    "php",
    "blade",
    "markdown",
    "markdown_inline",
    "dart",
  },
  modules = {},
  ignore_install = {},
  -- Disable auto_install to prevent memory spikes
  auto_install = false,
  -- Incremental selection can use memory
  incremental_selection = {
    enable = false,
  },
})

-- Auto-disable treesitter for very large files
vim.api.nvim_create_autocmd({ "BufReadPre" }, {
  pattern = "*",
  callback = function()
    local max_filesize = 1024 * 1024 -- 1 MB
    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(0))
    if ok and stats and stats.size > max_filesize then
      vim.cmd("TSBufDisable highlight")
      vim.cmd("TSBufDisable indent")
    end
  end,
})
