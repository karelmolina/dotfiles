# git-cliff Configuration Directory

This directory contains configuration for [git-cliff](https://git-cliff.org/), a changelog generator.

## Files

- `cliff.toml` - Standard git-cliff configuration (tracked)
- `tvup.cliff.toml` - Project-specific configuration for TVUP style (untracked, template)

## Configuration Types

### Standard Config (`cliff.toml`)

Default git-cliff configuration with conventional commits support.

### TVUP Config (`tvup.cliff.toml`)

Custom configuration for TVUP projects with:
- Keep a Changelog format
- Jira ticket linking support
- Custom group ordering (Added, Changed, Fixed, Refactor, Removed)

## Usage

### Using Standard Config

```bash
# Generate full changelog
git-cliff --config ~/dotfiles/git-cliff/cliff.toml -o CHANGELOG.md

# Show latest release
git-cliff --config ~/dotfiles/git-cliff/cliff.toml --latest
```

### Using TVUP Config (Project-Specific)

Copy the TVUP config to your project and customize it:

```bash
# Copy to your project (do not symlink, customize per project)
cp ~/dotfiles/git-cliff/tvup.cliff.toml /path/to/your/project/tvup.cliff.toml

# Generate changelog with TVUP style
git-cliff --config tvup.cliff.toml -o CHANGELOG.md
```

### Initial Generation (First Time)

Generate the complete changelog with header:
```bash
git-cliff --config ~/dotfiles/git-cliff/cliff.toml -o CHANGELOG.md
```

### Adding New Releases

After creating a new git tag, prepend it to your existing changelog:
```bash
# Prepend the latest tag to existing CHANGELOG.md
git-cliff --config ~/dotfiles/git-cliff/cliff.toml --prepend CHANGELOG.md --latest

# Or prepend unreleased changes
git-cliff --config ~/dotfiles/git-cliff/cliff.toml --prepend CHANGELOG.md --unreleased
```

## Project-Specific Customization

To customize for a specific project:

1. Copy the template config:
   ```bash
   cp ~/dotfiles/git-cliff/tvup.cliff.toml /your/project/custom.cliff.toml
   ```

2. Edit the copied file to customize:
   - Jira URL in postprocessors
   - Group names and ordering
   - Commit type mappings
   - Repository URL

3. Use the custom config:
   ```bash
   git-cliff --config custom.cliff.toml -o CHANGELOG.md
   ```

## Git Ignore

All `*.cliff.toml` files are ignored by git (except `cliff.toml`).
This allows you to create project-specific configs without polluting the dotfiles repo.

## Lazygit Integration

Your lazygit config has custom commands for git-cliff:
- `<c-g>` - Generate full changelog
- `<c-p>` - Prepend unreleased changes
- `<c-l>` - Show latest release

These use the standard config by default. To use a custom config, update the lazygit command:
```bash
git-cliff --config /path/to/your/project/custom.cliff.toml ...
```
