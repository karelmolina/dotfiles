-- Import lspconfig and other necessary plugins safely
-- local lspconfig_status, lspconfig = pcall(require, "lspconfig")
-- if not lspconfig_status then return end

local lspconfig = vim.lsp.config

local cmp_nvim_lsp_status, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not cmp_nvim_lsp_status then return end

local util_status, util = pcall(require, "lspconfig/util")
if not util_status then return end

-- Enable autocompletion and set up capabilities for every LSP server
local capabilities = cmp_nvim_lsp.default_capabilities()

-- Change the diagnostic symbols in the sign column (gutter)
local signs = { Error = " ", Warn = " ", Hint = "ﴞ ", Info = " " }
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

-- Shared on_attach function (can be reused for all servers)
local on_attach = function(client, bufnr)
    require("core.utils.lsp").on_attach(client, bufnr)
end

-- List of LSP servers to configure
local lsp_servers = {
    html = {},
    cssls = {},
    emmet_ls = {
        filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
    },
    lua_ls = {
        settings = {
            Lua = {
                diagnostics = {
                    globals = { "vim" },
                },
                workspace = {
                    library = {
                        [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                        [vim.fn.stdpath("config") .. "/lua"] = true,
                    },
                },
            },
        },
    },
    ts_ls = {},
    yamlls = {},
    pyright = {},
    jsonls = {},
    bashls = {
        default_config = {
            cmd = { "bash-language-server", "start" },
            filetypes = { "sh", "bash", "zsh" },  -- Added zsh for better matching
        },
    },
    gopls = {
        cmd = { "gopls" },
        filetypes = { "go", "gomod", "gowork", "gotmpl" },
        root_dir = util.root_pattern("go.work", "go.mod", ".git"),
        settings = {
            gopls = {
                completeUnimported = true,
                usePlaceholders = true,
                analyses = {
                    unusedparams = true,
                },
            },
        },
    },
}

-- Loop through all servers and configure them
for server, config in pairs(lsp_servers) do
    lspconfig(server, {
        capabilities = capabilities,
        on_attach = on_attach,
        settings = config.settings,
        filetypes = config.filetypes,
        default_config = config.default_config,
    })
end
