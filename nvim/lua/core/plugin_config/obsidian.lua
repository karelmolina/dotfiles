local status_ok, obsidian = pcall(require, "obsidian")
if not status_ok then
  return
end

obsidian.setup {
  workspaces = {
    {
      name = "daily",
      path = "~/Projects/daily-tasks",
    },
  },
  ui = {
    enable = false,
  },
  completion = {
    nvim_cmp = true,
    min_chars = 2,
  },
  -- disable_frontmatter = true,
  picker = {
    name = "telescope.nvim",
  },
  -- daily notes
  daily_notes = {
    folder = "daily",
    date_format = "%Y/%m/%A-%d",
    default_tags = { "daily" },
    template = "Template, daily.md"
  },
  -- templates
  templates = {
    folder = "templates",
    date_format = "%Y-%m-%d",
    time_format = "%H:%M",
    substitutions = {
      today = function() return os.date("%A, %B %d, %Y") end,
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
    }
  },
  wiki_link_func = "use_alias_only", -- [[Note]] -> pretty alias
}
