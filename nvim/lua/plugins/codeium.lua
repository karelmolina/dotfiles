-- AI autocompletion via Codeium (virtual-text mode, no nvim-cmp required).
-- Complements mini.completion, which still handles LSP/buffer popup completion.

return {
  {
    "Exafunction/codeium.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    cmd = "Codeium",
    event = "InsertEnter",
    config = function()
      require("codeium").setup({
        -- Use virtual-text suggestions instead of a cmp source.
        enable_cmp_source = false,

        virtual_text = {
          enabled = true,
          -- Allow automatic inline suggestions while typing.
          manual = false,
          default_filetype_enabled = true,
          idle_delay = 75,
          virtual_text_priority = 65535,
          map_keys = true,
          accept_fallback = nil,
          key_bindings = {
            accept = "<Tab>",
            accept_word = false,
            accept_line = false,
            clear = false,
            next = "<M-]>",
            prev = "<M-[>",
          },
        },
      })
    end,
  },
}
