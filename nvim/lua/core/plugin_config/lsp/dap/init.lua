local status, dap = pcall(require, "dap")
if not status then
  return
end

local uistatus, dapui = pcall(require, "dapui")
if not uistatus then
  return
end

local pythondapstatus, dap_python = pcall(require, "dap-python")

if not pythondapstatus then
  return
end

local utilsStatus, utils = pcall(require, "core.utils")

if not utilsStatus then
  return
end


-- mkdir .virtualenvs
-- cd .virtualenvs
-- python -m venv debugpy
-- debugpy/bin/python -m pip install debugpy
dap_python.setup("~/.virtualenvs/debugpy/bin/python")

vim.g.dap_nodejs_path = vim.fn.system("volta which node"):gsub("\n", "")

local dap_config_json = vim.fn.stdpath("config") .. "/dap-config.json"
if vim.fn.filereadable(dap_config_json) == 1 then
  local json = vim.fn.readfile(dap_config_json)
  local dap_configs = vim.fn.json_decode(table.concat(json, "\n"))

  for lang, configs in pairs(dap_configs) do
    dap.configurations[lang] = configs
  end
else
  print("DAP configuration file not found: " .. dap_config_json)
end

-- Signs
vim.fn.sign_define("DapBreakpoint", { text = "🐞", texthl = "", linehl = "", numhl = "" })
vim.fn.sign_define("DapStopped", { text = "▶️", texthl = "", linehl = "", numhl = "" })
vim.fn.sign_define("DapBreakpointRejected", { text = "🚫", texthl = "", linehl = "", numhl = "" })
vim.fn.sign_define("DapBreakpointCondition", { text = "❓", texthl = "", linehl = "", numhl = "" })
vim.fn.sign_define("DapLogPoint", { text = "💬", texthl = "", linehl = "", numhl = "" })

-- fix related to https://github.com/mxsdev/nvim-dap-vscode-js/issues/58
-- error when using nvim-dap-vscode-js ** its not needed anymore **
-- workaround is configure manually
dap.adapters['pwa-node'] = {
  type = 'server',
  host = 'localhost',
  port = '${port}',
  executable = {
    command = 'node',
    args = {
      utils.get_pkg_path('js-debug-adapter', '/js-debug/src/dapDebugServer.js'),
      '${port}',
    },
  },
}

dapui.setup({
  floating = { border = "rounded" },
  icons = { expanded = "▾", collapsed = "▸" },
  layouts = {
    {
      elements = {
        "scopes",
        "breakpoints",
        "stacks",
        "watches",
      },
      size = 80,
      position = "right",
    },
    {
      elements = {
        "repl",
        "console",
      },
      size = 10,
      position = "bottom",
    },
  },
})

dapui.setup({
  floating = { border = "rounded" },
  controls = {
    icons = {
      disconnect = "*️⃣",
      pause = "⏸️",
      play = "▶️",
      run_last = "↪️",
      step_back = "⬅️",
      step_into = "⬇️",
      step_out = "⤴️",
      step_over = "⤵️",
      terminate = "⏹️",
    },
  },
  layouts = {
    {
      elements = {
        {
          id = "breakpoints",
          size = 0.25,
        },
        {
          id = "scopes",
          size = 0.25,
        },
        {
          id = "stacks",
          size = 0.25,
        },
        {
          id = "watches",
          size = 0.25,
        },
      },
      position = "left",
      size = 40,
    },
    -- {
    --   elements = { {
    --     id = "repl",
    --     size = 1,
    --   } },
    --   position = "bottom",
    --   size = 6,
    -- },
    {
      elements = { {
        id = "console",
        size = 1,
      } },
      position = "right",
      size = 60,
    },
  },
})

dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
