# Dotfiles Repository

Personal dotfiles for a modern, productive development environment. Optimized for macOS and Omarchy Linux with automated installation and comprehensive tool configuration.

## Overview

This repository contains configuration files and installation scripts for:
- **Terminal Emulators**: Kitty, Ghostty, WezTerm
- **Editors**: Neovim (Lua-based), Vim
- **Shell**: Zsh with Oh-My-Zsh, Starship prompt
- **Tools**: btop, lazygit, lazysql, Atuin
- **Version Management**: mise for Go, Node.js
- **Workflow**: SDD (Spec-Driven Development) with Gentleman AI, configured per-project

## Quick Start

### macOS

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

| Tool | Purpose | Config Location | Status |
|------|---------|-----------------|--------|
| **Neovim** | Modern Vim editor | `nvim/` | Active |
| **Vim** | Legacy Vim config | `vim/` | Inactive |
| **Zsh** | Shell with aliases & functions | `zsh/` | Active |
| **Kitty** | GPU-accelerated terminal | `kitty/` | Active |
| **Ghostty** | Fast native terminal | `ghostty/` | Active |
| **WezTerm** | Cross-platform terminal | `wezterm/` | Active |
| **btop** | Resource monitor (RAM-focused) | `btop/` | Active |
| **mise** | Version manager (Go, Node) | `mise/` | Active |
| **Atuin** | Shell history sync & search | `atuin/` | Active |
| **lazygit** | Terminal UI for git | `lazygit/` | Active |
| **lazysql** | Terminal SQL client | `lazysql/` | Active |
| **amethyst** | Tiling window manager (macOS) | `amethyst/` | Active |
| **aerospace** | Tiling window manager (macOS) | `aerospace/` | Inactive |
| **sketchybar** | Custom macOS status bar | `sketchybar/` | Inactive |
| **Tmux** | Terminal multiplexer | `tmux/` | Inactive |

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

- **macOS**: With Homebrew installed (or let the installer install it)
- **Omarchy Linux**: Any version (complementary tools)
- Git, curl
- Internet connection for package downloads

### Automated Install

```bash
./install
```

This will:
1. Detect your OS (currently macOS or Omarchy Linux supported)
2. Install packages via Homebrew (macOS) or system package manager (Omarchy)
3. Stow or link active configuration files to `~/.config/`
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

**What Omarchy already provides (skipped):**
- Window manager configuration
- System utilities
- Base fonts

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

### SDD Workflow

These dotfiles are designed to work with **Spec-Driven Development (SDD)** via [Gentleman AI](https://github.com/Gentleman-Programming/gentle-ai).

SDD means planning first: proposal → specs → design → tasks → implementation → verification. Structured, verifiable, repeatable.

Gentleman AI / Opencode / Cursor settings are now configured **per-project**, not globally in this repo.

## Customization

All configurations are extensively commented. Key files:
- `nvim/lua/core/` - Neovim core settings
- `zsh/zshrc` - Shell configuration
- `btop/btop.conf` - System monitor layout
- `mise/config.toml` - Version management
- `registry.toml` - Active/inactive config status per OS

## Supported Platforms

| OS | Status | Installer |
|----|--------|-----------|
| **macOS** | Fully supported | `./install` |
| **Omarchy Linux** | Fully supported | `./install` or `./scripts/omarchy.sh` |

Configurations are tracked in `registry.toml`, which declares which tools are active, inactive, or unsupported on each OS.

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
