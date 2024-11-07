local projects = require("core.utils.projects")
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
    --helper functions and ui
    "nvim-lua/plenary.nvim",
    { "max397574/better-escape.nvim", event = "InsertCharPre", opts = { timeout = 300 } },
    {
        "kevinhwang91/nvim-ufo",
        event = { "InsertEnter" },
        dependencies = { "kevinhwang91/promise-async" },
        run = 'yarn install --frozen-lockfile',
    },
    { "rcarriga/nvim-notify" },

    --colorscheme
    {
      "folke/tokyonight.nvim",
      lazy = false,
      priority = 1000,
      opts = {},
    },
    { "rebelot/kanagawa.nvim" },

    -- git
    "lewis6991/gitsigns.nvim",

    -- Detect tabstop and shiftwidth automatically
    "tpope/vim-sleuth",

    -- which key
    "folke/which-key.nvim",

    -- bottom line
    "nvim-lualine/lualine.nvim",

    -- Add indentation guides even on blank lines
    { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },

    { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
      dependencies = {
        "JoosepAlviste/nvim-ts-context-commentstring",
        "nvim-treesitter/nvim-treesitter-textobjects",
      },
    },
    {

        "windwp/nvim-ts-autotag",
        ft = {
          "javascript", "typescript", 'javascriptreact', 'typescriptreact'
        },
        dependencies = "nvim-treesitter/nvim-treesitter",
        config = function ()
        require('nvim-ts-autotag').setup({})
        end,
        lazy = true,
        event = "VeryLazy"
    },
     -- neo-tree
    {
        "nvim-neo-tree/neo-tree.nvim",
        dependencies = { "MunifTanjim/nui.nvim", "nvim-tree/nvim-web-devicons" },
        cmd = "Neotree",
        init = function() vim.g.neo_tree_remove_legacy_commands = true end,
    },
    -- "gc" to comment visual regions/lines
    { 'numToStr/Comment.nvim', opts = {} },

    -- autopairs
    "windwp/nvim-autopairs",

    -- add, delete, change surroundings
    "tpope/vim-surround",
    -- telescope
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            { "nvim-telescope/telescope-fzf-native.nvim", enabled = vim.fn.executable "make" == 1, build = "make" },
        }
    },
    "nvim-telescope/telescope-file-browser.nvim",
    "stevearc/dressing.nvim",
    "nvim-telescope/telescope-dap.nvim",

    -- toggle term
    "akinsho/toggleterm.nvim",

    -- multiline cursor
    "mg979/vim-visual-multi",

    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            {
              "L3MON4D3/LuaSnip",
              -- follow latest release.
              version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
              -- install jsregexp (optional!).
              build = "make install_jsregexp",
            },
            "saadparwaiz1/cmp_luasnip",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-nvim-lsp", -- for autocompletion
        },

    },

    -- managing & installing lsp servers, linters & formatters
    "williamboman/mason.nvim", -- in charge of managing lsp servers, linters & formatters
    "williamboman/mason-lspconfig.nvim", -- bridges gap b/w mason & lspconfig

    -- configuring lsp servers
    "stevearc/aerial.nvim",
    "neovim/nvim-lspconfig", -- easily configure language servers
    {
        "glepnir/lspsaga.nvim",
        branch = "main",
    }, -- enhanced lsp uis

    -- formatting & linting
    "jose-elias-alvarez/null-ls.nvim", -- configure formatters & linters
    "jayp0521/mason-null-ls.nvim", -- bridges gap b/w mason & null-ls

    -- nvim-dap,
    {
      "mfussenegger/nvim-dap",
      enabled = vim.fn.has "win32" == 0,
      dependencies = {
        "mxsdev/nvim-dap-vscode-js",
        {
          "jay-babu/mason-nvim-dap.nvim",
          dependencies = { "nvim-dap" },
          cmd = { "DapInstall", "DapUninstall" },
          opts = { handlers = {}, ensure_installed = {"js"} },
        },
        {
          "rcarriga/nvim-dap-ui",
          dependencies = { "nvim-neotest/nvim-nio" },
          opts = { floating = { border = "rounded" } },
        },
        {
          "rcarriga/cmp-dap",
          dependencies = { "nvim-cmp" },
        },
        { "folke/neodev.nvim", opts = {} },
        "mfussenegger/nvim-dap-python",
      },
    },

    {
        "dreamsofcode-io/nvim-dap-go",
        ft = "go",
        dependencies = "mfussenegger/nvim-dap",
        config = function(_, opts)
          require("dap-go").setup(opts)
        end
    },
    {
        "olexsmir/gopher.nvim",
        ft = "go",
        config = function(_, opts)
          require("gopher").setup(opts)
        end,
        build = function()
          vim.cmd [[silent! GoInstallDeps]]
        end,
    },
    {
      'Exafunction/codeium.vim',
      event = 'BufEnter',
    },
    { "ellisonleao/glow.nvim", config = true, cmd = "Glow"},
    {
      "coffebar/neovim-project",
      opts = {
        projects = projects.get_project_path(),
        datapath = vim.fn.stdpath("data"),
        last_session_on_startup = true,
      },
      init = function()
        vim.opt.sessionoptions:append("globals")
      end,
      dependencies = {
        { "nvim-lua/plenary.nvim" },
        { "nvim-telescope/telescope.nvim", tag = "0.1.4" },
        { "Shatur/neovim-session-manager" },
      },
      lazy = true,
      priority = 100,
    }
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
  { "norcalli/nvim-colorizer.lua" },
  {
}

local opts = {}

require("lazy").setup(plugins, opts)
