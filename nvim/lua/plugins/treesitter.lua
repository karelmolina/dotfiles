return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = function()
      local ts = require("nvim-treesitter")
      ts.install({
        "markdown",
        "markdown_inline",
        "lua",
        "go",
        "php",
        "dart",
        "javascript",
        "typescript",
        "css",
        "html",
        "latex",
        "scss",
      })
    end,
    config = function()
      -- Native Neovim treesitter highlight/indent is enabled automatically
      -- when parsers are available. No additional setup needed.
    end,
  },
}
