#!/bin/bash
#
# Opencode Sync Script
# Merges dotfiles/opencode/ overlay onto ~/.config/opencode/
#
# Usage:
#   ./opencode-sync.sh           # Normal sync
#   ./opencode-sync.sh --dry-run # Preview changes without applying
#   ./opencode-sync.sh --restore # Restore from latest backup

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Paths
DOTFILES_OPENCODE="${HOME}/dotfiles/opencode"
CONFIG_OPENCODE="${HOME}/.config/opencode"
BACKUP_DIR="${HOME}/.config/opencode-backups/$(date +%Y%m%d-%H%M%S)"

# Flags
DRY_RUN=false
RESTORE=false
VERBOSE=false

# Logging
log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_ok() { echo -e "${GREEN}[OK]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

usage() {
  cat <<EOF
Usage: $(basename "$0") [OPTIONS]

Syncs your dotfiles opencode overlay onto ~/.config/opencode/

OPTIONS:
  --dry-run     Preview changes without applying
  --restore     Restore from latest backup
  --verbose     Show detailed output
  -h, --help    Show this help

EXAMPLES:
  $(basename "$0")              # Normal sync
  $(basename "$0") --dry-run    # Preview only
  $(basename "$0") --restore    # Restore latest backup
EOF
}

parse_args() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --dry-run)
        DRY_RUN=true
        shift
        ;;
      --restore)
        RESTORE=true
        shift
        ;;
      --verbose)
        VERBOSE=true
        shift
        ;;
      -h|--help)
        usage
        exit 0
        ;;
      *)
        log_error "Unknown option: $1"
        usage
        exit 1
        ;;
    esac
  done
}

check_prerequisites() {
  if [[ ! -d "$CONFIG_OPENCODE" ]]; then
    log_error "~/.config/opencode/ not found. Install gentle-ai first:"
    log_error "  curl -fsSL https://raw.githubusercontent.com/Gentleman-Programming/gentle-ai/main/scripts/install.sh | bash"
    exit 1
  fi

  if [[ ! -d "$DOTFILES_OPENCODE" ]]; then
    log_error "~/dotfiles/opencode/ not found."
    exit 1
  fi

  if ! command -v jq >/dev/null 2>&1; then
    log_warn "jq not found. JSON merge will use basic fallback."
    log_warn "Install jq for better merge: sudo dnf install jq"
  fi
}

backup_file() {
  local file="$1"
  if [[ -f "$file" && "$DRY_RUN" == false ]]; then
    local rel_path="${file#$CONFIG_OPENCODE/}"
    local backup_path="${BACKUP_DIR}/${rel_path}"
    mkdir -p "$(dirname "$backup_path")"
    cp "$file" "$backup_path"
    [[ "$VERBOSE" == true ]] && log_info "Backed up: ${rel_path}"
  fi
}

merge_json() {
  local base_file="$1"
  local overlay_file="$2"
  local output_file="$3"

  if [[ ! -f "$overlay_file" ]]; then
    log_info "No overlay.json found, skipping JSON merge"
    return 0
  fi

  if ! command -v jq >/dev/null 2>&1; then
    log_warn "jq not available, skipping JSON merge"
    return 0
  fi

  log_info "Merging overlay.json with opencode.json..."

  if [[ "$DRY_RUN" == true ]]; then
    log_info "[DRY-RUN] Would merge:"
    echo "  Base:    ${base_file}"
    echo "  Overlay: ${overlay_file}"
    echo "  Output:  ${output_file}"
    return 0
  fi

  # Deep merge: overlay keys override base keys at all levels
  # Strip comments (keys starting with _) from overlay before merging
  jq -s '
    def strip_comments:
      with_entries(select(.key | startswith("_") | not));
    def deep_merge($base; $overlay):
      ($base | strip_comments) + ($overlay | strip_comments) |
      with_entries(
        if .value | type == "object" and ($base[.key] | type == "object") and ($overlay[.key] | type == "object")
        then .value = deep_merge($base[.key]; $overlay[.key])
        else .
        end
      );
    deep_merge(.[0]; .[1])
  ' "$base_file" "$overlay_file" > "${output_file}.tmp" && mv "${output_file}.tmp" "$output_file"

  log_ok "JSON merged successfully"
}

sync_skills() {
  local skills_dir="${DOTFILES_OPENCODE}/skills"

  if [[ ! -d "$skills_dir" ]]; then
    log_info "No skills/ directory in overlay, skipping"
    return 0
  fi

  log_info "Syncing skills..."

  local count=0
  for skill_dir in "$skills_dir"/*; do
    [[ ! -d "$skill_dir" ]] && continue

    local skill_name
    skill_name=$(basename "$skill_dir")
    local target_dir="${CONFIG_OPENCODE}/skills/${skill_name}"

    if [[ -d "$target_dir" ]]; then
      log_warn "Overwriting skill: ${skill_name}"
    else
      log_info "Adding skill: ${skill_name}"
    fi

    if [[ "$DRY_RUN" == false ]]; then
      backup_file "${target_dir}/SKILL.md" 2>/dev/null || true
      rm -rf "$target_dir"
      cp -r "$skill_dir" "$target_dir"
    fi

    ((count++)) || true
  done

  if [[ "$DRY_RUN" == true ]]; then
    log_info "[DRY-RUN] Would sync ${count} skills"
  else
    log_ok "Synced ${count} skills"
  fi
}

sync_agents() {
  local agents_dir="${DOTFILES_OPENCODE}/agents"

  if [[ ! -d "$agents_dir" ]]; then
    log_info "No agents/ directory in overlay, skipping"
    return 0
  fi

  log_info "Syncing agents..."

  # Agents are embedded in opencode.json, so we need to parse them
  # For now, just log that they exist
  local count=0
  for agent_file in "$agents_dir"/*.md; do
    [[ ! -f "$agent_file" ]] && continue
    ((count++)) || true
    local agent_name
    agent_name=$(basename "$agent_file" .md)
    log_info "Found agent definition: ${agent_name}"
    log_warn "Note: Agents must be manually added to overlay.json or opencode.json"
  done

  if [[ $count -gt 0 ]]; then
    log_warn "Agent files found but not auto-merged. Add them to overlay.json['agent'] manually."
  fi
}

merge_agents_md() {
  local base_file="${CONFIG_OPENCODE}/AGENTS.md"
  local overlay_file="${DOTFILES_OPENCODE}/AGENTS.md"

  if [[ ! -f "$overlay_file" ]]; then
    log_info "No AGENTS.md overlay found, skipping"
    return 0
  fi

  log_info "Merging AGENTS.md..."

  if [[ "$DRY_RUN" == true ]]; then
    log_info "[DRY-RUN] Would append overlay AGENTS.md to base"
    return 0
  fi

  # Check if already merged (idempotent)
  if grep -q "<!-- dotfiles-overlay:start -->" "$base_file" 2>/dev/null; then
    log_info "AGENTS.md already has overlay, removing old overlay first..."
    # Remove old overlay section
    sed -i '/<!-- dotfiles-overlay:start -->/,/<!-- dotfiles-overlay:end -->/d' "$base_file"
  fi

  # Append overlay
  {
    echo ""
    echo "<!-- dotfiles-overlay:start -->"
    cat "$overlay_file"
    echo "<!-- dotfiles-overlay:end -->"
  } >> "$base_file"

  log_ok "AGENTS.md merged"
}

restore_backup() {
  local latest_backup
  latest_backup=$(ls -td "${HOME}/.config/opencode-backups/"* 2>/dev/null | head -1)

  if [[ -z "$latest_backup" ]]; then
    log_error "No backups found to restore"
    exit 1
  fi

  log_info "Restoring from: ${latest_backup}"
  cp -r "${latest_backup}/"* "$CONFIG_OPENCODE/"
  log_ok "Restored from backup"
}

main() {
  parse_args "$@"

  if [[ "$RESTORE" == true ]]; then
    restore_backup
    exit 0
  fi

  log_info "Opencode Overlay Sync"
  log_info "====================="
  log_info "Base:    ${CONFIG_OPENCODE}"
  log_info "Overlay: ${DOTFILES_OPENCODE}"
  [[ "$DRY_RUN" == true ]] && log_warn "DRY RUN MODE - No changes will be made"

  check_prerequisites

  # Create backup directory
  if [[ "$DRY_RUN" == false ]]; then
    mkdir -p "$BACKUP_DIR"
    log_info "Backup directory: ${BACKUP_DIR}"
  fi

  # Backup current opencode.json
  backup_file "${CONFIG_OPENCODE}/opencode.json"

  # Merge JSON configuration
  merge_json \
    "${CONFIG_OPENCODE}/opencode.json" \
    "${DOTFILES_OPENCODE}/overlay.json" \
    "${CONFIG_OPENCODE}/opencode.json"

  # Sync skills
  sync_skills

  # Sync agents (currently just logs)
  sync_agents

  # Merge AGENTS.md
  backup_file "${CONFIG_OPENCODE}/AGENTS.md"
  merge_agents_md

  log_info "====================="
  if [[ "$DRY_RUN" == true ]]; then
    log_ok "Dry run complete. No changes made."
  else
    log_ok "Sync complete!"
    log_info "Backup saved to: ${BACKUP_DIR}"
    log_info "Run with --restore to undo"
  fi
}

main "$@"
