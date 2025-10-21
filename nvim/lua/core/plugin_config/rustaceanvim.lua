local status, rustaceanvim = pcall(require, "rustaceanvim")
if not status then
  return
end

-- Shared on_attach function (can be reused for all servers)
local on_attach = function(client, bufnr)
    require("core.utils.lsp").on_attach(client, bufnr)
end

vim.g.rustaceanvim = {
  -- Plugin configuration
  tools = {
  },
  -- LSP configuration
  server = {
    on_attach = on_attach,
    default_settings = {
      -- rust-analyzer language server configuration
      ['rust-analyzer'] = {
      },
    },
  },
  -- DAP configuration
  dap = {
  },
}
