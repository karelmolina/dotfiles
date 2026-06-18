local vault_path = vim.fn.expand("~/Projects/daily-notes")

-- Equivalent to the deprecated `wiki_link_func = "use_alias_only"`.
-- Produces wiki links like `[[Foo Bar]]`.
---@param opts obsidian.link.LinkCreationOpts
---@return string
local wiki_link_alias_only = function(opts)
  local header_or_block = ""
  if opts.anchor then
    header_or_block = string.format("#%s", opts.anchor.header)
  elseif opts.block then
    header_or_block = string.format("#%s", opts.block.id)
  end
  return string.format("[[%s%s]]", opts.label, header_or_block)
end

return {
  {
    "obsidian-nvim/obsidian.nvim",
    version = "*",
    lazy = true,
    ft = "markdown",
    cond = function()
      return vim.fn.isdirectory(vault_path) == 1
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = {
      legacy_commands = false,
      workspaces = {
        {
          name = "daily",
          path = vault_path,
        },
      },
      ui = {
        enable = false, -- let render-markdown.nvim handle UI
      },
      completion = {
        min_chars = 2,
      },
      link = {
        style = wiki_link_alias_only,
      },
      picker = {
        name = "snacks.pick",
      },
      daily_notes = {
        folder = "daily",
        date_format = "%Y/%m/%A-%d",
        default_tags = { "daily" },
        template = "Template, daily.md",
      },
      templates = {
        folder = "templates",
        date_format = "%Y-%m-%d",
        time_format = "%H:%M",
        substitutions = {
          today = function()
            return os.date("%A, %B %d, %Y")
          end,
          yesterdayLink = function()
            local parts = {
              "[[daily/",
              os.date("%Y/%m/%A-%d", os.time() - 86400),
              "|Yesterday]]",
            }
            return table.concat(parts)
          end,
          tomorrowLink = function()
            local parts = {
              "[[daily/",
              os.date("%Y/%m/%A-%d", os.time() + 86400),
              "|Tomorrow]]",
            }
            return table.concat(parts)
          end,
        },
      },
    },
  },
}
