local M = {}

-- Detect OS (Windows uses backslash in package.config)
local is_windows = package.config:sub(1, 1) == '\\'

-- Get home directory based on OS
local home = is_windows and os.getenv('USERPROFILE') or os.getenv('HOME')

-- Use appropriate path separator
local sep = is_windows and '\\' or '/'

M.bg_blurred_darker = home .. sep .. 'dotfiles' .. sep .. 'wallpapers' .. sep .. 'bg-blurred-darker.png'

return M
