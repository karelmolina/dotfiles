# AGENTS.md

Guidelines for agentic coding agents working in this dotfiles repository.

## Repository Overview

Personal dotfiles for:
- **Neovim** (`nvim/`) - Lua-based config with Lazy plugin manager
- **Vim** (`vim/`) - Legacy Vim config (Pathogen + Vundle)
- **Tmux** (`tmux/`) - Terminal multiplexer config
- **Zsh** (`zsh/`) - Shell aliases and functions
- **Kitty** (`kitty/`) - Terminal emulator config
- **Opencode** (`opencode/`) - Opencode AI assistant configuration
- **Utils** (`utils/`) - Utility scripts and templates
- **Wallpapers** (`wallpapers/`) - Desktop backgrounds

## Build/Lint/Test Commands

### Installation
```bash
./install                    # Run main installation script
ln -s ~/dotfiles/nvim ~/.config/nvim
ln -s ~/dotfiles/vim/vimrc ~/.vimrc
```

### Neovim/Lua
```bash
# Format Lua (stylua.toml in nvim/.stylua.toml)
stylua --config-path nvim/.stylua.toml nvim/lua/

# Syntax check
luacheck nvim/lua/ 2>/dev/null || echo "luacheck not installed"

# Test single plugin config
nvim --headless -c "lua require('core.plugin_config.telescope')" +qa

# Health check & plugin update
nvim --checkhealth
nvim --headless "+Lazy update" +qa
```

### Shell Scripts
```bash
# Syntax checks
bash -n install
zsh -n zsh/aliases.zsh

# Lint (if shellcheck available)
shellcheck install zsh/aliases.zsh 2>/dev/null || true

# Test shell function
source zsh/aliases.zsh && which y
```

### Vim
```bash
# Test config loads
vim -u ~/dotfiles/vim/vimrc +q

# Install plugins
vim +PluginInstall +qa
```

## Code Style Guidelines

### Lua (nvim/lua/)
- **Indentation**: 2 spaces (configured in `.stylua.toml`)
- **Naming**: `snake_case` for modules/variables, `camelCase` for API calls
- **Imports**: Group by: 1) stdlib, 2) local modules, 3) plugins
- **Error handling**: Use `pcall()` for optional dependencies:
  ```lua
  local ok, module = pcall(require, "plugin")
  if not ok then return end
  ```
- **Comments**: Use `--`, keep concise
- **Globals**: Use `vim.opt.*` for options, `vim.g.*` for globals

### Shell Scripts
- **Indentation**: 2 spaces
- **Naming**: `snake_case` functions, `UPPER_SNAKE_CASE` exports, `lowercase` aliases
- **Quotes**: Double quotes for variables, single for literals
- **Error handling**: Use `&&`/`||` or `set -e` where appropriate

### Vimscript (vim/)
- **Indentation**: 2 spaces
- **Organization**: Split into `plugins.vim`, `vim_conf.vim`, `key_remap.vim`, `plugin_options.vim`

## Configuration Patterns

### Neovim Plugin Management (Lazy.nvim)
```lua
-- Use opts table for configuration
{
  "folke/which-key.nvim",
  opts = { timeout = 300 }
}

-- Lazy loading
{ "plugin/name", lazy = true, event = "VeryLazy" }

-- Priority for colorschemes
{ "folke/tokyonight.nvim", lazy = false, priority = 1000 }
```

### Key Bindings
- Leader: `<Space>` (`vim.g.mapleader = " "`)
- Local leader: `,` (`vim.g.maplocalleader = ","`)
- Define in `core/keymaps.lua`
- Use `which-key.nvim` for hints

### LSP Setup
- **mason.nvim**: Manage LSP servers
- **nvim-lspconfig**: Configure servers
- **none-ls.nvim**: Formatters/linters
- **Diagnostics**: Mode 3 (all visible)
- Location: `core/plugin_config/lsp/`

### File Organization
```
nvim/
├── init.lua              # Entry point
├── lua/
│   ├── config.lua        # Lazy plugin specs
│   ├── core/
│   │   ├── options.lua   # Vim options
│   │   ├── keymaps.lua   # Key bindings
│   │   ├── autocmds.lua  # Autocommands
│   │   ├── colorscheme.lua
│   │   ├── plugin_config/# Plugin configs
│   │   │   ├── lsp/     # LSP-specific
│   │   │   └── *.lua    # Individual plugins
│   │   └── utils/       # Helper functions
│   └── config.lua       # Plugin definitions
```

## Testing Single Components

### Test specific plugin
```bash
nvim --headless -c "lua require('core.plugin_config.lualine')" +qa
echo "Exit code: $?"
```

### Test colorscheme
```bash
nvim --headless -c "lua require('core.colorschemes.tokio')" -c "colorscheme tokyonight" +qa
```

### Test utils
```bash
nvim --headless -c "lua print(require('core.utils').is_available('telescope.nvim'))" +qa
```

## Important Notes

- **Personal repo**: Respect existing preferences
- **Symbolic links**: Configs deployed via symlinks (`~/.config/nvim` → `~/dotfiles/nvim`)
- **Compatibility**: Both Vim and Neovim configs maintained
- **No hardcoded paths**: Use `vim.fn.stdpath()` or env vars
- **Backup before changes**: Test in subshell first

## Common Issues

- Don't remove keymaps without understanding purpose
- Don't modify plugin configs without testing
- Keep `.stylua.toml` in sync with indentation settings
- Update `install` script when adding new dependencies
