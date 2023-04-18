local status, whichKey = pcall(require, "which-key")

if not status then
	return
end

vim.o.timeout = true
vim.o.timeoutlen = 300

whichKey.setup({
	icons = {
		group = vim.g.icons_enabled and "" or "+",
		separator = " ",
	},
	disable = {
		filetypes = {
			"TelescopePrompt",
		},
	},
})

whichKey.register({
	["<leader>"] = {
		f = { desc = " Find" },
		g = { desc = " Git" },
		t = { desc = " Terminal" },
		l = { desc = " Lazy" },
        n = { desc = "Next Hunk"},
        p = { desc = "Prev Hunk"},
        h = { desc = "Hunk Actions"},
        s = { desc = "Spectre Actions"},
	},
})
