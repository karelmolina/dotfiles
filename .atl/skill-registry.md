# Skill Registry for dotfiles

Generated: 2025-03-27

## Project Conventions

### Index Files
- `AGENTS.md` - Primary project guidelines for agentic coding agents

### Referenced Files
- `install` - Installation script (Fedora)
- `nvim/` - Neovim Lua config with Lazy plugin manager
- `zsh/` - Zsh aliases and functions
- `tmux/` - Tmux configuration
- `kitty/` - Kitty terminal config
- `opencode/` - Opencode AI assistant configuration

## Available Skills

### SDD Workflow Skills

| Skill | Trigger | Description |
|-------|---------|-------------|
| **sdd-init** | "sdd init", "iniciar sdd" | Initialize SDD context in project |
| **sdd-explore** | Pre-change investigation | Explore ideas before committing |
| **sdd-propose** | New change creation | Create change proposal |
| **sdd-spec** | Specification writing | Write specs with requirements |
| **sdd-design** | Technical design | Create design documents |
| **sdd-tasks** | Task breakdown | Break change into tasks |
| **sdd-apply** | Implementation | Apply tasks and write code |
| **sdd-verify** | Validation | Verify implementation |
| **sdd-archive** | Archive | Sync specs and archive |

### Workflow Skills

| Skill | Trigger | Description |
|-------|---------|-------------|
| **branch-pr** | PR creation | Create pull requests (issue-first) |
| **issue-creation** | Issue creation | Create GitHub issues |
| **skill-registry** | "update skills" | Update this registry |
| **sdd-commit** | Commit creation | Create conventional commits |

## Tech Stack

- **Shell**: Zsh with custom aliases/functions
- **Editor**: Neovim (Lua/Lazy.nvim) + Vim (legacy)
- **Terminal**: Kitty, Tmux
- **AI**: Opencode with SDD orchestration
- **Tools**: atuin, btop, lazygit, mise, git-cliff

## Key Patterns

- Lua: 2-space indent, snake_case, pcall() for optional deps
- Shell: 2-space indent, snake_case functions
- Configs: Symlinked from ~/dotfiles to ~/.config/
- SDD: Engram persistence, no openspec/ directory
