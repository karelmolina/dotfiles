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

-- ============================================================================
-- Opencode Project Directory Tracking
-- ============================================================================
-- Purpose: Track the current project directory for Opencode AI assistant
-- integration. This allows Opencode to always open in the correct project
-- context, even when switching between projects using neovim-project.
--
-- How it works:
--   1. On VimEnter, we capture the initial working directory
--   2. When DirChanged fires (e.g., from neovim-project switching),
--      we update the tracked directory after a short debounce period
--   3. Both toggleterm.lua and opencode.nvim config use vim.g.opencode_project_dir
--      to determine the correct working directory for Opencode sessions
--
-- vim.g.opencode_project_dir stores the currently tracked project directory
-- vim.g._opencode_dir_debounce stores the timer ID for debounce management

local opencode_sync_group = augroup("OpencodeProjectSync", { clear = true })

-- Initialize project directory on startup
-- This captures the initial working directory so Opencode knows the project
-- context even before any directory changes occur
autocmd("VimEnter", {
  desc = "Initialize Opencode project directory on startup",
  group = opencode_sync_group,
  once = true,
  callback = function()
    vim.g.opencode_project_dir = vim.fn.getcwd()
  end,
})

-- Track directory changes with debounce to handle rapid project switches
-- Debounce prevents race conditions when neovim-project switches directories quickly
autocmd("DirChanged", {
  desc = "Update Opencode project directory on directory change (with debounce)",
  group = opencode_sync_group,
  pattern = "*",
  callback = function(args)
    -- Clear existing debounce timer if present (prevents overlapping updates)
    if vim.g._opencode_dir_debounce then
      vim.fn.timer_stop(vim.g._opencode_dir_debounce)
    end

    -- Set new debounce timer (100ms delay)
    -- The timer ensures we only update after directory changes settle
    vim.g._opencode_dir_debounce = vim.fn.timer_start(100, function()
      vim.schedule(function()
        -- args.file contains the new directory path from DirChanged event
        -- Fallback to vim.fn.getcwd() if args.file is not available
        vim.g.opencode_project_dir = args.file or vim.fn.getcwd()
        
        -- Notify sudo-tee's opencode.nvim about directory change
        -- This triggers session reset and context unloading for new project
        local ok, opencode = pcall(require, "opencode.core")
        if ok and opencode.handle_directory_change then
          opencode.handle_directory_change()
        end
      end)
      vim.g._opencode_dir_debounce = nil
    end)
  end,
})

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

-- Disable spell checking for all buffers
autocmd({ "BufEnter", "FileType" }, {
  desc = "Disable spell checking",
  group = augroup("disable_spell", { clear = true }),
  pattern = "*",
  callback = function()
    vim.opt_local.spell = false
  end,
})
