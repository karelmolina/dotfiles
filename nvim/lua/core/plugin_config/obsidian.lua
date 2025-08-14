local status_ok, obsidian = pcall(require, "obsidian")
if not status_ok then
  return
end

obsidian.setup {
  workspaces = {
    { name = "daily", path = "~/Projects/daily-tasks" },
    -- { name = "personal", path = "~/Projects/personal" }
  },
  daily_notes = {
    folder = "daily",
    date_format = "%Y/%M/%BB-%dd",
    default_tags = { "daily" },
    template = {
      folder = "templates",
    }
  }
}
