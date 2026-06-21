return {
  {
    "akinsho/flutter-tools.nvim",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "neovim/nvim-lspconfig",
    },
    config = function()
      local on_attach = function(_, bufnr)
        local map = function(keys, func, desc)
          vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
        end

        map("K", vim.lsp.buf.hover, "Hover documentation")
        map("<C-k>", vim.lsp.buf.signature_help, "Signature help")
        map("<leader>lr", vim.lsp.buf.rename, "Rename")
        map("<leader>la", vim.lsp.buf.code_action, "Code action")
        map("<leader>lj", vim.diagnostic.goto_next, "Next diagnostic")
        map("<leader>lk", vim.diagnostic.goto_prev, "Previous diagnostic")
      end

      require("flutter-tools").setup({
        lsp = {
          on_attach = on_attach,
          capabilities = vim.lsp.protocol.make_client_capabilities(),
          -- dartls ships with the Dart SDK; make sure `dart` or `flutter` is on PATH
        },
        widget_guides = {
          enabled = true,
        },
        closing_tags = {
          highlight = "Comment",
          prefix = "// ",
          enabled = true,
        },
      })
    end,
  },
}
