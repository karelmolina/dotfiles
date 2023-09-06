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

require("core.utils").which_key_register()
