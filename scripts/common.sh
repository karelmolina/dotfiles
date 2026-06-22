#!/bin/bash
# Common functions used across all OS install scripts

set -e

# Logging
LOG_FILE="${LOG_FILE:-$HOME/.dotfiles-install.log}"
BASEDIR="$HOME"
DOTFILES_DIR="$HOME/dotfiles"

# Omarchy-specific constants
OMARCHY_CONFIG_DIR="${HOME}/.omarchy"
OMARCHY_VERSION_FILE="/etc/omarchy/version"

echo_info() {
    echo "[INFO] $1"
}

echo_success() {
    echo "[SUCCESS] $1"
}

echo_error() {
    echo "[ERROR] $1" >&2
}

echo_warn() {
    echo "[WARN] $1"
}

# Link a dotfile from dotfiles repo to home
dotlink() {
    local src="$DOTFILES_DIR/$1"
    local dest="$BASEDIR/$2"

    if [ -e "$dest" ] && [ ! -L "$dest" ]; then
        echo_warn "Backing up existing $dest"
        mv "$dest" "$dest.backup.$(date +%Y%m%d%H%M%S)"
    fi

    ln -sf "$src" "$dest"
    echo_success "Linked: $src -> $dest"
}

# Clone repo if not exists
ensure_dotfiles() {
    if [ ! -d "$DOTFILES_DIR/.git" ]; then
        echo_info "Cloning dotfiles repository..."
        git clone https://github.com/$(whoami)/dotfiles.git "$DOTFILES_DIR" || \
        git clone git@github.com:$(whoami)/dotfiles.git "$DOTFILES_DIR" || {
            echo_error "Failed to clone dotfiles repo"
            exit 1
        }
    fi
}

# Check if command exists
has_command() {
    command -v "$1" &>/dev/null
}

# Stow a dotfiles package into ~/.config/<package>
# This wrapper preserves the repo's flat package layout (e.g. nvim/init.lua)
# while deploying to the standard XDG config location.
stow_config() {
    local pkg="$1"
    local target="${2:-$HOME/.config/$pkg}"

    if ! has_command stow; then
        echo_error "GNU Stow is not installed"
        return 1
    fi

    if [ ! -d "$DOTFILES_DIR/$pkg" ]; then
        echo_error "Package $pkg not found in dotfiles"
        return 1
    fi

    if [ -e "$target" ] && [ ! -L "$target" ]; then
        local backup_name="$target.backup.$(date +%Y%m%d%H%M%S)"
        echo_warn "Backing up existing $target"
        mv "$target" "$backup_name"
    fi

    mkdir -p "$target"

    echo_info "Stowing $pkg to $target..."
    (cd "$DOTFILES_DIR" && stow --target="$target" "$pkg")
    echo_success "Stowed: $pkg"
}

# Link zsh custom files directly into oh-my-zsh/custom (not via stow)
link_zsh_custom() {
    local src="$DOTFILES_DIR/zsh"
    local target_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

    mkdir -p "$target_dir"

    for item in "$src"/*; do
        local basename=$(basename "$item")
        local dest="$target_dir/$basename"

        if [ -e "$dest" ] && [ ! -L "$dest" ]; then
            echo_warn "Backing up existing $dest"
            mv "$dest" "$dest.backup.$(date +%Y%m%d%H%M%S)"
        fi

        ln -sf "$item" "$dest"
    done

    echo_success "Linked zsh custom files to $target_dir"
}

# Install fonts from zip
install_fonts() {
    local font_url="$1"
    local font_name="$2"
    local temp_dir=$(mktemp -d)
    local fonts_dir="$HOME/.local/share/fonts"

    echo_info "Installing font: $font_name"
    mkdir -p "$fonts_dir"

    cd "$temp_dir"
    curl -L -o font.zip "$font_url"
    unzip -o font.zip -d "$fonts_dir/"
    fc-cache -f -v
    cd -
    rm -rf "$temp_dir"

    echo_success "Font $font_name installed"
}

# ============================================
# OS Detection Functions
# ============================================

# Check if running on Omarchy Linux
# Returns 0 if Omarchy detected, 1 otherwise
is_omarchy() {
  # Method 1: Check /etc/os-release for ID=omarchy
  if [ -f /etc/os-release ]; then
    if grep -q "^ID=omarchy" /etc/os-release 2>/dev/null || \
       grep -q "^ID_LIKE=.*omarchy" /etc/os-release 2>/dev/null; then
      return 0
    fi
  fi

  # Method 2: Check for Omarchy-specific directories
  if [ -d "$HOME/.omarchy" ] || [ -d "/opt/omarchy" ] || [ -d "/etc/omarchy" ]; then
    return 0
  fi

  # Method 3: Check for Omarchy environment variables
  if [ -n "$OMARCHY_VERSION" ] || [ -n "$OMARCHY_HOME" ]; then
    return 0
  fi

  return 1
}

# Check if running on Fedora
# Returns 0 if Fedora detected, 1 otherwise
is_fedora() {
  if [ -f /etc/os-release ]; then
    if grep -q "^ID=fedora" /etc/os-release 2>/dev/null; then
      return 0
    fi
  fi
  return 1
}

# Check if running on Pop!_OS
# Returns 0 if Pop!_OS detected, 1 otherwise
is_popos() {
  if [ -f /etc/os-release ]; then
    if grep -q "^ID=pop" /etc/os-release 2>/dev/null; then
      return 0
    fi
  fi
  return 1
}

# ============================================
# Registry helpers (registry.toml)
# ============================================

REGISTRY_FILE="${DOTFILES_DIR}/registry.toml"

# Ensure the registry file exists
registry_ensure() {
  if [ ! -f "$REGISTRY_FILE" ]; then
    echo_error "Registry file not found: $REGISTRY_FILE"
    return 1
  fi
}

# Extract a simple quoted value for a key within a package section.
# Usage: _registry_value <package> <key>
_registry_value() {
  local pkg="$1"
  local key="$2"

  awk -v pkg="$pkg" -v key="$key" '
    /^\[.*\]$/ {
      gsub(/^\[|\]$/, "", $0)
      current = $0
      next
    }
    current == pkg {
      line = $0
      sub(/^[ \t]+/, "", line)
      if (line ~ "^" key "[ \t]*=") {
        sub(/^[^=]+=[ \t]*/, "", line)
        gsub(/^"|"$/, "", line)
        print line
        exit
      }
    }
  ' "$REGISTRY_FILE"
}

# Get the status of a package for a given OS
# Usage: registry_status <package> <os>
registry_status() {
  local pkg="$1"
  local os="$2"

  registry_ensure || return 1
  _registry_value "$pkg" "$os"
}

# Get the install method of a package (stow, link, custom, none)
# Usage: registry_method <package>
registry_method() {
  local pkg="$1"

  registry_ensure || return 1
  _registry_value "$pkg" "method"
}

# Get the link target of a package (only for method=link)
# Usage: registry_target <package>
registry_target() {
  local pkg="$1"

  registry_ensure || return 1
  _registry_value "$pkg" "target"
}

# List all packages marked active for a given OS
# Usage: registry_list_active <os>
registry_list_active() {
  local os="$1"

  registry_ensure || return 1

  awk -v os="$os" '
    /^\[.*\]$/ {
      gsub(/^\[|\]$/, "", $0)
      current = $0
      next
    }
    current != "" && current != "meta" {
      line = $0
      sub(/^[ \t]+/, "", line)
      if (line ~ "^" os "[ \t]*=[ \t]*\"active\"") {
        print current
        current = ""
      }
    }
  ' "$REGISTRY_FILE"
}

# Stow or link all active packages for the current OS
# Usage: stow_active_configs <os>
stow_active_configs() {
  local os="$1"

  echo_info "Synchronizing active configurations for $os..."

  if [ "${DRY_RUN:-false}" = true ]; then
    echo_info "[DRY RUN] Would synchronize active configurations for $os"
    return 0
  fi

  local active_pkgs
  active_pkgs=$(registry_list_active "$os") || return 1

  for pkg in $active_pkgs; do
    local method
    method=$(registry_method "$pkg")
    method=${method:-stow}

    case "$pkg" in
      zsh)
        echo_info "Skipping $pkg (handled by shell setup)"
        ;;
      wallpapers)
        echo_info "Skipping $pkg (manual copy)"
        ;;
      bin)
        echo_info "Linking $pkg scripts..."
        mkdir -p "$HOME/.local/bin"
        for script in "$DOTFILES_DIR/bin"/*; do
          [ -e "$script" ] || continue
          local basename
          basename=$(basename "$script")
          ln -sf "$script" "$HOME/.local/bin/$basename"
        done
        echo_success "Linked: bin -> $HOME/.local/bin"
        ;;
      *)
        if [ "$method" = "link" ]; then
          local target
          target=$(registry_target "$pkg")
          target="${target/\$HOME/$HOME}"
          if [ -z "$target" ]; then
            echo_error "No target configured for $pkg"
            continue
          fi
          mkdir -p "$(dirname "$target")"
          ln -sf "$DOTFILES_DIR/$pkg" "$target"
          echo_success "Linked: $pkg -> $target"
        elif [ "$method" = "stow" ]; then
          stow_config "$pkg"
        else
          echo_info "Skipping $pkg (method=$method)"
        fi
        ;;
    esac
  done
}
