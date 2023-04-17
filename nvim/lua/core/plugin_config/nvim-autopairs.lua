local setup, nvimautopairs = pcall(require, "nvim-autopairs")

if not setup then
	return
end

autopairs.setup({
	check_ts = true,
	ts_config = { java = false },
	fast_wrap = {
		map = "<leader>e",
		chars = { "{", "[", "(", '"', "'" },
		pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
		offset = 0,
		end_key = "$",
		keys = "qwertyuiopzxcvbnmasdfghjkl",
		check_comma = true,
		highlight = "PmenuSel",
		highlight_grey = "LineNr",
	},
})
