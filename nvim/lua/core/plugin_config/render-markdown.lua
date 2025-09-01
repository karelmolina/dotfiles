local status, renderMarkdown = pcall(require, "render-markdown")
if not status then
  return
end

renderMarkdown.setup({
    checkbox = {
        -- Checkboxes are a special instance of a 'list_item' that start with a 'shortcut_link'.
        -- There are two special states for unchecked & checked defined in the markdown grammar.

        -- Turn on / off checkbox state rendering.
        enabled = true,
        -- Additional modes to render checkboxes.
        render_modes = false,
        -- Render the bullet point before the checkbox.
        bullet = false,
        -- Padding to add to the right of checkboxes.
        right_pad = 1,
        unchecked = {
            -- Replaces '[ ]' of 'task_list_marker_unchecked'.
            icon = '󰄱 ',
            -- Highlight for the unchecked icon.
            highlight = 'RenderMarkdownUnchecked',
            -- Highlight for item associated with unchecked checkbox.
            scope_highlight = nil,
        },
        checked = {
            -- Replaces '[x]' of 'task_list_marker_checked'.
            icon = '󰱒 ',
            -- Highlight for the checked icon.
            highlight = 'RenderMarkdownChecked',
            -- Highlight for item associated with checked checkbox.
            scope_highlight = nil,
        },
        -- Define custom checkbox states, more involved, not part of the markdown grammar.
        -- As a result this requires neovim >= 0.10.0 since it relies on 'inline' extmarks.
        -- The key is for healthcheck and to allow users to change its values, value type below.
        -- | raw             | matched against the raw text of a 'shortcut_link'           |
        -- | rendered        | replaces the 'raw' value when rendering                     |
        -- | highlight       | highlight for the 'rendered' icon                           |
        -- | scope_highlight | optional highlight for item associated with custom checkbox |
        -- stylua: ignore
        custom = {
            todo = { raw = '[t]', rendered = '󰥔 ', highlight = 'RenderMarkdownTodo', scope_highlight = nil },
            incomplete ={ raw = '[/]', rendered = '', highlight = 'RenderMarkdownIncomplete', scope_highlight = nil },
            schedule = { raw = '[>]', rendered = '', highlight = 'RenderMarkdownSchedule', scope_highlight = nil },
            cancelled = { raw = '[-]', rendered = '', highlight = 'RenderMarkdownCancelled', scope_highlight = nil },
            note = { raw = '[n]', rendered = '', highlight = 'RenderMarkdownNote', scope_highlight = nil },
        },
    },
})
