local setup, kulala = pcall(require, "kulala")
if not setup then
  return
end

kulala.setup({
  global_keymaps = false,
  global_keymaps_prefix = "<leader>R",
  kulala_keymaps_prefix = "",
})
