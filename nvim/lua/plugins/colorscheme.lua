return {
  {
    "echasnovski/mini.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      -- Generate and apply a random hues colorscheme on startup.
      -- mini.hues creates a coherent 8-color scheme from a background + foreground.
      require("mini.hues").setup({
        background = "#0f0f0f",
        foreground = "#c0c0c0",
      })
      vim.cmd("colorscheme randomhue")
    end,
  },
}
