local is_available = require("core.utils").is_available
local set_mappings = require("core.utils").set_mappings
local tbl_contains = vim.tbl_contains
local tbl_isempty = vim.tbl_isempty
local M = {}
local format_opts = {
 filter = function(cl)
  return cl.name ~= "tsserver"
 end,
}

local function extend_tbl(default, opts)
 opts = opts or {}
 return default and vim.tbl_deep_extend("force", default, opts) or opts
end

local function del_buffer_autocmd(augroup, bufnr)
 local cmds_found, cmds = pcall(vim.api.nvim_get_autocmds, { group = augroup, buffer = bufnr })
 if cmds_found then
  vim.tbl_map(function(cmd)
   vim.api.nvim_del_autocmd(cmd.id)
  end, cmds)
 end
end

function M.has_capability(capability, filter)
 for _, client in ipairs(vim.lsp.get_active_clients(filter)) do
  if client.supports_method(capability) then
   return true
  end
 end
 return false
end

local function add_buffer_autocmd(augroup, bufnr, autocmds)
 if not vim.tbl_islist(autocmds) then
  autocmds = { autocmds }
 end
 local cmds_found, cmds = pcall(vim.api.nvim_get_autocmds, { group = augroup, buffer = bufnr })
 if not cmds_found or vim.tbl_isempty(cmds) then
  vim.api.nvim_create_augroup(augroup, { clear = false })
  for _, autocmd in ipairs(autocmds) do
   local events = autocmd.events
   autocmd.events = nil
   autocmd.group = augroup
   autocmd.buffer = bufnr
   vim.api.nvim_create_autocmd(events, autocmd)
  end
 end
end

function M.on_attach(client, bufnr)
 local lsp_maps = {}
 for _, mode in ipairs({ "", "n", "v", "x", "s", "o", "!", "i", "l", "c", "t" }) do
  lsp_maps[mode] = {}
 end

 lsp_maps.n["<leader>ld"] = {
  function()
   vim.diagnostic.open_float()
  end,
  desc = "Hover diagnostics",
 }
 lsp_maps.n["[d"] = {
  function()
   vim.diagnostic.goto_prev()
  end,
  desc = "Previous diagnostic",
 }
 lsp_maps.n["]d"] = {
  function()
   vim.diagnostic.goto_next()
  end,
  desc = "Next diagnostic",
 }
 lsp_maps.n["gl"] = {
  function()
   vim.diagnostic.open_float()
  end,
  desc = "Hover diagnostics",
 }

 if is_available("telescope.nvim") then
  lsp_maps.n["<leader>lD"] = {
   function()
    require("telescope.builtin").diagnostics()
   end,
   desc = "Search diagnostics",
  }
 end

 lsp_maps.n["<leader>la"] = {
  function()
   vim.lsp.buf.code_action()
  end,
  desc = "LSP code action",
 }
 lsp_maps.v["<leader>la"] = lsp_maps.n["<leader>la"]

 lsp_maps.n["gD"] = {
  function()
   vim.lsp.buf.declaration()
  end,
  desc = "Declaration of current symbol",
 }

 lsp_maps.n["gd"] = {
  function()
   vim.lsp.buf.definition()
  end,
  desc = "Show the definition of current symbol",
 }

 lsp_maps.n["<leader>lr"] = {
  function()
   vim.lsp.buf.rename()
  end,
  desc = "Rename current symbol",
 }

 if client.supports_method("textDocument/formatting") then
  lsp_maps.n["<leader>lf"] = {
   function()
    vim.lsp.buf.format(format_opts)
   end,
   desc = "Format buffer",
  }
  lsp_maps.v["<leader>lf"] = lsp_maps.n["<leader>lf"]

  vim.api.nvim_buf_create_user_command(bufnr, "Format", function()
   vim.lsp.buf.format(M.format_opts)
  end, { desc = "Format file with LSP" })
  local autoformat = { enabled = false }
  local filetype = vim.api.nvim_get_option_value("filetype", { buf = bufnr })
  if
   autoformat.enabled
   and (tbl_isempty(autoformat.allow_filetypes or {}) or tbl_contains(autoformat.allow_filetypes, filetype))
   and (
    tbl_isempty(autoformat.ignore_filetypes or {}) or not tbl_contains(
     autoformat.ignore_filetypes,
     filetype
    )
   )
  then
   add_buffer_autocmd("lsp_auto_format", bufnr, {
    events = "BufWritePre",
    desc = "autoformat on save",
    callback = function()
     if not M.has_capability("textDocument/codeLens", { bufnr = bufnr }) then
      del_buffer_autocmd("lsp_auto_format", bufnr)
      return
     end
     local autoformat_enabled = vim.b.autoformat_enabled
     if autoformat_enabled == nil then
      autoformat_enabled = vim.g.autoformat_enabled
     end
     if autoformat_enabled and ((not autoformat.filter) or autoformat.filter(bufnr)) then
      vim.lsp.buf.format(extend_tbl(format_opts, { bufnr = bufnr }))
     end
    end,
   })
  end
 end

 if client.supports_method("textDocument/references") then
  lsp_maps.n["gr"] = {
   function()
    vim.lsp.buf.references()
   end,
   desc = "References of current symbol",
  }
  lsp_maps.n["<leader>lR"] = {
   function()
    vim.lsp.buf.references()
   end,
   desc = "Search references",
  }
 end

 if is_available("telescope.nvim") then -- setup telescope mappings if available
  if lsp_maps.n.gd then
   lsp_maps.n.gd[1] = function()
    require("telescope.builtin").lsp_definitions()
   end
  end
  if lsp_maps.n.gI then
   lsp_maps.n.gI[1] = function()
    require("telescope.builtin").lsp_implementations()
   end
  end
  if lsp_maps.n.gr then
   lsp_maps.n.gr[1] = function()
    require("telescope.builtin").lsp_references()
   end
  end
  if lsp_maps.n["<leader>lR"] then
   lsp_maps.n["<leader>lR"][1] = function()
    require("telescope.builtin").lsp_references()
   end
  end
  if lsp_maps.n.gy then
   lsp_maps.n.gy[1] = function()
    require("telescope.builtin").lsp_type_definitions()
   end
  end
  if lsp_maps.n["<leader>lG"] then
   lsp_maps.n["<leader>lG"][1] = function()
    vim.ui.input({ prompt = "Symbol Query: (leave empty for word under cursor)" }, function(query)
     if query then
      -- word under cursor if given query is empty
      if query == "" then
       query = vim.fn.expand("<cword>")
      end
      require("telescope.builtin").lsp_workspace_symbols({
       query = query,
       prompt_title = ("Find word (%s)"):format(query),
      })
     end
    end)
   end
  end
 end

 set_mappings(lsp_maps)
end

return M
