-- Import lspconfig and other necessary plugins safely
-- local lspconfig_status, lspconfig = pcall(require, "lspconfig")
-- if not lspconfig_status then return end

local lspconfig = vim.lsp.config

local cmp_nvim_lsp_status, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not cmp_nvim_lsp_status then
  return
end

local util_status, util = pcall(require, "lspconfig/util")
if not util_status then
  return
end

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
  vtsls = {
    settings = {
      typescript = {
        tsserver = {
          maxTsServerMemory = 3072, -- 3GB for larger projects
        },
        preferences = {
          -- Disable auto-import suggestions (saves RAM)
          includePackageJsonAutoImports = "off",
        },
      },
      javascript = {
        tsserver = {
          maxTsServerMemory = 3072,
        },
        preferences = {
          includePackageJsonAutoImports = "off",
        },
      },
      vtsls = {
        experimental = {
          -- Disable completion for node_modules (huge RAM saver)
          completion = {
            enableServerSideFuzzyMatch = true,
          },
        },
      },
    },
    -- Don't watch node_modules (major RAM saver)
    init_options = {
      hostInfo = "neovim",
      preferences = {
        includePackageJsonAutoImports = "off",
      },
    },
  },
  yamlls = {
    settings = {
      yaml = {
        schemas = {
          -- Disable all broken schemas from lalcebo/json-schema repository
          -- These schemas are no longer available and cause errors
          ["https://raw.githubusercontent.com/lalcebo/json-schema/master/serverless/resources/cloudformation-modified/*.json"] = "!serverless.yml",
        },
        schemaStore = {
          enable = true,
          url = "https://www.schemastore.org/api/json/catalog.json",
        },
        validate = true,
        completion = true,
        hover = true,
      },
    },
  },
  pyright = {},
  jsonls = {},
  bashls = {
    default_config = {
      cmd = { "bash-language-server", "start" },
      filetypes = { "sh", "bash", "zsh" }, -- Added zsh for better matching
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
  harper_ls = {
    filetypes = { "markdown", "html", "javascript", "json", "http" },
  },
}

-- Track LSP clients per buffer for cleanup
local lsp_clients_by_buffer = {}

-- Enhanced on_attach with buffer tracking
local function enhanced_on_attach(client, bufnr)
  on_attach(client, bufnr)
  
  -- Track this client for this buffer
  if not lsp_clients_by_buffer[bufnr] then
    lsp_clients_by_buffer[bufnr] = {}
  end
  lsp_clients_by_buffer[bufnr][client.id] = client
  
  -- Set up autocmd to detach LSP when buffer is hidden for too long
  vim.api.nvim_create_autocmd("BufHidden", {
    buffer = bufnr,
    callback = function()
      -- Schedule LSP detach after 5 minutes of being hidden
      vim.defer_fn(function()
        if vim.api.nvim_buf_is_valid(bufnr) then
          local is_visible = vim.fn.bufwinnr(bufnr) ~= -1
          if not is_visible then
            -- Stop LSP clients for this buffer
            for client_id, _ in pairs(lsp_clients_by_buffer[bufnr] or {}) do
              local client = vim.lsp.get_client_by_id(client_id)
              if client then
                -- Check if client is used by other buffers
                local other_buffers = false
                for other_bufnr, clients in pairs(lsp_clients_by_buffer) do
                  if other_bufnr ~= bufnr and clients[client_id] then
                    other_buffers = true
                    break
                  end
                end
                -- Only stop if not used by other buffers
                if not other_buffers then
                  vim.lsp.stop_client(client_id, true)
                end
              end
            end
            lsp_clients_by_buffer[bufnr] = nil
          end
        end
      end, 5 * 60 * 1000) -- 5 minutes
    end,
  })
end

-- Loop through all servers and configure them
for server, config in pairs(lsp_servers) do
  lspconfig(server, {
    capabilities = capabilities,
    on_attach = enhanced_on_attach,
    settings = config.settings,
    filetypes = config.filetypes,
    default_config = config.default_config,
    -- Reduce LSP overhead
    flags = {
      debounce_text_changes = 300, -- Increase debounce to reduce updates
      allow_incremental_sync = true,
    },
  })
end

-- Clean up LSP tracking on buffer delete
vim.api.nvim_create_autocmd("BufDelete", {
  pattern = "*",
  callback = function(args)
    lsp_clients_by_buffer[args.buf] = nil
  end,
})
