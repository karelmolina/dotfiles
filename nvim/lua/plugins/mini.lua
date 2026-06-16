return {
  {
    "echasnovski/mini.nvim",
    version = false,
    config = function()
      -- Icons used by several other modules
      require("mini.icons").setup()
      require("mini.icons").mock_nvim_web_devicons()

      -- UI chrome
      require("mini.statusline").setup()
      require("mini.tabline").setup()
      require("mini.notify").setup()
      require("mini.starter").setup()

      -- Editing helpers
      require("mini.pairs").setup()
      require("mini.surround").setup()
      require("mini.comment").setup()
      require("mini.operators").setup()

      -- Navigation
      require("mini.files").setup()
      require("mini.pick").setup()
      require("mini.bracketed").setup()
      require("mini.jump2d").setup()
      require("mini.move").setup()

      -- Git / diff
      require("mini.diff").setup()
      require("mini.git").setup()

      -- Visual cues
      require("mini.cursorword").setup()
      require("mini.indentscope").setup()
      require("mini.trailspace").setup()
      require("mini.hipatterns").setup()

      -- Completion (LSP-aware, falls back to buffer words)
      require("mini.completion").setup()

      -- Sessions
      require("mini.sessions").setup()

      -- Keymap clues (which-key style)
      require("mini.clue").setup({
        triggers = {
          { mode = "n", keys = "<Leader>" },
          { mode = "x", keys = "<Leader>" },
          { mode = "n", keys = "g" },
          { mode = "x", keys = "g" },
          { mode = "n", keys = "[" },
          { mode = "n", keys = "]" },
          { mode = "n", keys = "<C-w>" },
        },
        clues = {
          require("mini.clue").gen_clues.builtin_completion(),
          require("mini.clue").gen_clues.g(),
          require("mini.clue").gen_clues.marks(),
          require("mini.clue").gen_clues.registers(),
          require("mini.clue").gen_clues.windows(),
          require("mini.clue").gen_clues.z(),
        },
      })
    end,
  },
}
