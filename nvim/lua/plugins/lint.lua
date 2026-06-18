return {
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lint = require("lint")

      -- Custom Dart/Flutter linter using `dart analyze`
      lint.linters.dart_analyze = {
        cmd = "dart",
        args = { "analyze", "--fatal-infos" },
        stdin = false,
        stream = "stdout",
        ignore_exitcode = true,
        parser = function(output, bufnr, linter_name)
          local diagnostics = {}
          local pattern = "(%w+) • ([^:]+):(%d+):(%d+) • ([^•]+) • ([^%s]+)"
          for line in output:gmatch("[^\r\n]+") do
            local severity, _file, lnum, col, message, code = line:match(pattern)
            if severity and lnum and col and message then
              table.insert(diagnostics, {
                bufnr = bufnr,
                source = linter_name,
                lnum = tonumber(lnum) - 1,
                col = tonumber(col) - 1,
                end_lnum = tonumber(lnum) - 1,
                end_col = tonumber(col),
                message = vim.trim(message) .. (code and " [" .. code .. "]" or ""),
                severity = severity == "error" and vim.diagnostic.severity.ERROR
                  or severity == "warning" and vim.diagnostic.severity.WARN
                  or severity == "info" and vim.diagnostic.severity.INFO
                  or vim.diagnostic.severity.HINT,
              })
            end
          end
          return diagnostics
        end,
      }

      lint.linters_by_ft = {
        javascript = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        typescript = { "eslint_d" },
        typescriptreact = { "eslint_d" },
        php = { "phpstan" },
        go = { "golangcilint" },
        dart = { "dart_analyze" },
        ruby = { "rubocop" },
        sh = { "shellcheck" },
        bash = { "shellcheck" },
        zsh = { "shellcheck" },
        dockerfile = { "hadolint" },
      }

      -- Trigger lint on save and on insert leave for responsiveness
      local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
      vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
        group = lint_augroup,
        callback = function()
          lint.try_lint()
        end,
      })
    end,
  },
}
