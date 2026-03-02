#!/bin/bash
# Setup Cursor IDE configuration in current project
# Usage: ~/dotfiles/scripts/cursor-setup.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

# Check if we're in a git repo
if [ ! -d ".git" ]; then
    warn "Not in a git repository root. Are you sure?"
    read -p "Continue anyway? [y/N]: " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

info "Setting up Cursor IDE configuration..."

# Check if dotfiles cursor config exists
if [ ! -d "$DOTFILES_DIR/cursor" ]; then
    error "Dotfiles cursor config not found at $DOTFILES_DIR/cursor"
    error "Make sure your dotfiles are cloned at ~/dotfiles"
    exit 1
fi

# Create .cursor symlink
if [ -e ".cursor" ]; then
    if [ -L ".cursor" ]; then
        warn ".cursor already exists as symlink"
        read -p "Remove and recreate? [y/N]: " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            rm ".cursor"
        else
            error "Aborted"
            exit 1
        fi
    else
        warn ".cursor already exists as directory/file"
        backup_name=".cursor.backup.$(date +%Y%m%d%H%M%S)"
        mv ".cursor" "$backup_name"
        info "Backed up existing .cursor to $backup_name"
    fi
fi

ln -s "$DOTFILES_DIR/cursor" ".cursor"
success "Linked .cursor -> $DOTFILES_DIR/cursor"

# Create .cursorrules from template
if [ -f ".cursorrules" ]; then
    warn ".cursorrules already exists"
    read -p "Overwrite with template? [y/N]: " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        cp "$DOTFILES_DIR/cursor/cursorrules.template" ".cursorrules"
        success "Created .cursorrules from template"
    else
        info "Keeping existing .cursorrules"
    fi
else
    cp "$DOTFILES_DIR/cursor/cursorrules.template" ".cursorrules"
    success "Created .cursorrules from template"
fi

# Try to detect project info and update .cursorrules
info "Detecting project information..."

PROJECT_NAME=$(basename "$(pwd)")
DESCRIPTION="Project description here"
STACK="Unknown"

if [ -f "package.json" ]; then
    PROJECT_NAME=$(jq -r '.name // empty' package.json 2>/dev/null || echo "$PROJECT_NAME")
    DESCRIPTION=$(jq -r '.description // empty' package.json 2>/dev/null || echo "")
    STACK="Node.js"
elif [ -f "go.mod" ]; then
    STACK="Go"
    DESCRIPTION="Go module project"
    # Try to get module name
    MODULE=$(head -1 go.mod 2>/dev/null | awk '{print $2}')
    [ -n "$MODULE" ] && PROJECT_NAME="$MODULE"
elif [ -f "Cargo.toml" ]; then
    STACK="Rust"
    DESCRIPTION="Rust project"
    # Try to get package name
    PROJECT_NAME=$(grep "^name" Cargo.toml 2>/dev/null | head -1 | sed 's/.*= *"\(.*\)".*/\1/')
elif [ -f "pyproject.toml" ]; then
    STACK="Python"
    DESCRIPTION="Python project"
    # Try to get project name
    PROJECT_NAME=$(grep "^name" pyproject.toml 2>/dev/null | head -1 | sed 's/.*= *"\(.*\)".*/\1/')
elif [ -f "requirements.txt" ]; then
    STACK="Python"
    DESCRIPTION="Python project"
fi

# Set default description if still empty
[ -z "$DESCRIPTION" ] && DESCRIPTION="${STACK} project: ${PROJECT_NAME}"

info "Detected:"
echo "  Project Name: $PROJECT_NAME"
echo "  Stack: $STACK"
echo "  Description: $DESCRIPTION"

# Update .cursorrules with detected info (using sed)
if command -v sed >/dev/null 2>&1; then
    # macOS vs Linux sed compatibility
    if [[ "$OSTYPE" == "darwin"* ]]; then
        sed -i '' "s/{{PROJECT_NAME}}/$PROJECT_NAME/g" .cursorrules 2>/dev/null || true
        sed -i '' "s/{{PROJECT_DESCRIPTION}}/$DESCRIPTION/g" .cursorrules 2>/dev/null || true
    else
        sed -i "s/{{PROJECT_NAME}}/$PROJECT_NAME/g" .cursorrules 2>/dev/null || true
        sed -i "s/{{PROJECT_DESCRIPTION}}/$DESCRIPTION/g" .cursorrules 2>/dev/null || true
    fi
    success "Updated .cursorrules with project info"
else
    warn "sed not available, please manually edit .cursorrules and replace:"
    warn "  {{PROJECT_NAME}} with: $PROJECT_NAME"
    warn "  {{PROJECT_DESCRIPTION}} with: $DESCRIPTION"
fi

echo ""
echo "=============================================="
echo "Cursor Setup Complete!"
echo "=============================================="
echo ""
echo "Next steps:"
echo "1. Edit .cursorrules to customize the configuration"
echo "2. Open Cursor IDE in this project"
echo "3. Try: 'sdd new my-first-change'"
echo ""
echo "To update: rm .cursor && ln -s ~/dotfiles/cursor .cursor"
echo ""
echo "NOTE: This setup symlinks to opencode/ - if you edit AGENTS.md there,"
echo "      run: ~/dotfiles/scripts/generate-cursorrules.sh to update the template"
echo ""
