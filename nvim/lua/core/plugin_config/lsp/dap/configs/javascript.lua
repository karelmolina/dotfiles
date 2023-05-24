require("dap-vscode-js").setup({
	debugger_cmd = { "js-debug-adapter" },
	adapters = { "pwa-node", "pwa-chrome", "node-terminal" },
})

for _, language in ipairs({ "javascript", "typescript" }) do
	require("dap").configurations[language] = {
		{
			type = "pwa-node",
			request = "launch",
			name = "Launch file",
			program = "${file}",
			cwd = "${workspaceFolder}",
		},
		{
			type = "pwa-node",
			request = "attach",
			name = "Attach",
			processId = require("dap.utils").pick_process,
			cwd = "${workspaceFolder}",
		},
		{
			type = "node-terminal",
			request = "launch",
			name = "Launch file",
            command = "ts-node -r tsconfig-paths/register ${file}",
			program = "${file}",
			cwd = "${workspaceFolder}",
		},
	}
end
