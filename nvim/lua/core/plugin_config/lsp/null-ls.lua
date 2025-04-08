-- import null-ls plugin safely
local setup, null_ls = pcall(require, "null-ls")
if not setup then
  return
end

local nonelsSetup, none_ls = pcall(require, "none-ls")
if not nonelsSetup then
  return
end

local setupShellCheck, noneLsShellcheck = pcall(require, "none-ls-shellcheck")
if not setupShellCheck then
  return
end

-- for conciseness
local formatting = null_ls.builtins.formatting   -- to setup formatters
local diagnostics = null_ls.builtins.diagnostics -- to setup linters
local diagnostics_extra = none_ls.diagnostics
local formatting_extra = none_ls.formatters

-- enable keybinds only for when lsp server available
local on_attach = function(client, bufnr)
  require("core.utils.lsp").on_attach(client, bufnr)
end

-- configure null_ls
null_ls.setup({
  debug = true,
  -- setup formatters & linters
  sources = {
    --  to disable file types use
    --  "formatting.prettier.with({disabled_filetypes = {}})" (see null-ls docs)
    -- js/ts formatter
    -- formatting.prettierd.with({
    --   env = {
    --     PRETTIERD_DEFAULT_CONFIG = vim.fn.expand("~/.prettierrc"),
    --   },
    -- }),
    formatting.stylua, -- lua formatter
    formatting.erb_lint,
    diagnostics_extra.eslint.with({
      -- js/ts linter
      -- only enable eslint if root has .eslintrc.js
      condition = function(utils)
        return utils.root_has_file(".eslintrc.json") -- change file extension if you use something else
      end,
    }),
    formatting_extra.eslint,
    diagnostics.erb_lint,
    diagnostics.hadolint,
    diagnostics.rubocop,
    -- diagnostics_extra.tsc,
    formatting.gofumpt,
    formatting.goimports_reviser,
    formatting.golines,
    noneLsShellcheck.diagnostics,
    noneLsShellcheck.code_actions,
  },
  on_attach = on_attach,
})
