return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "echasnovski/mini.nvim",
    },
    ft = { "markdown" },
    opts = {
      -- Neovim 0.12 compatibility: disable nested markdown rendering and custom
      -- injections to avoid treesitter query predicate errors on code blocks.
      nested = false,
      injections = {},
      checkbox = {
        enabled = true,
        bullet = false,
        right_pad = 1,
        unchecked = {
          icon = "󰄱 ",
          highlight = "RenderMarkdownUnchecked",
          scope_highlight = nil,
        },
        checked = {
          icon = "󰱒 ",
          highlight = "RenderMarkdownChecked",
          scope_highlight = nil,
        },
        custom = {
          todo = { raw = "[t]", rendered = "󰥔 ", highlight = "RenderMarkdownTodo", scope_highlight = nil },
          incomplete = { raw = "[/]", rendered = "", highlight = "RenderMarkdownIncomplete", scope_highlight = nil },
          schedule = { raw = "[>]", rendered = "", highlight = "RenderMarkdownSchedule", scope_highlight = nil },
          cancelled = { raw = "[-]", rendered = "", highlight = "RenderMarkdownCancelled", scope_highlight = nil },
          note = { raw = "[n]", rendered = "", highlight = "RenderMarkdownNote", scope_highlight = nil },
        },
      },
    },
  },
}
