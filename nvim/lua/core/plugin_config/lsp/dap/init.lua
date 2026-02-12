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

-- Detect node path from various version managers
local function get_node_path()
  -- Check for fnm (Fast Node Manager)
  local fnm_check = vim.fn.system("which fnm 2>/dev/null")
  if fnm_check ~= "" then
    local fnm_node = vim.fn.system("fnm which node 2>/dev/null")
    if fnm_node ~= "" then
      return fnm_node:gsub("\n", "")
    end
  end

  -- Check for volta
  local volta_check = vim.fn.system("which volta 2>/dev/null")
  if volta_check ~= "" then
    local volta_node = vim.fn.system("volta which node 2>/dev/null")
    if volta_node ~= "" then
      return volta_node:gsub("\n", "")
    end
  end

  -- Check for nvm
  local nvm_check = vim.fn.system("which nvm 2>/dev/null")
  if nvm_check ~= "" and vim.env.NVM_BIN then
    return vim.env.NVM_BIN .. "/node"
  end

  -- Fallback to system node
  return vim.fn.system("which node 2>/dev/null"):gsub("\n", "")
end

vim.g.dap_nodejs_path = get_node_path()

local dap_config_json = vim.fn.stdpath("config") .. "/dap-config.json"
if vim.fn.filereadable(dap_config_json) == 1 then
  local json = vim.fn.readfile(dap_config_json)
  local dap_configs = vim.fn.json_decode(table.concat(json, "\n"))

  for lang, configs in pairs(dap_configs) do
    dap.configurations[lang] = configs
  end
else
  -- DAP configuration file not found (silently ignore)
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
