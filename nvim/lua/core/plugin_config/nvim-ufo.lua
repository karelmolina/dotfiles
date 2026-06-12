local setup, ufo = pcall(require, "ufo")

if not setup then
  return
end

ufo.setup({
  provider_selector = function(bufnr, filetype, buftype)
    return { "lsp", "indent" }
  end,
})
