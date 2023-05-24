local map = vim.keymap

-- Normal --
-- Common Operations

map.set("n", "<C-s>", "<cmd>w!<cr>", { desc = "Save" })
map.set("n", "<C-q>", "<cmd>q!<cr>", { desc = "Quit" })

-- better up/down
map.set(
    "n",
    "j",
    "v:count == 0 || mode(1)[0:1] == 'no' ? 'j' : 'gj'",
    { expr = true, silent = true, desc = "Move cursor down" }
)
map.set(
    "n",
    "k",
    "v:count == 0 || mode(1)[0:1] == 'no' ? 'k' : 'gk'",
    { expr = true, silent = true, desc = "Move cursor up" }
)

--better indent
map.set("v", "<", "<gv")
map.set("v", ">", ">gv")

--nvim-tree
map.set("n", "<leader>e", ":NvimTreeFindFileToggle<CR>", { desc = "Explorer"})

-- Lazy
local lazy = require("lazy")
--map.set("n", "<leader>p", { desc = "Lazy" })
map.set("n", "<leader>li", function()
    lazy.install()
end, { desc = "Lazy Install" })
map.set("n", "<leader>ls", function()
    lazy.home()
end, { desc = "Lazy Status" })
map.set("n", "<leader>lS", function()
    lazy.sync()
end, { desc = "Lazy Sync" })
map.set("n", "<leader>lu", function()
    lazy.check()
end, { desc = "Lazy Check Update" })
map.set("n", "<leader>lU", function()
    lazy.udpate()
end, { desc = "Lazy Update" })

--move lines
map.set("n", "<leader>k", ":m .-2<CR>==")
map.set("i", "<leader>k", ":m .-2<CR>==gi")
map.set("v", "<leader>k", ":m '<-2<CR>==gv")

map.set("n", "<leader>j", ":m .+1<CR>==")
map.set("i", "<leader>j", ":m .+1<CR>==")
map.set("v", "<leader>j", ":m '>+1<CR>==")

--telescope

map.set("n", "<leader>gb", "<cmd>Telescope git_branches<cr>", { desc = "Git Branches" })
map.set("n", "<leader>gc", "<cmd>Telescope git_commits<cr>", { desc = "Git Commits" })
map.set("n", "<leader>gt", "<cmd>Telescope git_status<cr>", { desc = "Git Status" })
map.set("n", "<leader>gfc", "<cmd>Telescope git_bcommits<cr>", { desc = "Git Commit in current file/buffer" })
map.set("n", "<leader>gG", "<cmd>Telescope git_commits<cr>", { desc = "Git Commits" })

map.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find Files" })
map.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", { desc = "Find string" })
map.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Find word under Cursor" })
map.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Find Buffers" })
map.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Help Tags" })
map.set("n", "<leader>fC", "<cmd>Telescope commands<cr>", { desc = "Find Commnads" })
map.set("n", "<leader>fF", function()
    require("telescope.builtin").find_files({ hidden = true, no_ignore = true })
end, { desc = "Find All Files" })
map.set("n", "<leader>fk", "<cmd>Telescope keymaps<cr>", { desc = "Find Keymaps" })
map.set("n", "<leader>fm", "<cmd>Telescope man_pages<cr>", { desc = "Find Man" })
map.set("n", "<leader>fW", function()
    require("telescope.builtin").live_grep({
        additional_args = function(args)
            return vim.list_extend(args, { "--hidden", "--no-ignore" })
        end,
    })
end, { desc = "Find word in all Files" })

local Terminal = require("toggleterm.terminal").Terminal

map.set("n", "<leader>tn", function()
    Terminal:new({
        cmd = "node",
        hidden = true,
    })
end, { desc = "ToggleTerm Node " })

map.set("n", "<leader>gg", "<cmd>lua _lazygit_toggle()<cr>", { desc = "LazyGit " })

map.set("n", "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", { desc = "ToggleTerm Float" })
map.set("n", "<leader>th", "<cmd>ToggleTerm size=10 direction=horizontal<cr>", { desc = "ToggleTerm Horizontal" })
map.set("n", "<leader>tv", "<cmd>ToggleTerm size=80 direction=vertical<cr>", { desc = "ToggleTerm Vertical" })

--- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
-- map.set("n", "<leader>od", vim.diagnostic.open_float)
map.set("n", "[d", vim.diagnostic.goto_prev)
map.set("n", "]d", vim.diagnostic.goto_next)
map.set("n", "<leader>q", vim.diagnostic.setloclist)

map.set("n", "<leader>lf", "<cmd>lua vim.lsp.buf.format({ timeout_ms = 2000 })<cr>")
map.set("v", "<leader>lf", "<cmd>lua vim.lsp.buf.format({ timeout_ms = 2000 })<cr>")

--- git
map.set("n", "<leader>=", "<cmd>fugitive#LineDiff(expand('%'), line('.'))<cr>", { desc = "Toggle Line diff" })

--- spectre
local status, spectre = pcall(require, "spectre")
if status then
    map.set("n", "<leader>S", function()
        spectre.open()
    end, { desc = "Open Spectre" })

    map.set("n", "<leader>Sw", function()
        spectre.open_visual({ select_word = true })
    end, { desc = "Search current word" })

    map.set("n", "<leader>sw", function()
        spectre.open_visual()
    end, { desc = "Search current word" })

    map.set("n", "<leader>sp", function()
        spectre.open_file_search({ select_word = true })
    end, { desc = "Search on current file" })
end

-- TEST
map.set("n", "<space>tt", "<cmd>TestNearest<CR>", { desc = "Test nearest" })
map.set("n", "<space>tl", "<cmd>TestLast<CR>", { desc = "Test last" })
map.set("n", "<space>tf", "<cmd>TestFile<CR>", { desc = "Test file" })
map.set("n", "<Leader>ts", "<cmd>TestSuite<CR>", {desc = "Test suite" })
-- DAP
map.set("n", "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, { desc = "Breakpoint Condition" })
map.set("n", "<leader>db", function() require("dap").toggle_breakpoint() end, { desc = "Toggle Breakpoint" })
map.set("n", "<leader>dc", function() require("dap").continue() end, { desc = "Continue" })
map.set("n", "<leader>dC", function() require("dap").run_to_cursor() end, { desc = "Run to Cursor" })
map.set("n", "<leader>dg", function() require("dap").goto_() end, { desc = "Go to line (no execute)" })
map.set("n", "<leader>di", function() require("dap").step_into() end, { desc = "Step Into" })
map.set("n", "<leader>dj", function() require("dap").down() end, { desc = "Down" })
map.set("n", "<leader>dk", function() require("dap").up() end, { desc = "Up" })
map.set("n", "<leader>dl", function() require("dap").run_last() end,{  desc = "Run Last" })
map.set("n", "<leader>do", function() require("dap").step_out() end, { desc = "Step Out" })
map.set("n", "<leader>dO", function() require("dap").step_over() end, { desc = "Step Over" })
map.set("n", "<leader>dp", function() require("dap").pause() end, { desc = "Pause" })
map.set("n", "<leader>dr", function() require("dap").repl.toggle() end, { desc = "Toggle REPL" })
map.set("n", "<leader>ds", function() require("dap").session() end, { desc = "Session" })
map.set("n", "<leader>dt", function() require("dap").terminate() end, { desc = "Terminate" })
map.set("n", "<leader>dw", function() require("dap.ui.widgets").hover() end, { desc = "Widgets" })
