local setup, nvimtree = pcall(require, "nvim-tree")

if not setup then
	return
end

-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

-- empty setup using defaults
require("nvim-tree").setup({
    actions  = {
        open_file = {
            quit_on_open = true,
            window_picker = {
                enable = false,
            }
        },
    },
    system_open = {
        cmd = "open",
    },
	renderer = {
		group_empty = true,
		icons = {
		  show = {
			git = true,
			file = false,
			folder = false,
			folder_arrow = true,
		  },
		  glyphs = {
			folder = {
			  arrow_closed = "⏵",
			  arrow_open = "⏷",
			},
			git = {
			  unstaged = "✗",
			  staged = "✓",
			  unmerged = "⌥",
			  renamed = "➜",
			  untracked = "★",
			  deleted = "⊖",
			  ignored = "◌",
			},
		  },
		},
	  },
})

-- open nvim-tree on setup

local function open_nvim_tree(data)
  -- buffer is a [No Name]
  local no_name = data.file == "" and vim.bo[data.buf].buftype == ""

  -- buffer is a directory
  local directory = vim.fn.isdirectory(data.file) == 1

  if not no_name and not directory then
    return
  end

  -- change to the directory
  if directory then
    vim.cmd.cd(data.file)
  end

  -- open the tree
  require("nvim-tree.api").tree.open()
end

vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })
