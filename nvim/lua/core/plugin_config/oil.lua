local status, oil = pcall(require, "oil")
if not status then
  return
end

oil.setup({
  default_file_explorer = false,
  view_options = {
    show_hidden = true,
  },
})
