local status, alpha = pcall(require, "alpha")
if not status then
  return
end

local termStatus, alpahTerm = pcall(require, "alpha.term")
if not termStatus then
  return
end

local script_path = vim.fn.stdpath("config") .. "/lua/core/utils/ansi/fine.sh"

local logo = [[
███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
]]
local function getGreeting(name)
  local tableTime = os.date("*t")
  local datetime = os.date(" %Y-%m-%d   %H:%M:%S")
  local hour = tableTime.hour
  local greetingsTable = {
    [1] = "  Sleep well",
    [2] = "  Good morning",
    [3] = "  Good afternoon",
    [4] = "  Good evening",
    [5] = "󰖔  Good night",
  }
  local greetingIndex = 0
  if hour == 23 or hour < 7 then
    greetingIndex = 1
  elseif hour < 12 then
    greetingIndex = 2
  elseif hour >= 12 and hour < 13 then
    greetingIndex = 3
  elseif hour >= 13 and hour < 18 then
    greetingIndex = 3
  elseif hour >= 18 and hour < 21 then
    greetingIndex = 4
  elseif hour >= 21 then
    greetingIndex = 5
  end
  -- return greetingsTable[greetingIndex]
  return "\t" .. datetime .. "\t" .. greetingsTable[greetingIndex] .. ", " .. name
end

local dashboard = require("alpha.themes.dashboard")
local userName = "Karel Molina"
local greeting = getGreeting(userName)
local width = 40
local height = 20

-- dashboard.section.header.val = vim.split(logo .. "\n" .. greeting, "\n")
dashboard.section.header.val = greeting
dashboard.section.header.opts.hl = "DashboardHeader"
dashboard.section.header.opts.position = "center"
dashboard.section.terminal.command = "cat | " .. script_path
dashboard.section.terminal.width = width
dashboard.section.terminal.height = height
dashboard.section.terminal.opts.redraw = true
dashboard.section.buttons.val = {
  dashboard.button("s", " " .. " Restore Session", [[:lua require("persistence").load() <cr>]]),
  dashboard.button("f", " " .. " Recent files", ":lua require('telescope').extensions.recent_files.pick()<CR>"),
  dashboard.button("l", " " .. " Update plugins", ":Lazy<CR>"),
  dashboard.button("q", " " .. " Quit", ":qa<CR>"),
}
dashboard.config.layout = {
  { type = "padding", val = 0 },
  dashboard.section.terminal,
  { type = "padding", val = 5 },
  dashboard.section.header,
  { type = "padding", val = 2 },
  dashboard.section.buttons,
  { type = "padding", val = 1 },
  dashboard.section.footer,
}
-- https://github.com/fredrikaverpil/dotfiles/blob/main/nvim-fredrik/lua/plugins/alpha.lua
alpha.setup(dashboard.config)
