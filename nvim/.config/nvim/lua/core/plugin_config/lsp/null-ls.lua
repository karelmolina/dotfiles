-- import null-ls plugin safely
local setup, null_ls = pcall(require, "null-ls")
if not setup then
  return
end

-- Optional: none-ls-extras builtins
local eslint_diag
local ok_extra_diag, extra_diag = pcall(require, "none-ls.diagnostics.eslint")
if ok_extra_diag then
  eslint_diag = extra_diag
end

local eslint_fmt
local ok_extra_fmt, extra_fmt = pcall(require, "none-ls.formatting.eslint")
if ok_extra_fmt then
  eslint_fmt = extra_fmt
end

-- Optional: none-ls-shellcheck builtins
local shellcheck_diag
local ok_shellcheck_diag, shellcheck_diag_mod = pcall(require, "none-ls-shellcheck.diagnostics")
if ok_shellcheck_diag then
  shellcheck_diag = shellcheck_diag_mod
end

local shellcheck_actions
local ok_shellcheck_actions, shellcheck_actions_mod = pcall(require, "none-ls-shellcheck.code_actions")
if ok_shellcheck_actions then
  shellcheck_actions = shellcheck_actions_mod
end

-- for conciseness
local formatting = null_ls.builtins.formatting -- to setup formatters
local diagnostics = null_ls.builtins.diagnostics -- to setup linters

-- enable keybinds only for when lsp server available
local on_attach = function(client, bufnr)
  require("core.utils.lsp").on_attach(client, bufnr)
end

-- Build sources table dynamically
local sources = {
  formatting.stylua, -- lua formatter
  formatting.erb_lint,
  diagnostics.erb_lint,
  diagnostics.hadolint,
  diagnostics.rubocop,
  formatting.gofumpt,
  formatting.goimports_reviser,
  formatting.golines,
  formatting.pint,
  formatting.blade_formatter,
}

if eslint_diag then
  table.insert(sources, eslint_diag.with({
    condition = function(utils)
      return utils.root_has_file(".eslintrc.json")
    end,
  }))
end

if eslint_fmt then
  table.insert(sources, eslint_fmt)
end

if shellcheck_diag then
  table.insert(sources, shellcheck_diag)
end

if shellcheck_actions then
  table.insert(sources, shellcheck_actions)
end

-- configure null_ls
null_ls.setup({
  debug = true,
  sources = sources,
  on_attach = on_attach,
})
