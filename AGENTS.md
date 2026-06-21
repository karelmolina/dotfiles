# AGENTS.md

Guidelines for agentic coding agents working in this dotfiles repository.

## Repository Overview

Personal dotfiles for:
- **Neovim** (`nvim/`) - Lua-based config with Lazy plugin manager
- **Vim** (`vim/`) - Legacy Vim config (Pathogen + Vundle)
- **Tmux** (`tmux/`) - Terminal multiplexer config
- **Zsh** (`zsh/`) - Shell aliases and functions
- **Terminal emulators** (`kitty/`, `wezterm/`, `ghostty/`) - Terminal configs
- **Dev tools** (`mise/`, `btop/`, `lazygit/`, `atuin/`) - Tool configs
- **macOS tools** (`aerospace/`, `amethyst/`, `karabiner/`, `sketchybar/`) - macOS-specific configs
- **Utils** (`utils/`) - Utility scripts and templates
- **Wallpapers** (`wallpapers/`) - Desktop backgrounds

## Build/Lint/Test Commands

### Installation
```bash
./install                    # Run main installation script

# Or stow individual packages to ~/.config/<package>
cd ~/dotfiles && stow --target="$HOME/.config/nvim" nvim
cd ~/dotfiles && stow --target="$HOME/.config/kitty" kitty
cd ~/dotfiles && stow --target="$HOME/.config/tmux" tmux
```

### Neovim/Lua
```bash
# Format Lua (stylua.toml in nvim/.stylua.toml)
stylua --config-path nvim/.stylua.toml nvim/

# Syntax check
luacheck nvim/ 2>/dev/null || echo "luacheck not installed"

# Test config loads
nvim --headless -u nvim/init.lua -c "echo 'config-loaded'" -c "qa!"

# Health check & plugin update
nvim --checkhealth
nvim --headless "+Lazy update" +qa
```

### Shell Scripts
```bash
# Syntax checks
bash -n install
zsh -n zsh/aliases.zsh
zsh -n zsh/functions.zsh

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

### Lua (nvim/)
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
- **Module pattern**: Return table at end of file

### Shell Scripts
- **Indentation**: 2 spaces
- **Naming**: `snake_case` functions, `UPPER_SNAKE_CASE` exports, `lowercase` aliases
- **Quotes**: Double quotes for variables, single for literals
- **Error handling**: Use `&&`/`||` or `set -e` where appropriate
- **Shebang**: Use `#!/bin/bash` for bash scripts

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
- Currently defined in `lua/core/options.lua`; add a dedicated `lua/keymaps.lua` module as the config grows
- Use `which-key.nvim` for hints once registered as a plugin

### LSP Setup
> Not active in the minimal config. Re-enable by adding the usual LSP plugins under `lua/plugins/`.
- **mason.nvim**: Manage LSP servers
- **nvim-lspconfig**: Configure servers
- **null-ls.nvim**: Formatters/linters
- **Diagnostics**: Mode 3 (all visible)
- Typical location: `lua/plugins/lsp.lua`

### File Organization (minimal lazy.nvim setup)
```
nvim/
├── init.lua              # Entry point: loads options, keymaps, lazy bootstrap, then colorscheme
├── .stylua.toml          # Lua formatter config
└── lua/
    ├── config.lua        # Lazy bootstrap + plugin spec setup
    ├── core/
    │   ├── options.lua   # Basic Vim options and leader keys
    │   ├── keymaps.lua   # Keymaps mapped to mini.nvim + snacks.nvim
    │   ├── colorscheme.lua          # Applies the selected colorscheme
    │   └── colorschemes/            # Per-theme setup files
    │       ├── init.lua
    │       ├── cyberdream.lua
    │       ├── kanagawa.lua
    │       └── tokio.lua
    └── plugins/
        ├── colorscheme.lua          # Colorscheme plugin specs
        ├── mini.lua                 # echasnovski/mini.nvim modules
        ├── snacks.lua               # folke/snacks.nvim modules + keymaps
        └── *.lua                    # Additional plugin categories
```

Plugins are imported automatically from `lua/plugins/` via `lua/config.lua`:
```lua
require("lazy").setup({
  spec = {
    { import = "plugins" },
  },
  checker = { enabled = true },
})
```

### Colorscheme Selection
- Default colorscheme is `cyberdream`
- Set the `theme` environment variable to switch: `theme=kanagawa nvim` or `theme=tokyonight nvim`
- Available themes: `cyberdream`, `kanagawa`, `tokyonight`

## Testing Single Components

### Test full config load
> Important: `~/.config/nvim` currently points to `~/dotfiles/nvim`. When testing `nvim-mini/nvim`, use a separate `NVIM_APPNAME` and prepend this repo to `runtimepath`:
```bash
NVIM_APPNAME=nvim-mini-test nvim --headless -u nvim/init.lua --cmd "set runtimepath^=/Users/karelmolina/nvim-mini/nvim" -c "qa!"
echo "Exit code: $?"
```

### Test a specific plugin spec (after adding plugins)
```bash
nvim --headless -u nvim/init.lua -c "lua require('lazy').load({ plugins = { 'plugin-name' } })" +qa
```

### Test a Lua module
```bash
nvim --headless -u nvim/init.lua -c "lua print(require('plugins.treesitter'))" +qa
```

## Important Notes

- **Personal repo**: Respect existing preferences
- **Symbolic links**: Configs deployed via GNU Stow (`~/.config/nvim/init.lua` → `~/dotfiles/nvim/init.lua`)
- **Stow target**: repo keeps a flat package layout (`nvim/init.lua`); `scripts/common.sh` stows each package to `$HOME/.config/<package>`
- **Compatibility**: Both Vim and Neovim configs maintained
- **No hardcoded paths**: Use `vim.fn.stdpath()` or env vars
- **Backup before changes**: Test in subshell first

## Common Issues

- Don't remove keymaps without understanding purpose
- Don't modify plugin configs without testing
- Keep `.stylua.toml` in sync with indentation settings
- Update `install` script when adding new dependencies
