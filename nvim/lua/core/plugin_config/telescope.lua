-- import telescope plugin safely
local telescope_setup, telescope = pcall(require, "telescope")
if not telescope_setup then
  return
end

-- import telescope actions safely
local actions_setup, actions = pcall(require, "telescope.actions")
if not actions_setup then
  return
end

-- configure telescope
telescope.setup {
  extensions = {
    fzf = {
      fuzzy = true,                     -- false will only do exact matching
      override_generic_sorter = true,   -- override the generic sorter
      override_file_sorter = true,      -- override the file sorter
      case_mode = "smart_case",         -- or "ignore_case" or "respect_case"
      -- the default case_mode is "smart_case"
    }
  },
  defaults = {
    git_worktrees = vim.g.git_worktrees,
    prompt_prefix = "?",
    selection_caret = "*",
            path_display = { "truncate" },
        sorting_strategy = "ascending",
        layout_config = {
          horizontal = {
            preview_width = 0.55,
          },
          vertical = {
            mirror = false,
          },
          width = 0.87,
          height = 0.80,
          preview_cutoff = 120,
        },


    mappings = {
      i = {
          ["<C-n>"] = actions.cycle_history_next,
          ["<C-p>"] = actions.cycle_history_prev,
          ["<C-j>"] = actions.move_selection_next,
          ["<C-k>"] = actions.move_selection_previous,
      },
      n = { ["q"] = actions.close},
    }
  },
}

local utils = require "core.utils"
local notify = pcall(require, "notify")
local aerial = pcall(require, "aerial")

if notify then telescope.load_extension("notify") end
if aerial then telescope.load_extension("aerial") end
if utils.is_available "telescope-fzf-native.nvim" then telescope.load_extension("fzf") end
