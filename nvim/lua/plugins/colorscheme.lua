return {
  {
    "scottmckendry/cyberdream.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("cyberdream").setup({
        variant = "default",
        transparent = false,
        saturation = 1,
        italic_comments = false,
        hide_fillchars = false,
        borderless_pickers = false,
        terminal_colors = true,
        extensions = {
          mini = true,
          notify = true,
          snacks = true,
        },
      })
      vim.cmd("colorscheme cyberdream")
    end,
  },
}
