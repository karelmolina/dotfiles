#!/bin/bash
# Generate cursorrules.template from opencode/AGENTS.md
# Run this after editing opencode/AGENTS.md to update the Cursor template

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

info "Generating cursorrules.template from opencode/AGENTS.md..."

# Check source file exists
if [ ! -f "$DOTFILES_DIR/opencode/AGENTS.md" ]; then
    error "Source file not found: $DOTFILES_DIR/opencode/AGENTS.md"
    exit 1
fi

# Create the template with Project Context header
cat > "$DOTFILES_DIR/cursor/cursorrules.template" <> 'EOF'
# Cursor Rules - SDD Orchestrator Configuration

> This is a template. Copy to your project as `.cursorrules` and customize the PROJECT section below.

## Project Context

**Project Name**: {{PROJECT_NAME}}
**Description**: {{PROJECT_DESCRIPTION}}

EOF

# Read AGENTS.md and transform it
cat "$DOTFILES_DIR/opencode/AGENTS.md" | while IFS= read -r line; do
    # Change "# Instructions" to "## Rules" (first line transformation)
    if [[ "$line" == "# Instructions" ]]; then
        continue  # Skip this line, we'll add content manually
    fi
    
    # Add Identity header after Rules
    if [[ "$line" == "## Personality" ]]; then
        echo "" >> "$DOTFILES_DIR/cursor/cursorrules.template"
        echo "## Identity" >> "$DOTFILES_DIR/cursor/cursorrules.template"
        echo "" >> "$DOTFILES_DIR/cursor/cursorrules.template"
        continue
    fi
    
    # Transform "Senior Architect, 15+ years..." to have proper formatting
    if [[ "$line" == "Senior Architect, 15+ years"* ]]; then
        echo "**Senior Architect** — 15+ years experience, GDE & MVP. Passionate educator frustrated with mediocrity and shortcut-seekers. Goal: make people learn, not be liked." >> "$DOTFILES_DIR/cursor/cursorrules.template"
        continue
    fi
    
    # Change "## Behavior" to "## Teaching Behavior"
    if [[ "$line" == "## Behavior" ]]; then
        echo "## Teaching Behavior" >> "$DOTFILES_DIR/cursor/cursorrules.template"
        continue
    fi
    
    # Update skill paths from opencode to cursor format
    line=$(echo "$line" | sed 's|~/.config/opencode/skills/\([^/]*\)/SKILL.md|~/.cursor/skills/\1/README.md|g')
    
    echo "$line" >> "$DOTFILES_DIR/cursor/cursorrules.template"
done

success "Generated cursor/cursorrules.template"
info "The template includes Project Context placeholders:"
info "  {{PROJECT_NAME}}"
info "  {{PROJECT_DESCRIPTION}}"
echo ""
info "These are automatically filled by cursor-setup.sh or can be edited manually"

# Show file stats
LINES=$(wc -l < "$DOTFILES_DIR/cursor/cursorrules.template")
info "Generated template: $LINES lines"
