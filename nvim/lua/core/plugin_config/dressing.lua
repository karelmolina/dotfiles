-- import plugin safely
local setup, dressing = pcall(require, "dressing")
if not setup then
  return
end

dressing.setup({
  input = { default_prompt = "➤ " },
  select = { backend = { "telescope", "builtin" } },
})
