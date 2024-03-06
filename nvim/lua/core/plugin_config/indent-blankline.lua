local status, indent = pcall(require, "ibl")

if not status then
	return
end

vim.opt.list = true
-- vim.opt.listchars:append("space:⋅")
vim.opt.listchars:append("eol:↴")

local highlight = {
    "CursorColumn",
    "Whitespace",
}

indent.setup {
    indent = { highlight = highlight, char = "" },
    whitespace = {
        highlight = highlight,
        remove_blankline_trail = false,
    },
    scope = { enabled = false },
}

-- indent.setup({
-- 	buftype_exclude = {
-- 		"nofile",
-- 		"terminal",
-- 	},
-- 	filetype_exclude = {
-- 		"help",
-- 		"startify",
-- 		"aerial",
-- 		"alpha",
-- 		"dashboard",
-- 		"lazy",
-- 		"neogitstatus",
-- 		"NvimTree",
-- 		"neo-tree",
-- 		"Trouble",
-- 	},
-- 	context_patterns = {
-- 		"class",
-- 		"return",
-- 		"function",
-- 		"method",
-- 		"^if",
-- 		"^while",
-- 		"jsx_element",
-- 		"^for",
-- 		"^object",
-- 		"^table",
-- 		"block",
-- 		"arguments",
-- 		"if_statement",
-- 		"else_clause",
-- 		"jsx_element",
-- 		"jsx_self_closing_element",
-- 		"try_statement",
-- 		"catch_clause",
-- 		"import_statement",
-- 		"operation_type",
-- 	},
-- 	show_trailing_blankline_indent = false,
-- 	use_treesitter = true,
-- 	char = "▏",
-- 	context_char = "▏",
-- 	show_current_context = true,
-- 	show_current_context_start = true,
-- })
