local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local cmd = vim.api.nvim_create_user_command

local utils = require("core.utils")

autocmd({ "VimEnter", "FileType", "BufEnter", "WinEnter" }, {
  desc = "URL Highlighting",
  group = augroup("highlighturl", { clear = true }),
  callback = function()
    utils.set_url_match()
  end,
})

autocmd("TextYankPost", {
  desc = "Highlight yanked text",
  group = augroup("highlightyank", { clear = true }),
  pattern = "*",
  callback = function()
    vim.highlight.on_yank()
  end,
})

autocmd("BufWinEnter", {
  desc = "Make q close help, man, quickfix, dap floats",
  group = augroup("q_close_windows", { clear = true }),
  callback = function(args)
    local buftype = vim.api.nvim_get_option_value("buftype", { buf = args.buf })
    if vim.tbl_contains({ "help", "nofile", "quickfix" }, buftype) and vim.fn.maparg("q", "n") == "" then
      vim.keymap.set("n", "q", "<cmd>close<cr>", {
        desc = "Close window",
        buffer = args.buf,
        silent = true,
        nowait = true,
      })
    end
  end,
})

cmd("UpdateAllPackages", function()
  require("lazy").sync({ wait = true })
  require("astronvim.utils.mason").update_all()
end, { desc = "Update Plugins and Mason" })

autocmd("FileType", {
  pattern = "sh",
  callback = function()
    vim.lsp.start({
      name = "bash-language-server",
      cmd = { "bash-language-server", "start" },
    })
  end,
})

autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.http",
  callback = function()
    vim.bo.filetype = "http"
  end,
})

-- RAM Optimization: Auto-delete hidden buffers after 30 minutes
local buffer_cleanup_group = augroup("buffer_cleanup", { clear = true })

-- Track buffer access times
local buffer_access_times = {}

autocmd({ "BufEnter", "BufRead" }, {
  desc = "Track buffer access time",
  group = buffer_cleanup_group,
  pattern = "*",
  callback = function(args)
    buffer_access_times[args.buf] = vim.loop.now()
  end,
})

autocmd("BufDelete", {
  desc = "Remove buffer from tracking",
  group = buffer_cleanup_group,
  pattern = "*",
  callback = function(args)
    buffer_access_times[args.buf] = nil
  end,
})

-- Clean up hidden buffers every 10 minutes
autocmd("CursorHold", {
  desc = "Clean up old hidden buffers",
  group = buffer_cleanup_group,
  pattern = "*",
  callback = function()
    local now = vim.loop.now()
    local max_age = 30 * 60 * 1000 -- 30 minutes in milliseconds
    local buffers_deleted = 0
    
    for bufnr, last_access in pairs(buffer_access_times) do
      -- Check if buffer is valid, hidden, not modified, and old
      if vim.api.nvim_buf_is_valid(bufnr) then
        local is_hidden = vim.fn.bufwinnr(bufnr) == -1
        local is_modified = vim.api.nvim_get_option_value("modified", { buf = bufnr })
        local is_listed = vim.api.nvim_get_option_value("buflisted", { buf = bufnr })
        
        if is_hidden and not is_modified and is_listed and (now - last_access) > max_age then
          vim.api.nvim_buf_delete(bufnr, { force = false })
          buffer_access_times[bufnr] = nil
          buffers_deleted = buffers_deleted + 1
        end
      else
        buffer_access_times[bufnr] = nil
      end
    end
    
    if buffers_deleted > 0 then
      vim.notify("Cleaned up " .. buffers_deleted .. " old buffers", vim.log.levels.INFO)
    end
  end,
})
