local setup, nvimautopairs = pcall(require, "nvim-autopairs")

if not setup then
	return
end

nvimautopairs.setup({})
