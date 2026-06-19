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
      require("mini.bracketed").setup()
      require("mini.jump2d").setup({
        mappings = {
          -- Avoid shadowing <CR> in neo-tree and other interfaces.
          start_jumping = "<leader>J",
        },
      })
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
      -- Keep trailspace trimming, but don't highlight trailing whitespace in red
      vim.api.nvim_set_hl(0, "MiniTrailspace", {})
      require("mini.hipatterns").setup()

      -- Completion (LSP-aware, falls back to buffer words)
      require("mini.completion").setup({
        mappings = {
          force_twostep = "<C-Space>",
          force_fallback = "<A-Space>",
        },
      })

      -- Disable mini.completion in snacks picker input so results stay visible
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "snacks_picker_input",
        callback = function(args)
          vim.b[args.buf].minicompletion_disable = true
        end,
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
