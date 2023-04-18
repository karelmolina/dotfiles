local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
	--helper functions
	"nvim-lua/plenary.nvim",
	--colorscheme
	{ "bluz71/vim-moonfly-colors", name = "moonfly", lazy = true, priority = 1000 },
	-- tree view
	"nvim-tree/nvim-tree.lua",
	"nvim-tree/nvim-web-devicons",

	"nvim-treesitter/nvim-treesitter",
	-- bottom line
	"nvim-lualine/lualine.nvim",
	-- add, delete, change surroundings
	"tpope/vim-surround",
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.1",
	},
	{ "nvim-telescope/telescope-fzf-native.nvim", run = "make" },

	-- autocompletion
	"hrsh7th/nvim-cmp", -- completion plugin
	"hrsh7th/cmp-buffer", -- source for text in buffer
	"hrsh7th/cmp-path", -- source for file system paths

	-- snippets
	"L3MON4D3/LuaSnip", -- snippet engine
	"saadparwaiz1/cmp_luasnip", -- for autocompletion
	"rafamadriz/friendly-snippets", -- useful snippets

	-- managing & installing lsp servers, linters & formatters
	"williamboman/mason.nvim", -- in charge of managing lsp servers, linters & formatters
	"williamboman/mason-lspconfig.nvim", -- bridges gap b/w mason & lspconfig
	"onsails/lspkind.nvim", -- vs-code like icons for autocompletion

	-- configuring lsp servers
	"neovim/nvim-lspconfig", -- easily configure language servers
	"hrsh7th/cmp-nvim-lsp", -- for autocompletion
	{
		"glepnir/lspsaga.nvim",
		branch = "main",
	}, -- enhanced lsp uis

	-- formatting & linting
	"jose-elias-alvarez/null-ls.nvim", -- configure formatters & linters
	"jayp0521/mason-null-ls.nvim", -- bridges gap b/w mason & null-ls

	"windwp/nvim-autopairs", -- autoclose parens, brackets, quotes, etc...
	"windwp/nvim-ts-autotag", -- autoclose tags

	-- commenting with gc
	"numToStr/Comment.nvim",
	"lukas-reineke/indent-blankline.nvim",

	-- git
	"lewis6991/gitsigns.nvim",
	"tpope/vim-fugitive",

	-- autopairs
	"windwp/nvim-autopairs",

	-- toggle term
	"akinsho/toggleterm.nvim",

	-- multiline cursor
	"mg979/vim-visual-multi",

	-- Add indentation guides even on blank lines
	"lukas-reineke/indent-blankline.nvim",

	-- display keybidings
	"folke/which-key.nvim",

	-- search and replace
	"nvim-pack/nvim-spectre",
}

local opts = {}

require("lazy").setup(plugins, opts)
