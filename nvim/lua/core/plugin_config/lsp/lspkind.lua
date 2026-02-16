-- import plugin safely
local setup, lspkind = pcall(require, "lspkind")
if not setup then
  return
end

lspkind.init({
  mode = "symbol",
  symbol_map = {
    Array = "󰅪",
    Boolean = "⊨",
    Class = "󰌗",
    Constructor = "",
    Key = "󰌆",
    Namespace = "󰅪",
    Null = "NULL",
    Number = "#",
    Object = "󰀚",
    Package = "󰏗",
    Property = "",
    Reference = "",
    Snippet = "",
    String = "󰀬",
    TypeParameter = "󰊄",
    Unit = "",
  },
  menu = {},
})
