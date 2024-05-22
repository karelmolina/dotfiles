local status, dap = pcall(require, "dap")
if not status then
  return
end

local uistatus, dapui = pcall(require, "dapui")
if not uistatus then
  return
end

local vscodeStatus, dap_vscode = pcall(require, "dap-vscode-js")
if not vscodeStatus then
  return
end

dap_vscode.setup({
  node_path = "node",
  debugger_path = os.getenv("HOME") .. "/.DAP/vscode-js-debug",
  adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" },
})

vim.g.dap_nodejs_path = vim.fn.system("volta which node"):gsub("\n", "")

local exts = {
  "javascript",
  "typescript",
  "javascriptreact",
  "typescriptreact",
}

for i, ext in ipairs(exts) do
  dap.configurations[ext] = {
    {
      type = "pwa-node",
      request = "launch",
      name = "Launch Current File with tsconfig-path with deployment",
      cwd = vim.fn.getcwd(),
      runtimeArgs = { "-r", "tsconfig-paths/register" },
      runtimeExecutable = "ts-node",
      args = { "${file}" },
      sourceMaps = true,
      protocol = "inspector",
      skipFiles = { "<node_internals>/**", "node_modules/**" },
      resolveSourceMapLocations = {
        "${workspaceFolder}/**",
        "!**/node_modules/**",
      },
      env = {
        FZ_NODE_ENV = "local",
      },
    },
    {
      type = "pwa-node",
      request = "launch",
      name = "Launch Current File with tsconfig-path",
      cwd = vim.fn.getcwd(),
      runtimeArgs = { "-r", "tsconfig-paths/register" },
      runtimeExecutable = "ts-node",
      args = { "${file}" },
      sourceMaps = true,
      protocol = "inspector",
      skipFiles = { "<node_internals>/**", "node_modules/**" },
      resolveSourceMapLocations = {
        "${workspaceFolder}/**",
        "!**/node_modules/**",
      },
      env = {
        FZ_NODE_ENV = "local",
      },
    },
    {
      type = "pwa-node",
      request = "launch",
      name = "Launch Current File (pwa-node with node)",
      cwd = vim.fn.getcwd(),
      runtimeArgs = { },
      runtimeExecutable = "node",
      args = { "${file}" },
      sourceMaps = true,
      protocol = "inspector",
      console = "integratedTerminal",
      skipFiles = { "<node_internals>/**", "node_modules/**" },
      resolveSourceMapLocations = {
        "${workspaceFolder}/**",
        "!**/node_modules/**",
      },
    },
    {
      type = "pwa-node",
      request = "launch",
      name = "Launch Test Current File (pwa-node with jest)",
      cwd = vim.fn.getcwd(),
      runtimeArgs = { "${workspaceFolder}/node_modules/.bin/jest" },
      runtimeExecutable = "node",
      args = { "${file}", "--coverage", "false" },
      rootPath = "${workspaceFolder}",
      sourceMaps = true,
      console = "integratedTerminal",
      internalConsoleOptions = "neverOpen",
      skipFiles = { "<node_internals>/**", "node_modules/**" },
    },
    {
      type = "pwa-node",
      request = "launch",
      name = "Launch Test Current File (pwa-node with vitest)",
      cwd = vim.fn.getcwd(),
      program = "${workspaceFolder}/node_modules/vitest/vitest.mjs",
      args = { "--inspect-brk", "--threads", "false", "run", "${file}" },
      autoAttachChildProcesses = true,
      smartStep = true,
      console = "integratedTerminal",
      skipFiles = { "<node_internals>/**", "node_modules/**" },
    },
    {
        type = 'node2',
        request = 'launch',
        name = 'Launch Command',
        program = '${file}',
        cwd = vim.fn.getcwd(),
        sourceMaps = true,
        protocol = 'inspector',
        skipFiles = {'<node_internals>/**/*.js'},
    },
  }
end

-- Signs
vim.fn.sign_define("DapBreakpoint", { text = "🐞", texthl = "", linehl = "", numhl = "" })
vim.fn.sign_define("DapStopped", { text = "▶️", texthl = "", linehl = "", numhl = "" })
vim.fn.sign_define("DapBreakpointRejected", { text = "🚫", texthl = "", linehl = "", numhl = "" })
vim.fn.sign_define("DapBreakpointCondition", { text = "❓", texthl = "", linehl = "", numhl = "" })
vim.fn.sign_define("DapLogPoint", { text = "💬", texthl = "", linehl = "", numhl = "" })

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
    {
      elements = { {
        id = "repl",
        size = 1,
      } },
      position = "bottom",
      size = 6,
    },
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
