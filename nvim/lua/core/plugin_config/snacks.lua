-- Snacks.nvim configuration
-- This configures the picker used by opencode for commands, mentions, etc.
--
-- KEYMAP DESIGN (as of 2026-02-26):
-- - <CR> (Enter): Confirm/select item in picker
-- - <C-y>: Alternative confirm (for users who prefer it)
-- - <C-j>/<C-k>: Navigate down/up in picker list
-- - <Tab>: Reserved for opencode.nvim pane toggle (see opencode.lua)
-- - <S-Tab>: Removed (redundant with <C-k>)
--
-- Rationale: Tab is used by opencode.nvim to toggle between input/output panes,
-- so we use Enter for confirmation to avoid conflicts.

local status_ok, snacks = pcall(require, "snacks")
if not status_ok then
  return
end

snacks.setup({
  picker = {
    -- Configure input window keymaps for picker navigation
    win = {
      input = {
        keys = {
          -- Use Enter to confirm/select item
          ["<CR>"] = { "confirm", mode = { "i", "n" } },
          -- Alternative confirm with Ctrl-y
          ["<C-y>"] = { "confirm", mode = { "i", "n" } },
          -- Ctrl-j/k for navigation (consistent with vim conventions)
          ["<C-j>"] = { "list_down", mode = { "i", "n" } },
          ["<C-k>"] = { "list_up", mode = { "i", "n" } },
          -- NOTE: <Tab> is intentionally NOT mapped here - it's used by opencode.nvim
          -- to toggle between input/output panes (see opencode.lua keymap.input_window)
        },
      },
      list = {
        keys = {
          -- Enter in list view also confirms
          ["<CR>"] = { "confirm", mode = { "n", "i" } },
          -- Alternative confirm with Ctrl-y
          ["<C-y>"] = { "confirm", mode = { "n", "i" } },
          -- NOTE: <Tab> is intentionally NOT mapped here - reserved for opencode.nvim
        },
      },
    },
  },
})
