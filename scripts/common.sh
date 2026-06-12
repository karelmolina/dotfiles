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
