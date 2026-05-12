local status_ok, opencode = pcall(require, "opencode")
if not status_ok then
  return
end

opencode.setup({
  ui = {
    position = "right",
    window_width = 0.5, -- 50% width
    persist_state = true,
    -- Theming options
    -- window_highlight controls the background and border colors
    -- Format: 'Normal:<highlight_group>,FloatBorder:<highlight_group>'
    window_highlight = "Normal:OpencodeBackground,FloatBorder:OpencodeBorder",
    icons = {
      preset = "nerdfonts", -- 'nerdfonts' | 'text'
      overrides = {},
    },
  },
  keymap = {
    input_window = {
      -- NOTE: Navigation in pickers (/commands, @mentions, ~files, #context) 
      -- is handled by snacks.nvim picker, not opencode.
      -- Use <C-n>/<C-p> or arrow keys to navigate picker items.
      -- Tab is used to toggle between input/output panes by default.
      ['<tab>'] = { 'toggle_pane', mode = { 'n', 'i' } },    -- Toggle input/output
      ['<s-cr>'] = { 'submit_input_prompt', mode = { 'n', 'i' } }, -- Submit prompt
      ['<esc>'] = { 'close' },                               -- Close UI
      ['<c-c>'] = { 'cancel' },                              -- Cancel request
      ['~'] = { 'mention_file', mode = 'i' },                -- Pick file
      ['@'] = { 'mention', mode = 'i' },                     -- Insert mention
      ['/'] = { 'slash_commands', mode = 'i' },              -- Commands menu
      ['#'] = { 'context_items', mode = 'i' },               -- Context items
      ['<up>'] = { 'prev_prompt_history', mode = { 'n', 'i' } },     -- Prev in history
      ['<down>'] = { 'next_prompt_history', mode = { 'n', 'i' } },   -- Next in history
    },
  },
})

