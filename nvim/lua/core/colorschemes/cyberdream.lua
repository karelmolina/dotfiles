local status, cyberdream = pcall(require, "cyberdream")
if not status then
  return
end

cyberdream.setup({
  variant = "default",
  transparent = false,
  saturation = 1,
  italic_comments = false,
  hide_fillchars = false,
  borderless_pickers = false,
  terminal_colors = true,
  extensions = {
    mini = true,
    notify = true,
    snacks = true,
  },
})
