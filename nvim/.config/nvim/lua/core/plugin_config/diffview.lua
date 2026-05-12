local setup, diffview = pcall(require, "diffview")
if not setup then
  return
end

diffview.setup({})
