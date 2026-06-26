return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      auto_clean_after_session_restore = true,
      close_if_last_window = false,
      popup_border_style = "rounded",
      enable_git_status = true,
      enable_diagnostics = true,
      default_component_configs = {
        indent = {
          with_expanders = true,
          expander_collapsed = "",
          expander_expanded = "",
          expander_highlight = "NeoTreeExpander",
        },
      },
      commands = {
        parent_or_close = function(state)
          local node = state.tree:get_node()
          if (node.type == "directory" or node:has_children()) and node:is_expanded() then
            state.commands.toggle_node(state)
          else
            require("neo-tree.ui.renderer").focus_node(state, node:get_parent_id())
          end
        end,
        child_or_open = function(state)
          local node = state.tree:get_node()
          if node.type == "directory" or node:has_children() then
            if not node:is_expanded() then -- if unexpanded, expand
              state.commands.toggle_node(state)
            else -- if expanded and has children, select the next child
              require("neo-tree.ui.renderer").focus_node(state, node:get_child_ids()[1])
            end
          else -- if not a directory just open it
            state.commands.open(state)
          end
        end,
        copy_selector = function(state)
          local node = state.tree:get_node()
          local filepath = node:get_id()
          local filename = node.name
          local modify = vim.fn.fnamemodify

          local vals = {
            ["BASENAME"] = modify(filename, ":r"),
            ["EXTENSION"] = modify(filename, ":e"),
            ["FILENAME"] = filename,
            ["PATH (CWD)"] = modify(filepath, ":."),
            ["PATH (HOME)"] = modify(filepath, ":~"),
            ["PATH"] = filepath,
            ["URI"] = vim.uri_from_fname(filepath),
          }

          local options = vim.tbl_filter(function(val)
            return vals[val] ~= ""
          end, vim.tbl_keys(vals))
          table.sort(options)
          vim.ui.select(options, {
            prompt = "Choose to copy to clipboard:",
            format_item = function(item)
              return ("%s: %s"):format(item, vals[item])
            end,
          }, function(choice)
            local result = vals[choice]
            if result then
              vim.fn.setreg("+", result)
              vim.fn.setreg('"', result)
              vim.notify("Copied: " .. result, vim.log.levels.INFO)
            end
          end)
        end,
        find_in_dir = function(state)
          local node = state.tree:get_node()
          local path = node:get_id()
          Snacks.picker.files({
            cwd = node.type == "directory" and path or vim.fn.fnamemodify(path, ":h"),
          })
        end,
      },
      event_handlers = {
        {
          event = "neo_tree_buffer_enter",
          handler = function(_)
            vim.opt_local.signcolumn = "auto"
            -- Disable mini.jump2d labels inside neo-tree so they don't
            -- interfere with navigation and opening files.
            vim.b.minijump2d_disable = true
          end,
        },
        {
          event = "file_opened",
          handler = function(file_path)
            -- Close neo-tree only if it's still visible in a sidebar window.
            -- When neo-tree was opened full-window on startup, the file buffer
            -- replaces it, so there's nothing to close.
            for _, win in ipairs(vim.api.nvim_list_wins()) do
              local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(win))
              if bufname:match("neo%-tree") then
                require("neo-tree.command").execute({ action = "close" })
                return
              end
            end
          end,
        },
      },
      filesystem = {
        filtered_items = {
          visible = false,
          hide_dotfiles = false,
          hide_gitignored = true,
          hide_hidden = false,
        },
        follow_current_file = {
          enabled = true,
          leave_dirs_open = false,
        },
        use_libuv_file_watcher = true,
      },
      window = {
        position = "left",
        width = 30,
        mappings = {
          ["[b"] = "prev_source",
          ["]b"] = "next_source",
          Y = "copy_selector",
          F = "find_in_dir",
          h = "parent_or_close",
          l = "child_or_open",
          o = "open",
        },
      },
    },
    config = function(_, opts)
      require("neo-tree").setup(opts)

      -- Open neo-tree when Neovim starts on a directory (e.g. `nvim .`).
      -- Use `position = "current"` so it replaces the empty buffer created for
      -- the directory argument; selecting a file will then replace neo-tree.
      vim.api.nvim_create_autocmd("VimEnter", {
        desc = "Open neo-tree when starting on a directory",
        callback = function()
          local arg = vim.fn.argv(0)
          if arg and vim.fn.isdirectory(arg) == 1 then
            require("neo-tree.command").execute({
              toggle = false,
              dir = arg,
              position = "current",
            })
          end
        end,
        once = true,
      })
    end,
  },
}
