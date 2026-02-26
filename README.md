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

## Quick Start

```bash
# Clone and install
git clone https://github.com/karelmolina/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install
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

- Fedora 43+ (primary target)
- Git, curl
- Internet connection for package downloads

### Automated Install

```bash
./install
```

This will:
1. Detect your OS (currently Fedora supported)
2. Install all packages via dnf/flatpak
3. Stow configuration files to `~/.config/`
4. Set up shell configuration

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

## Customization

All configurations are extensively commented. Key files:
- `nvim/lua/core/` - Neovim core settings
- `zsh/zshrc` - Shell configuration
- `btop/btop.conf` - System monitor layout
- `mise/config.toml` - Version management

## Supported Platforms

| OS | Status |
|----|--------|
| Fedora 43+ | Fully supported |
| Ubuntu | Planned |
| Debian | Planned |
| Arch | Planned |
| macOS | Planned |

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
