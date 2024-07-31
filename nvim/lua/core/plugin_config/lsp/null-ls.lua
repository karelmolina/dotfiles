-- import null-ls plugin safely
local setup, null_ls = pcall(require, "null-ls")
if not setup then
 return
end

-- for conciseness
local formatting = null_ls.builtins.formatting -- to setup formatters
local diagnostics = null_ls.builtins.diagnostics -- to setup linters

-- enable keybinds only for when lsp server available
local on_attach = function (client, bufr)
 require("core.utils.lsp").on_attach(client, bufr)
end

-- configure null_ls
null_ls.setup({
 -- setup formatters & linters
 sources = {
  --  to disable file types use
  --  "formatting.prettier.with({disabled_filetypes = {}})" (see null-ls docs)
  -- js/ts formatter
  formatting.prettierd.with({
   env = {
    PRETTIERD_DEFAULT_CONFIG = vim.fn.expand("~/.prettierrc"),
   },
  }),
  formatting.stylua, -- lua formatter
  formatting.erb_lint,
  diagnostics.eslint_d.with({
   -- js/ts linter
   -- only enable eslint if root has .eslintrc.js
   condition = function(utils)
    return utils.root_has_file(".eslintrc.json") -- change file extension if you use something else
   end,
  }),
  diagnostics.erb_lint,
  diagnostics.hadolint,
  diagnostics.rubocop,
  diagnostics.tsc,
  null_ls.builtins.formatting.gofumpt,
  null_ls.builtins.formatting.goimports_reviser,
  null_ls.builtins.formatting.golines,
 },
 on_attach = on_attach,
})
