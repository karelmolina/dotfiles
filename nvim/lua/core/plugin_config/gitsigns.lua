-- import gitsigns plugin safely
local setup, gitsigns = pcall(require, "gitsigns")
if not setup then
	return
end

gitsigns.setup({
	on_attach = function(bufnr)
		local gs = package.loaded.gitsigns

		local function map(mode, l, r, opts)
			opts = opts or {}
			opts.buffer = bufnr
			vim.keymap.set(mode, l, r, opts)
		end

		-- Navigation
		map("n", "<leader>n", function()
			if vim.wo.diff then
				return "<leader>n"
			end
			vim.schedule(function()
				gs.next_hunk()
			end)
			return "<Ignore>"
		end, { expr = true })

		map("n", "<leader>p", function()
			if vim.wo.diff then
				return "<leader>p"
			end
			vim.schedule(function()
				gs.prev_hunk()
			end)
			return "<Ignore>"
		end, { expr = true })

		-- Actions
		map({ "n", "v" }, "<leader>hs", ":Gitsigns stage_hunk<CR>")
		map({ "n", "v" }, "<leader>hr", ":Gitsigns reset_hunk<CR>")
		map("n", "<leader>hS", gs.stage_buffer, { desc = "Stage Buffer" })
		map("n", "<leader>hu", gs.undo_stage_hunk, { desc = "UnStage Buffer" })
		map("n", "<leader>hR", gs.reset_buffer, { desc = "Reset Buffer" })
		map("n", "<leader>hp", gs.preview_hunk, { desc = "Preview Hunk" })
		map("n", "<leader>hb", function()
			gs.blame_line({ full = true })
		end, { desc = "Blame Line" })
		map("n", "<leader>tb", gs.toggle_current_line_blame, { desc = "Current Line Blame" })
		map("n", "<leader>hd", gs.diffthis, { desc = "Open Diff" })
		map("n", "<leader>hD", function()
			gs.diffthis("~")
		end, { desc = "Diff Lines" })
		map("n", "<leader>td", gs.toggle_deleted, { desc = "Toggle Delete" })

		-- Text object
		map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
	end,
})
