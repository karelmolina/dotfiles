# Dotfiles Repository

Personal dotfiles for a modern, productive Linux development environment. Optimized for Fedora with automated installation and comprehensive tool configuration.

## Overview

This repository contains configuration files and installation scripts for:
- **Terminal Emulators**: Kitty, Ghostty, WezTerm
- **Editors**: Neovim (Lua-based), Vim
- **Shell**: Zsh with Oh-My-Zsh, Starship prompt
- **Tools**: Tmux, btop, yazi, lazygit, lazydocker
- **Version Management**: mise (formerly rtx) for Go, Node.js
- **AI Assistant**: Opencode with SDD skills (sdd-commit, sdd-init, sdd-spec, etc.)
- **IDE**: Cursor with portable SDD configuration

## Quick Start

### Fedora (Primary)

```bash
# Clone and install
git clone https://github.com/karelmolina/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install
```

### Omarchy Linux

```bash
# Clone the repository
git clone https://github.com/karelmolina/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Run the Omarchy installer
./scripts/omarchy.sh --all

# Or run interactively to select specific steps
./scripts/omarchy.sh
```

## What's Included

### Core Applications

| Tool | Purpose | Config Location |
|------|---------|-----------------|
| **Neovim** | Modern Vim editor | `nvim/` |
| **Vim** | Legacy Vim config | `vim/` |
| **Tmux** | Terminal multiplexer | `tmux/` |
| **Zsh** | Shell with aliases & functions | `zsh/` |
| **Kitty** | GPU-accelerated terminal | `kitty/` |
| **Ghostty** | Fast native terminal | `ghostty/` |
| **WezTerm** | Cross-platform terminal | `wezterm/` |
| **btop** | Resource monitor (RAM-focused) | `btop/` |
| **yazi** | Terminal file manager | `yazi/` |
| **mise** | Version manager (Go, Node) | `mise/` |
| **Atuin** | Shell history sync & search | `atuin/` |

### Key Features

#### btop - RAM-Focused System Monitor
- Optimized layout showing Memory and Processes only
- Processes sorted by memory usage
- No GPU or network graphs for clean interface
- Braille graphs for high-resolution memory visualization

#### mise - Universal Version Manager
- Go (latest) with `go install` binary support
- Node.js 20 for JavaScript development
- Automatic PATH configuration for installed tools

#### Neovim
- Lazy.nvim plugin manager
- LSP support with mason.nvim
- Telescope for fuzzy finding
- Treesitter for syntax highlighting
- Catppuccin theme

## Installation

### Prerequisites

- **Fedora**: Version 43+ (primary target)
- **Omarchy Linux**: Any version (complementary tools)
- Git, curl
- Internet connection for package downloads

### Fedora Automated Install

```bash
./install
```

This will:
1. Detect your OS (currently Fedora supported)
2. Install all packages via dnf/flatpak
3. Stow configuration files to `~/.config/`
4. Set up shell configuration

### Omarchy Linux Installation

For Omarchy Linux, use the dedicated installer script that provides complementary
tools without modifying Omarchy's opinionated defaults:

```bash
# Run all steps
./scripts/omarchy.sh --all

# Or run specific steps
./scripts/omarchy.sh 2 3 4

# Dry run to see what would be installed
./scripts/omarchy.sh --dry-run --all

# Run the test suite
./scripts/omarchy.sh --test
```

**What gets installed on Omarchy:**
- mise (version manager for Go, Node.js)
- Rust toolchain (if not present)
- Go compiler (if not present)
- Neovim configuration (dotfiles nvim)
- Zsh enhancements (oh-my-zsh, starship, atuin)
- Kitty terminal configuration
- Development tools (opencode, vicinae installers)

**What Omarchy already provides (skipped):**
- Terminal emulator (Omarchy uses specific terminal)
- Window manager configuration
- System utilities
- Base fonts

### Manual Component Setup

```bash
# Neovim
ln -s ~/dotfiles/nvim ~/.config/nvim

# Vim
ln -s ~/dotfiles/vim/vimrc ~/.vimrc

# Zsh
ln -s ~/dotfiles/zsh/zshrc ~/.zshrc

# Individual tools
stow -d ~/dotfiles -t ~/.config btop
```

## Configuration Details

### Shell (Zsh)

- **Framework**: Oh-My-Zsh
- **Prompt**: Starship
- **Key Features**:
  - mise integration for version management
  - Go binaries in PATH (mise Go installations)
  - Cargo (Rust) binaries
  - Local bin directories
  - Useful aliases (eza, bat, zoxide)

### btop Layout

The btop configuration focuses on **memory monitoring**:
- Shows: Memory box + Process list
- Hides: Network, GPU, detailed CPU graphs
- Sorts processes by memory usage
- High-resolution braille graphs

### mise Tools

Located in `mise/config.toml`:
```toml
[tools]
go = "latest"
node = "20"
```

Go binaries installed via `go install` (e.g., `gotop`) are automatically available in PATH.

### Atuin - Shell History Sync

Magical shell history with sync, search, and smart filtering:

**Configuration** (`atuin/config.toml`):
- **Search Mode**: `skim` - Prioritizes frequently used commands (smart frequency scoring)
- **Filter Mode**: `session` - Isolates history per terminal session
- **Style**: Compact with inverted layout (prompt at top)
- **Inline Height**: 10 lines for quick browsing without taking over the screen
- **Preview**: Enabled with 5-line preview pane to see full command before selecting
- **Sync v2**: Enabled for efficient background synchronization
- **Secrets Filter**: Automatically excludes AWS keys, GitHub tokens, etc.

**Key Bindings** (configured in zsh):
- `Ctrl+R` - Open Atuin search
- `Up Arrow` - Filter history by current directory
- `Enter` - Execute selected command immediately
- `Tab` - Edit selected command before executing

**Installation**:
```bash
# Via stow
stow -d ~/dotfiles -t ~/.config atuin

# Or symlink
ln -s ~/dotfiles/atuin ~/.config/atuin
```

### Opencode SDD Skills

The repository includes SDD (Spec-Driven Development) skills for the Opencode AI assistant:

| Skill | Purpose | Location |
|-------|---------|----------|
| **sdd-commit** | Conventional commit creation with automatic message generation | `opencode/skills/sdd-commit/` |
| **sdd-init** | Bootstrap SDD directory structure in projects | `opencode/skills/sdd-init/` |
| **sdd-spec** | Write specifications with requirements and scenarios | `opencode/skills/sdd-spec/` |
| **sdd-propose** | Create change proposals with intent and scope | `opencode/skills/sdd-propose/` |
| **sdd-design** | Create technical design documents | `opencode/skills/sdd-design/` |
| **sdd-tasks** | Break down changes into implementation tasks | `opencode/skills/sdd-tasks/` |
| **sdd-apply** | Implement tasks from changes | `opencode/skills/sdd-apply/` |
| **sdd-verify** | Validate implementation against specs | `opencode/skills/sdd-verify/` |
| **sdd-archive** | Archive completed changes | `opencode/skills/sdd-archive/` |
| **sdd-explore** | Explore and investigate ideas | `opencode/skills/sdd-explore/` |

These skills follow the SDD pattern for structured, verifiable AI-assisted development.

### Cursor IDE Configuration

Portable Cursor IDE configuration with SDD workflow support:

| Component | Purpose | Location |
|-----------|---------|----------|
| **cursor.json** | Main config (MCP, permissions) | `cursor/cursor.json` |
| **cursorrules** | Agent personality & rules | `cursor/cursorrules.template` |
| **agents/** | SDD orchestrator agent | `cursor/agents/` |
| **commands/** | 8 SDD commands | `cursor/commands/` |
| **skills/** | 10 SDD skills documentation | `cursor/skills/` |

**Setup in any project:**
```bash
# Quick setup with auto-detection
~/dotfiles/scripts/cursor-setup.sh

# Or manual setup
ln -s ~/dotfiles/cursor ~/.cursor
cp ~/dotfiles/cursor/cursorrules.template .cursorrules
# Edit .cursorrules with project-specific context
```

**Features:**
- Same mentoring personality as Opencode (Senior Architect, Rioplatense Spanish)
- Full SDD workflow: `sdd new`, `sdd ff`, `sdd apply`, etc.
- Engram MCP integration for persistent memory
- Security-focused permissions (denies access to secrets/env files)

## Customization

All configurations are extensively commented. Key files:
- `nvim/lua/core/` - Neovim core settings
- `zsh/zshrc` - Shell configuration
- `btop/btop.conf` - System monitor layout
- `mise/config.toml` - Version management

## Supported Platforms

| OS | Status | Installer |
|----|--------|-----------|
| **Fedora 43+** | Fully supported | `./install` |
| **Omarchy Linux** | Fully supported | `./scripts/omarchy.sh` |
| Ubuntu | Planned | - |
| Debian | Planned | - |
| Arch | Planned | - |
| macOS | Planned | - |

## Contributing

Contributions welcome! Please:
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## License

MIT License - See [LICENSE](LICENSE) file for details.

## Credits

- [Neovim](https://neovim.io/) - Hyperextensible Vim-based text editor
- [mise](https://mise.jdx.dev/) - Polyglot version manager
- [btop](https://github.com/aristocratos/btop) - Resource monitor
- [Catppuccin](https://github.com/catppuccin) - Theme ecosystem
