return {
  {
    "williamboman/mason.nvim",
    lazy = false,
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
    lazy = false,
    opts = {
      ensure_installed = {
        -- Formatters
        "stylua",
        "prettierd",
        "gofumpt",
        "goimports-reviser",
        "golines",
        "pint",
        "blade-formatter",
        -- "dart_format" is not a Mason package; it ships with the Dart SDK (dart format)
        -- "rubocop", -- fails to install; install manually with `:MasonInstall rubocop` and check the error
        "shfmt",

        -- Linters
        "eslint_d",
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
