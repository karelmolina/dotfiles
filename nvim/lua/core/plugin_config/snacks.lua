-- Snacks.nvim configuration (image viewer only)

local status_ok, snacks = pcall(require, "snacks")
if not status_ok then
  return
end

snacks.setup({
  image = {
    enabled = true,
  },
})
