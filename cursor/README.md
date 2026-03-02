# Cursor IDE Configuration

General-purpose Cursor IDE configuration with Spec-Driven Development (SDD) workflow support.

**Single Source of Truth**: This directory is a "view" over `opencode/`. All agents, commands, and skills are **symlinked** from `opencode/`. Edit files there, not here.

## Structure

```
cursor/
├── cursor.json              # Main configuration (Cursor-specific)
├── cursorrules.template     # Template for .cursorrules (generated from opencode/AGENTS.md)
├── README.md               # This file
├── agents -> ../opencode/agents/           # Symlink to opencode agents
├── commands -> ../opencode/commands/     # Symlink to opencode commands
└── skills/
    ├── sdd-init/README.md -> ../../../opencode/skills/sdd-init/SKILL.md
    ├── sdd-explore/README.md -> ../../../opencode/skills/sdd-explore/SKILL.md
    └── ... (10 skills total)
```

## Installation

### Option 1: Quick Setup (Recommended)

```bash
# From your project directory
~/dotfiles/scripts/cursor-setup.sh
```

This will:
- Symlink `cursor/` → `.cursor/`
- Copy `cursorrules.template` → `.cursorrules`
- Auto-detect project info (from package.json, go.mod, etc.)
- Update `.cursorrules` with project context

### Option 2: Manual Setup

```bash
# Symlink the cursor config directory
ln -s ~/dotfiles/cursor ~/.cursor

# Copy and customize the rules template
cp ~/dotfiles/cursor/cursorrules.template .cursorrules
# Edit .cursorrules and fill in PROJECT section
```

## Updating the Template

If you modify `opencode/AGENTS.md`, regenerate the template:

```bash
~/dotfiles/scripts/generate-cursorrules.sh
```

Or manually copy from AGENTS.md and add the Project Context header.

## Features

- **Senior Architect Personality**: Direct, no-BS mentoring style
- **Bilingual**: Rioplatense Spanish / English
- **SDD Workflow**: Full Spec-Driven Development support
  - `sdd init` - Initialize SDD context
  - `sdd explore <topic>` - Explore ideas
  - `sdd new <change>` - Start new change
  - `sdd ff <change>` - Fast-forward planning
  - `sdd apply <change>` - Implement tasks
  - `sdd verify <change>` - Validate implementation
  - `sdd archive <change>` - Archive completed change
- **Engram Integration**: Persistent memory via MCP
- **Security**: Denies access to secrets, env files by default

## SDD Commands Reference

| Command | Description | Skill Location |
|---------|-------------|----------------|
| `sdd init` | Initialize SDD in project | `~/.cursor/skills/sdd-init/` |
| `sdd explore` | Investigate topic | `~/.cursor/skills/sdd-explore/` |
| `sdd new` | Create change proposal | `~/.cursor/skills/sdd-propose/` |
| `sdd continue` | Next artifact in chain | Orchestrator meta-command |
| `sdd ff` | Fast-forward all planning | Orchestrator meta-command |
| `sdd apply` | Implement tasks | `~/.cursor/skills/sdd-apply/` |
| `sdd verify` | Validate implementation | `~/.cursor/skills/sdd-verify/` |
| `sdd archive` | Archive change | `~/.cursor/skills/sdd-archive/` |

## Important Notes

1. **Single Source of Truth**: All edits should be made in `opencode/` directory
2. **Skills as Documentation**: Cursor doesn't have a Task tool like Opencode, so skills serve as reference docs
3. **No Native Sub-agents**: Unlike Opencode, Cursor doesn't support `Task()` delegation - the user acts as orchestrator
4. **Template Regeneration**: Run `generate-cursorrules.sh` after editing `opencode/AGENTS.md`

## Requirements

- [Cursor IDE](https://cursor.sh/)
- [Engram](https://github.com/gentleman-programming/engram) (optional, for MCP memory)

## Credits

Based on the [Opencode](https://opencode.ai/) SDD workflow, adapted for Cursor IDE.
