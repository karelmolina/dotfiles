local util = require("core.utils")
local icons = require("core.utils.icons")
local is_available = util.is_available
local maps = {}
for _, mode in ipairs({ "", "n", "v", "x", "s", "o", "!", "i", "l", "c", "t" }) do
	maps[mode] = {}
end

local sections = {
	f = { desc = icons.Search .. "Find" },
	p = { desc = "Packages" },
	l = { desc = icons.ActiveLSP .. "LSP" },
	d = { desc = "Debugger" },
	g = { desc = "Git" },
	t = { desc = "Terminal" },
}

-- Normal --
-- Standard Operations
maps.n["j"] = { "v:count == 0 ? 'gj' : 'j'", expr = true, desc = "Move cursor down" }
maps.n["k"] = { "v:count == 0 ? 'gk' : 'k'", expr = true, desc = "Move cursor up" }
maps.n["<leader>w"] = { "<cmd>w<cr>", desc = "Save" }
maps.n["<leader>q"] = { "<cmd>confirm q<cr>", desc = "Quit" }
maps.n["<leader>n"] = { "<cmd>enew<cr>", desc = "New File" }
maps.n["<C-s>"] = { "<cmd>w!<cr>", desc = "Force write" }
maps.n["<C-q>"] = { "<cmd>qa!<cr>", desc = "Force quit" }
maps.n["|"] = { "<cmd>vsplit<cr>", desc = "Vertical Split" }
maps.n["-"] = { "<cmd>split<cr>", desc = "Horizontal Split" }
maps.n["<leader>k"] = { ":m .-2<CR>==", desc = "Move Line 1 line up" }
maps.n["<leader>j"] = { ":m .+1<CR>==", desc = "Move Line 1 line down" }
maps.v["<leader>k"] = { ":m '<-2<CR>==gv", desc = "Move Lines 1 line up" }
maps.v["<leader>j"] = { ":m '>+1<CR>==gv", desc = "Move Lines 1 line down" }

-- Plugin Manager
maps.n["<leader>p"] = sections.p
maps.n["<leader>pi"] = {
	function()
		require("lazy").install()
	end,
	desc = "Plugins Install",
}
maps.n["<leader>ps"] = {
	function()
		require("lazy").home()
	end,
	desc = "Plugins Status",
}
maps.n["<leader>pS"] = {
	function()
		require("lazy").sync()
	end,
	desc = "Plugins Sync",
}
maps.n["<leader>pu"] = {
	function()
		require("lazy").check()
	end,
	desc = "Plugins Check Updates",
}
maps.n["<leader>pU"] = {
	function()
		require("lazy").update()
	end,
	desc = "Plugins Update",
}
maps.n["<leader>pa"] = { "<cmd>UpdateAllPackages<cr>", desc = "Update Plugins and Mason Packages" }

-- Navigate tabs
maps.n["]t"] = {
	function()
		vim.cmd.tabnext()
	end,
	desc = "Next tab",
}
maps.n["[t"] = {
	function()
		vim.cmd.tabprevious()
	end,
	desc = "Previous tab",
}

-- Comment
if is_available("Comment.nvim") then
	maps.n["<leader>/"] = {
		function()
			require("Comment.api").toggle.linewise.count(vim.v.count > 0 and vim.v.count or 1)
		end,
		desc = "Toggle comment line",
	}
	maps.v["<leader>/"] = {
		"<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>",
		desc = "Toggle comment for selection",
	}
end

-- GitSigns
if is_available("gitsigns.nvim") then
	maps.n["<leader>g"] = sections.g
	maps.n["]g"] = {
		function()
			require("gitsigns").next_hunk()
		end,
		desc = "Next Git hunk",
	}
	maps.n["[g"] = {
		function()
			require("gitsigns").prev_hunk()
		end,
		desc = "Previous Git hunk",
	}
	maps.n["<leader>gl"] = {
		function()
			require("gitsigns").blame_line()
		end,
		desc = "View Git blame",
	}
	maps.n["<leader>gL"] = {
		function()
			require("gitsigns").blame_line({ full = true })
		end,
		desc = "View full Git blame",
	}
	maps.n["<leader>gp"] = {
		function()
			require("gitsigns").preview_hunk()
		end,
		desc = "Preview Git hunk",
	}
	maps.n["<leader>gh"] = {
		function()
			require("gitsigns").reset_hunk()
		end,
		desc = "Reset Git hunk",
	}
	maps.n["<leader>gr"] = {
		function()
			require("gitsigns").reset_buffer()
		end,
		desc = "Reset Git buffer",
	}
	maps.n["<leader>gs"] = {
		function()
			require("gitsigns").stage_hunk()
		end,
		desc = "Stage Git hunk",
	}
	maps.n["<leader>gS"] = {
		function()
			require("gitsigns").stage_buffer()
		end,
		desc = "Stage Git buffer",
	}
	maps.n["<leader>gu"] = {
		function()
			require("gitsigns").undo_stage_hunk()
		end,
		desc = "Unstage Git hunk",
	}
	maps.n["<leader>gd"] = {
		function()
			require("gitsigns").diffthis()
		end,
		desc = "View Git diff",
	}
end

-- NeoTree
if is_available("neo-tree.nvim") then
	maps.n["<leader>e"] = { "<cmd>Neotree toggle<cr>", desc = "Toggle Explorer" }
	maps.n["<leader>o"] = {
		function()
			if vim.bo.filetype == "neo-tree" then
				vim.cmd.wincmd("p")
			else
				vim.cmd.Neotree("focus")
			end
		end,
		desc = "Toggle Explorer Focus",
	}
end

-- Package Manager
if is_available("mason.nvim") then
	maps.n["<leader>pm"] = { "<cmd>Mason<cr>", desc = "Mason Installer" }
	maps.n["<leader>pM"] = { "<cmd>MasonUpdateAll<cr>", desc = "Mason Update" }
end

-- SymbolsOutline
if is_available("aerial.nvim") then
	maps.n["<leader>l"] = sections.l
	maps.n["<leader>lS"] = {
		function()
			require("aerial").toggle()
		end,
		desc = "Symbols outline",
	}
end

-- Telescope
if is_available("telescope.nvim") then
	maps.n["<leader>f"] = sections.f
	maps.n["<leader>g"] = sections.g
	maps.n["<leader>gb"] = {
		function()
			require("telescope.builtin").git_branches({ use_file_path = true })
		end,
		desc = "Git branches",
	}
	maps.n["<leader>gc"] = {
		function()
			require("telescope.builtin").git_commits({ use_file_path = true })
		end,
		desc = "Git commits (repository)",
	}
	maps.n["<leader>gC"] = {
		function()
			require("telescope.builtin").git_bcommits({ use_file_path = true })
		end,
		desc = "Git commits (current file)",
	}
	maps.n["<leader>gt"] = {
		function()
			require("telescope.builtin").git_status({ use_file_path = true })
		end,
		desc = "Git status",
	}
	maps.n["<leader>f<CR>"] = {
		function()
			require("telescope.builtin").resume()
		end,
		desc = "Resume previous search",
	}
	maps.n["<leader>f'"] = {
		function()
			require("telescope.builtin").marks()
		end,
		desc = "Find marks",
	}
	maps.n["<leader>f/"] = {
		function()
			require("telescope.builtin").current_buffer_fuzzy_find()
		end,
		desc = "Find words in current buffer",
	}
	maps.n["<leader>fb"] = {
		function()
			require("telescope.builtin").buffers()
		end,
		desc = "Find buffers",
	}
	maps.n["<leader>fc"] = {
		function()
			require("telescope.builtin").grep_string()
		end,
		desc = "Find word under cursor",
	}
	maps.n["<leader>fC"] = {
		function()
			require("telescope.builtin").commands()
		end,
		desc = "Find commands",
	}
	maps.n["<leader>ff"] = {
		function()
			require("telescope.builtin").find_files()
		end,
		desc = "Find files",
	}
	maps.n["<leader>fF"] = {
		function()
			require("telescope.builtin").find_files({ hidden = true, no_ignore = true })
		end,
		desc = "Find all files",
	}
	maps.n["<leader>fh"] = {
		function()
			require("telescope.builtin").help_tags()
		end,
		desc = "Find help",
	}
	maps.n["<leader>fk"] = {
		function()
			require("telescope.builtin").keymaps()
		end,
		desc = "Find keymaps",
	}
	maps.n["<leader>fm"] = {
		function()
			require("telescope.builtin").man_pages()
		end,
		desc = "Find man",
	}
	if is_available("nvim-notify") then
		maps.n["<leader>fn"] = {
			function()
				require("telescope").extensions.notify.notify()
			end,
			desc = "Find notifications",
		}
	end
	maps.n["<leader>fo"] = {
		function()
			require("telescope.builtin").oldfiles()
		end,
		desc = "Find history",
	}
	maps.n["<leader>fr"] = {
		function()
			require("telescope.builtin").registers()
		end,
		desc = "Find registers",
	}
	maps.n["<leader>ft"] = {
		function()
			require("telescope.builtin").colorscheme({ enable_preview = true })
		end,
		desc = "Find themes",
	}
	maps.n["<leader>fw"] = {
		function()
			require("telescope.builtin").live_grep()
		end,
		desc = "Find words",
	}
	maps.n["<leader>fW"] = {
		function()
			require("telescope.builtin").live_grep({
				additional_args = function(args)
					return vim.list_extend(args, { "--hidden", "--no-ignore" })
				end,
			})
		end,
		desc = "Find words in all files",
	}
	maps.n["<leader>l"] = sections.l
	maps.n["<leader>ls"] = {
		function()
			local aerial_avail, _ = pcall(require, "aerial")
			if aerial_avail then
				require("telescope").extensions.aerial.aerial()
			else
				require("telescope.builtin").lsp_document_symbols()
			end
		end,
		desc = "Search symbols",
	}
end

-- Terminal
if is_available("toggleterm.nvim") then
	maps.n["<leader>t"] = sections.t
	if vim.fn.executable("lazygit") == 1 then
		maps.n["<leader>g"] = sections.g
		maps.n["<leader>gg"] = {
			"<cmd>lua _lazygit_toggle() <CR>",
			desc = "ToggleTerm lazygit",
		}
	end
	if vim.fn.executable("node") == 1 then
		maps.n["<leader>tn"] = {
			function()
				utils.toggle_term_cmd("node")
			end,
			desc = "ToggleTerm node",
		}
	end
	maps.n["<leader>tf"] = { "<cmd>ToggleTerm direction=float<cr>", desc = "ToggleTerm float" }
	maps.n["<leader>th"] = { "<cmd>ToggleTerm size=10 direction=horizontal<cr>", desc = "ToggleTerm horizontal split" }
	maps.n["<leader>tv"] = { "<cmd>ToggleTerm size=80 direction=vertical<cr>", desc = "ToggleTerm vertical split" }
end

if is_available("nvim-dap") then
	maps.n["<leader>d"] = sections.d
	maps.v["<leader>d"] = sections.d
	maps.n["<leader>db"] = {
		function()
			require("dap").toggle_breakpoint()
		end,
		desc = "Toggle Breakpoint",
	}
	maps.n["<leader>dB"] = {
		function()
			require("dap").clear_breakpoints()
		end,
		desc = "Clear Breakpoints",
	}
	maps.n["<leader>dc"] = {
		function()
			require("dap").continue()
		end,
		desc = "Start/Continue",
	}
	maps.n["<leader>dC"] = {
		function()
			vim.ui.input({ prompt = "Condition: " }, function(condition)
				if condition then
					require("dap").set_breakpoint(condition)
				end
			end)
		end,
		desc = "Conditional Breakpoint",
	}
	maps.n["<leader>di"] = {
		function()
			require("dap").step_into()
		end,
		desc = "Step Into",
	}
	maps.n["<leader>do"] = {
		function()
			require("dap").step_over()
		end,
		desc = "Step Over",
	}
	maps.n["<leader>dO"] = {
		function()
			require("dap").step_out()
		end,
		desc = "Step Out",
	}
	maps.n["<leader>dq"] = {
		function()
			require("dap").close()
		end,
		desc = "Close Session",
	}
	maps.n["<leader>dQ"] = {
		function()
			require("dap").terminate()
		end,
		desc = "Terminate Session",
	}
	maps.n["<leader>dp"] = {
		function()
			require("dap").pause()
		end,
		desc = "Pause",
	}
	maps.n["<leader>dr"] = {
		function()
			require("dap").restart_frame()
		end,
		desc = "Restart",
	}
	maps.n["<leader>dR"] = {
		function()
			require("dap").repl.toggle()
		end,
		desc = "Toggle REPL",
	}
	maps.n["<leader>ds"] = {
		function()
			require("dap").run_to_cursor()
		end,
		desc = "Run To Cursor",
	}

	if is_available("nvim-dap-ui") then
		maps.n["<leader>dE"] = {
			function()
				vim.ui.input({ prompt = "Expression: " }, function(expr)
					if expr then
						require("dapui").eval(expr, { enter = true })
					end
				end)
			end,
			desc = "Evaluate Input",
		}
		maps.v["<leader>dE"] = {
			function()
				require("dapui").eval()
			end,
			desc = "Evaluate Input",
		}
		maps.n["<leader>du"] = {
			function()
				require("dapui").toggle()
			end,
			desc = "Toggle Debugger UI",
		}
		maps.n["<leader>dh"] = {
			function()
				require("dap.ui.widgets").hover()
			end,
			desc = "Debugger Hover",
		}
	end
end

-- Improved Code Folding
if is_available("nvim-ufo") then
	maps.n["zR"] = {
		function()
			require("ufo").openAllFolds()
		end,
		desc = "Open all folds",
	}
	maps.n["zM"] = {
		function()
			require("ufo").closeAllFolds()
		end,
		desc = "Close all folds",
	}
	maps.n["zr"] = {
		function()
			require("ufo").openFoldsExceptKinds()
		end,
		desc = "Fold less",
	}
	maps.n["zm"] = {
		function()
			require("ufo").closeFoldsWith()
		end,
		desc = "Fold more",
	}
	maps.n["zp"] = {
		function()
			require("ufo").peekFoldedLinesUnderCursor()
		end,
		desc = "Peek fold",
	}
end

maps.n["<C-l>"] = false

util.set_mappings(maps)
