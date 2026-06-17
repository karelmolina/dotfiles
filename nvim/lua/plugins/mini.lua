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

      -- Buffers
      require("mini.bufremove").setup()

      -- Editing helpers
      require("mini.pairs").setup()
      require("mini.surround").setup()
      require("mini.comment").setup()
      require("mini.operators").setup()

      -- Navigation
      require("mini.files").setup({
        mappings = {
          close = "q",
          go_in = "l",
          go_in_plus = "L",
          go_out = "h",
          go_out_plus = "H",
          reset = "<BS>",
          reveal_cwd = "@",
          show_help = "g?",
          synchronize = "=",
          trim_left = "<",
          trim_right = ">",
        },
        windows = {
          max_number = math.huge,
          preview = true,
          width_focus = 30,
          width_nofocus = 15,
          width_preview = 40,
        },
      })
      require("mini.bracketed").setup()
      require("mini.jump2d").setup()
      require("mini.move").setup({
        mappings = {
          left = "",
          right = "",
          down = "<leader>j",
          up = "<leader>k",
          line_left = "",
          line_right = "",
          line_down = "<leader>j",
          line_up = "<leader>k",
        },
      })

      -- Git / diff
      require("mini.diff").setup({
        view = {
          style = "sign",
          signs = { add = "+", change = "~", delete = "-" },
        },
      })
      require("mini.git").setup()

      -- Visual cues
      require("mini.indentscope").setup()
      require("mini.trailspace").setup()
      require("mini.hipatterns").setup()

      -- Completion (LSP-aware, falls back to buffer words)
      require("mini.completion").setup({
        mappings = {
          force_twostep = "<C-Space>",
          force_fallback = "<A-Space>",
        },
      })

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
