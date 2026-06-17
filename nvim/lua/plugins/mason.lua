return {
  {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonToolsInstall", "MasonToolsUpdate" },
    build = ":MasonUpdate",
    opts = {
      PATH = "prepend",
      ui = {
        border = "rounded",
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    },
  },
  {
    "whoissethdaniel/mason-tool-installer.nvim",
    dependencies = { "williamboman/mason.nvim" },
    cmd = { "MasonToolsInstall", "MasonToolsUpdate", "MasonToolsClean" },
    opts = {
      ensure_installed = {
        -- Formatters
        "stylua",
        "prettierd",
        "gofumpt",
        "goimports",
        "golines",
        "pint",
        "blade-formatter",
        "shfmt",

        -- Linters
        "eslint",
        "rubocop",
        "shellcheck",
        "hadolint",
        "phpstan",
        "golangci-lint",
      },
      auto_update = false,
      run_on_start = true,
      start_delay = 3000,
      debounce_hours = 5,
    },
  },
}
