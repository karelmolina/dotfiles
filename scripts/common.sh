#!/bin/bash
# Common functions used across all OS install scripts

set -e

# Logging
LOG_FILE="${LOG_FILE:-$HOME/.dotfiles-install.log}"
BASEDIR="$HOME"
DOTFILES_DIR="$HOME/dotfiles"

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

# Stow alternative - create symlinks for config directories
stow_config() {
    local pkg="$1"
    local target_dir="${2:-$HOME/.config}"
    local src="$DOTFILES_DIR/$pkg"
    
    if [ ! -d "$src" ]; then
        echo_error "Package $pkg not found in dotfiles"
        return 1
    fi
    
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
    
    echo_success "Stowed: $pkg"
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
