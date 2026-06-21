local status, rosepine = pcall(require, "rose-pine")
if not status then
  return
end

rosepine.setup({
  highlight_groups = {
    TelescopeBorder = { fg = "highlight_high", bg = "none" },
    TelescopeNormal = { bg = "none" },
    TelescopePromptNormal = { bg = "base" },
    TelescopeResultsNormal = { fg = "subtle", bg = "none" },
    TelescopeSelection = { fg = "text", bg = "base" },
    TelescopeSelectionCaret = { fg = "rose", bg = "rose" },
    CurSearch = { fg = "base", bg = "leaf", inherit = false },
    Search = { fg = "text", bg = "leaf", blend = 20, inherit = false },
  },
  groups = {
    git_untracked = "#55FF1E",
  }
})
