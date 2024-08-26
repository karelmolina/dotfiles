local util = require("core.utils")
local is_available = util.is_available
local icons = require("core.utils.icons")
local wk = require("which-key")

-- Standard Operations
wk.add({
  { "j", "v:count == 0 ? 'gj' : 'j'", mode = { "n", "v" }, expr = true, desc = "Move cursor down" },
  { "k", "v:count == 0 ? 'gk' : 'k'", mode = { "n", "v" }, expr = true, desc = "Move cursor up" },
  { "<leader>w", "<cmd>w<cr>", desc = "Save", mode = "n" },
  { "<leader>q", "<cmd>confirm q<cr>", desc = "Quit", mode = "n" },
  { "<leader>n", "<cmd>enew<cr>", desc = "New File", mode = "n" },
  { "<C-s>", "<cmd>w!<cr>", desc = "Force write", mode = "n" },
  { "<C-q>", "<cmd>qa!<cr>", desc = "Force quit", mode = "n" },
  { "|", "<cmd>vsplit<cr>", desc = "Vertical Split", mode = "n" },
  { "-", "<cmd>split<cr>", desc = "Horizontal Split", mode = "n" },
  { "<leader>+", "<C-a>", desc = "Increase number", mode = "n" },
  { "<leader>-", "<C-x>", desc = "Decrease number", mode = "n" },
  { "<leader>h", "<cmd>nohlsearch<cr>", desc = "No Highlight", mode = "n" },
  { "<leader>k", ":m .-2<cr>==", desc = "Move line up", mode = "n" },
  { "<leader>j", ":m .+1<cr>==", desc = "Move line down", mode = "n" },
  { "<leader>k", ":m <-2<cr>==gv", desc = "Move line up", mode = "v" },
  { "<leader>j", ":m '>+1<cr>==gv", desc = "Move line down", mode = "v" },
})

-- Plugin Manager
wk.add({
  mode = { "n" },
  { "<leader>p", group = "Plugin Manager" },
  {
    "<leader>pi",
    function()
      require("lazy").install()
    end,
    desc = "Install Plugins",
  },
  {
    "<leader>ps",
    function()
      require("lazy").home()
    end,
    desc = "Plugin Status",
  },
  {
    "<leader>pS",
    function()
      require("lazy").sync()
    end,
    desc = "Plugins Sync",
  },
  {
    "<leader>pu",
    function()
      require("lazy").check()
    end,
    desc = "Plugins check update",
  },
  {
    "<leader>pU",
    function()
      require("lazy").update()
    end,
    desc = "Plugins update",
  },
  {
    "<leader>pa",
    "<cmd>UpdateAllPackages<cr>",
    desc = "Update Plugins and Mason Packages",
  }
})

-- Navigate Tabs
wk.add({
  {"[t", function() vim.cmd.tabprevious() end, desc = "Previous Tab", mode = "n" },
  {"]t", function() vim.cmd.tabnext() end, desc = "Next Tab", mode = "n" },
  {"]nt", function() vim.cmd.tabnew() end, desc = "New Tab", mode = "n" },
})

-- Comment Mappings
if is_available("Comment.nvim") then
  wk.add({
    { "<leader>/", function() require("Comment.api").toggle.linewise.count(vim.v.count > 0 and vim.v.count or 1) end, desc = "Toggle comment line", mode = "n" },
    { "<leader>/", "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>", desc = "Toggle comment for selection", mode = "v" },
  })
end

-- GitSigns Mappings
if is_available("gitsigns.nvim") then
  wk.add({
    { "<leader>g", group = "Git" },
    { "]g", function() require("gitsigns").next_hunk() end, desc = "Next Git hunk", mode = "n" },
    { "[g", function() require("gitsigns").prev_hunk() end, desc = "Previous Git hunk", mode = "n" },
    {
      "<leader>gl",
      function()
        require("gitsigns").blame_line({ full = true })
      end,
      desc = "Blame line",
      mode = "n",
    },
    {
      "<leader>gL",
      function()
        require("gitsigns").blame_line({ full = true })
      end,
      desc = "Blame line",
      mode = "n",
    },
    {
      "<leader>gp",
      function()
        require("gitsigns").preview_hunk()
      end,
      desc = "Preview Git hunk",
      mode = "n",
    },
    {
      "<leader>gh",
      function()
        require("gitsigns").reset_hunk()
      end,
      desc = "Reset Git hunk",
      mode = "n",
    },
    {
      "<leader>gR",
      function()
        require("gitsigns").reset_buffer()
      end,
      desc = "Reset buffer",
      mode = "n",
    },
    {
      "<leader>gs",
      function()
        require("gitsigns").stage_hunk()
      end,
      desc = "Stage Git hunk",
      mode = "n",
    },
    {
      "<leader>gS",
      function()
        require("gitsigns").stage_buffer()
      end,
      desc = "Stage buffer",
      mode = "n",
    },
    {
      "<leader>gu",
      function()
        require("gitsigns").undo_stage_hunk()
      end,
      desc = "Undo stage Git hunk",
      mode = "n",
    },
    {
      "<leader>gd",
      function()
        require("gitsigns").diffthis()
      end,
      desc = "Diff",
      mode = "n",
    },
    {
      "<leader>gB",
      function()
        require("gitsigns").toggle_current_line_blame()
      end,
      desc = "Toggle git Blame",
      mode = "n",
    },
  })
end

-- NeoTree Mappings
if is_available("neo-tree.nvim") then
  wk.add({
    { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "Toggle Explorer", mode = "n" },
    { "<leader>o", function()
        if vim.bo.filetype == "neo-tree" then
          vim.cmd.wincmd("p")
        else
          vim.cmd.Neotree("focus")
        end
      end, desc = "Toggle Explorer Focus", mode = "n" },
  })
end

-- Mason Mappings
if is_available("mason.nvim") then
  wk.add({
    { "<leader>pm", "<cmd>Mason<cr>", desc = "Mason Installer", mode = "n" },
    { "<leader>pM", "<cmd>MasonUpdateAll<cr>", desc = "Mason Update", mode = "n" },
  })
end

-- SymbolsOutline (Aerial) Mappings
if is_available("aerial.nvim") then
  wk.add({
    { "<leader>l", group = "LSP" },
    { "<leader>lS", function() require("aerial").toggle() end, desc = "Symbols outline", mode = "n" },
  })
end

-- Telescope Mappings
if is_available("telescope.nvim") then
  wk.add({
    mode = { "n" },
    { "<leader>f", group = icons.Search .. "Find" },
    { "<leader>g", group = "Git" },
    {
      "<leader>gb",
      function()
        require("telescope.builtin").git_branches({ use_file_path = true })
      end,
      desc = "Git branches",
    },
    {
      "<leader>gc",
      function()
        require("telescope.builtin").git_commits({ use_file_path = true })
      end,
      desc = "Git commits",
    },
    {
      "<leader>gC",
      function()
        require("telescope.builtin").git_bcommits({ use_file_path = true })
      end,
      desc = "Git buffer commits",
    },
    {
      "<leader>gt",
      function()
        require("telescope.builtin").git_status({ use_file_path = true })
      end,
      desc = "Git status",
    },
    {
      "<leader>f<CR>",
      function()
        require("telescope.builtin").resume()
      end,
      desc = "Resume search",
    },
    {
      "<leader>f'",
      function()
        require("telescope.builtin").marks()
      end,
      desc = "Find marks",
    },
    {
      "<leader>f/",
      function()
        require("telescope.builtin").current_buffer_fuzzy_find()
      end,
      desc = "Find words in current buffer",
    },
    {
      "<leader>fb",
      function()
        require("telescope.builtin").buffers()
      end,
      desc = "Find buffers",
    },
    {
      "<leader>fc",
      function()
        require("telescope.builtin").grep_string()
      end,
      desc = "Find word under cursor",
    },
    {
      "<leader>fC",
      function()
        require("telescope.builtin").commands()
      end,
      desc = "Find commands",
    },
    {
      "<leader>ff",
      function()
        require("telescope.builtin").find_files()
      end,
      desc = "Find files",
    },
    {
      "<leader>fF",
      function()
        require("telescope.builtin").find_files({ hidden = true, no_ignore = true })
      end,
      desc = "Find all files",
    },
    {
      "<leader>fh",
      function()
        require("telescope.builtin").help_tags()
      end,
      desc = "Find help",
    },
    {
      "<leader>fk",
      function()
        require("telescope.builtin").keymaps()
      end,
      desc = "Find keymaps",
    },
    {
      "<leader>fm",
      function()
        require("telescope.builtin").man_pages()
      end,
      desc = "Find man",
    },
    {
      "<leader>fo",
      function()
        require("telescope.builtin").oldfiles()
      end,
      desc = "Find history",
    },
    {
      "<leader>fr",
      function()
        require("telescope.builtin").registers()
      end,
      desc = "Find registers",
    },
    {
      "<leader>ft",
      function()
        require("telescope.builtin").colorscheme({ enable_preview = true })
      end,
      desc = "Find themes",
    },
    {
      "<leader>fw",
      function()
        require("telescope.builtin").live_grep()
      end,
      desc = "Find words",
    },
    {
      "<leader>fW",
      function()
        require("telescope.builtin").live_grep({
          additional_args = function(args)
            return vim.list_extend(args, { "--hidden", "--no-ignore" })
          end,
        })
      end,
      desc = "Find words in all files",
    },
    {
      "<leader>fn",
      ":Telescope file_browser path=./node_modules<CR>",
      desc = "Find node_modules",
    }
  })

  if is_available("nvim-notify") then
    wk.add({
      {
        "<leader>fN",
        function()
          require("telescope").extensions.notify.notify()
        end,
        desc = "Find notifications",
      },
    })
  end
end

-- Terminal Mappings
if is_available("toggleterm.nvim") then
  wk.add({
    { "<leader>t", group = "Terminal" },
    { "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", desc = "ToggleTerm float", mode = "n" },
    { "<leader>th", "<cmd>ToggleTerm size=10 direction=horizontal<cr>", desc = "ToggleTerm horizontal split", mode = "n" },
    { "<leader>tv", "<cmd>ToggleTerm size=80 direction=vertical<cr>", desc = "ToggleTerm vertical split", mode = "n" },
  })
  if vim.fn.executable("lazygit") == 1 then
    wk.add({
      { "<leader>g", group = "LazyGit" },
      { "<leader>gg", "<cmd>lua _lazygit_toggle() <CR>", desc = "ToggleTerm lazygit", mode = "n" },
    })
  end
end

-- DAP Mappings
if is_available("nvim-dap") then
  wk.add({
    { "<leader>d", group = "Debugger", mode = { "n", "v" } },
    { "<leader>da",
      function()
        local dap = require('dap')
        local command = vim.fn.input('Enter Command to Run: ')
        if command then
          dap.run({
            type = 'node-terminal',
            request = 'launch',
            name = 'Run Command',
            cwd = vim.fn.getcwd(),
            runtimeArgs = {command},
          })
        end
      end
    },
    { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint", mode = "n" },
    { "<leader>dB", function() require("dap").clear_breakpoints() end, desc = "Clear Breakpoints", mode = "n" },
    { "<leader>dc", function() require("dap").continue() end, desc = "Continue", mode = "n" },
    { "<leader>dC",
      function()
        vim.ui.input({ prompt = "Condition: " }, function(condition)
          if condition then
            require("dap").set_breakpoint(condition)
          end
        end)
      end,
      desc = "Conditional Breakpoint",
      mode = "n",
    },
    { "<leader>di", function() require("dap").step_into() end, desc = "Step Into", mode = "n" },
    { "<leader>do", function() require("dap").step_over() end, desc = "Step Over", mode = "n" },
    { "<leader>dO", function() require("dap").step_out() end, desc = "Step Out", mode = "n" },
    { "<leader>dq", function() require("dap").close() end, desc = "Close", mode = "n" },
    { "<leader>dQ", function() require("dap").terminate() end, desc = "Terminate", mode = "n" },
    { "<leader>dp", function() require("dap").pause() end, desc = "Pause", mode = "n" },
    { "<leader>dr", function() require("dap").repl.open() end, desc = "Open REPL", mode = "n" },
    { "<leader>dR", function() require("dap").restart_frame() end, desc = "Toggle REPL", mode = "n" },
    { "<leader>ds", function() require("dap").run_to_cursor() end, desc = "Run to cursor", mode = "n" },
  })

  if is_available("nvim-dap-ui") then
    wk.add({
      {
        "<leader>dE",
        function()
          vim.ui.input({ prompt = "Expression: " }, function(expression)
            if expression then
              require("dapui").eval(expression, { enter = true })
            end
          end)
        end,
        desc = "Evaluate Input",
        mode = { "n", "v" },
      },
      { "<leader>du", function() require("dapui").toggle() end, desc = "Toggle UI", mode = "n" },
      { "<leader>dh", function() require("dap.ui.widgets").hover() end, desc = "Debugger Hover", mode = "n" },
    })
  end
end

-- Code Folding Mappings (UFO)
if is_available("nvim-ufo") then
  wk.add({
    { "zR", function() require("ufo").openAllFolds() end, desc = "Open all folds", mode = "n" },
    { "zM", function() require("ufo").closeAllFolds() end, desc = "Close all folds", mode = "n" },
    { "zr", function() require("ufo").openFoldsExceptKinds() end, desc = "Open folds except kind", mode = "n" },
    { "zm", function() require("ufo").closeFoldsWith() end, desc = "Close folds with kind", mode = "n" },
    { "zp", function() require("ufo").peekFoldedLinesUnderCursor() end, desc = "Peek folds under cursor", mode = "n" },
  })
end

-- Vim Mappings
vim.keymap.set("n", "<C-l>", 'false')
-- wk.add({
--   { "<C-l>", false, mode = "n" }, -- Disable this keymap
-- })
