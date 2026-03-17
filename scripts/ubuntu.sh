#!/bin/bash
# Pop!_OS specific installation script - Interactive Version

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

# ============================================
# Step Definitions
# ============================================
declare -A STEPS=(
    [1]="Update System"
    [2]="Core Dependencies"
    [3]="Terminal Emulators"
    [4]="Shell Setup (zsh + starship)"
    [5]="Fonts"
    [6]="Neovim Config"
    [7]="Development Tools (Rust, Go, mise)"
    [8]="Applications (Flatpak + APT)"
    [9]="Dotfiles Stow"
    [10]="Cursor IDE Config"
    [all]="Run All Steps"
)

# ============================================
# Step Functions
# ============================================

step1_update_system() {
    echo_info "Updating system packages..."
    sudo apt update
    sudo apt upgrade -y
    echo_success "System updated"
}

step2_core_deps() {
    echo_info "Installing core dependencies..."

    local failed_packages=()
    local installed_packages=()
    local skipped_packages=()

    # Helper function to check if package exists in repos
    package_exists() {
        apt-cache show "$1" &>/dev/null
    }

    # Helper function to try install a package
    try_install() {
        local pkg="$1"
        if dpkg -l "$pkg" &>/dev/null && dpkg-query -W -f='${Status}' "$pkg" 2>/dev/null | grep -q "install ok installed"; then
            echo_info "  $pkg already installed, skipping"
            skipped_packages+=("$pkg")
            return 0
        fi

        if ! package_exists "$pkg"; then
            echo_warn "  Package '$pkg' not found in repositories, skipping"
            failed_packages+=("$pkg (not found)")
            return 1
        fi

        echo_info "  Installing $pkg..."
        if sudo apt install -y "$pkg" 2>&1 | tee -a "$LOG_FILE"; then
            installed_packages+=("$pkg")
            return 0
        else
            echo_warn "  Failed to install $pkg"
            failed_packages+=("$pkg (install failed)")
            return 1
        fi
    }

    # Ensure add-apt-repository is available first (critical)
    echo_info "Ensuring software-properties-common is available..."
    sudo apt install -y software-properties-common || echo_warn "Failed to install software-properties-common"

    # Update package lists
    echo_info "Updating package lists..."
    sudo apt update || echo_warn "apt update had issues but continuing..."

    # Install build essentials
    echo_info "Installing build essentials..."
    try_install "build-essential"

    # Core development tools
    echo_info "Installing core development tools..."
    local core_packages=(
        git curl wget neovim zsh stow
        tree htop unzip zip p7zip-full
        fontconfig libfreetype6-dev g++ gcc cmake ninja-build
        python3-dev python3-pip clang
    )

    for pkg in "${core_packages[@]}"; do
        try_install "$pkg"
    done

    # Modern CLI tools (some may not exist in older Ubuntu)
    echo_info "Installing modern CLI tools..."
    local modern_tools=(
        ripgrep fd-find fzf jq yq httpie
        xclip wl-clipboard zoxide lazygit
    )

    for pkg in "${modern_tools[@]}"; do
        try_install "$pkg"
    done

    # Additional tools (these might have different names or not exist)
    echo_info "Installing additional tools..."
    local extra_tools=(
        git-cola git-delta meld vim bat exa btop
    )

    for pkg in "${extra_tools[@]}"; do
        try_install "$pkg"
    done

    # Install eza if exa failed (eza is the newer name)
    if [[ " ${failed_packages[*]} " =~ " exa " ]]; then
        echo_info "Trying eza as alternative to exa..."
        try_install "eza"
    fi

    # Summary
    echo ""
    echo "=============================================="
    echo "Core Dependencies Installation Summary"
    echo "=============================================="
    echo "Installed (${#installed_packages[@]}): ${installed_packages[*]}"
    echo "Already present (${#skipped_packages[@]}): ${skipped_packages[*]}"
    if [ ${#failed_packages[@]} -gt 0 ]; then
        echo_warn "Failed (${#failed_packages[@]}): ${failed_packages[*]}"
        echo_info "You may need to install these manually or they may not be available for your Ubuntu version"
    fi

    if [ ${#failed_packages[@]} -eq 0 ]; then
        echo_success "All core dependencies installed successfully"
    else
        echo_warn "Some packages failed but continuing..."
    fi
}

step3_terminals() {
    echo_info "Installing terminal emulators..."

    # WezTerm - need to add official APT repo
    if ! has_command wezterm; then
        echo_info "Installing WezTerm..."
        curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
        echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list
        sudo apt update
        sudo apt install -y wezterm
    fi

    # Kitty is available in default repos on Pop!_OS
    sudo apt install -y kitty

    # Ghostty terminal
    if ! has_command ghostty; then
        echo_info "Installing Ghostty..."
        # Ghostty not yet in official repos, use the COPR equivalent via build
        # For now, warn user
        echo_warn "Ghostty may need manual installation on Pop!_OS"
        echo_info "Visit: https://ghostty.org/docs/install/build"
    fi

    echo_success "Terminal emulators installed"
}

step4_shell() {
    echo_info "Setting up shell..."

    # oh-my-zsh
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    fi

    # Plugins
    if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
        git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    fi

    if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    fi

    # Starship
    if ! has_command starship; then
        echo_info "Installing Starship..."
        curl -sS https://starship.rs/install.sh | sh -s -- -y
    fi

    # Set zsh as default
    if [ "$SHELL" != "/bin/zsh" ]; then
        sudo usermod -s /bin/zsh "$USER"
        echo_warn "Shell changed to zsh. Please restart your terminal."
    fi

    echo_success "Shell configured"
}

step5_fonts() {
    echo_info "Installing fonts..."

    install_fonts "https://download.jetbrains.com/fonts/JetBrainsMono-2.304.zip" "JetBrains Mono"

    mkdir -p "$HOME/.local/share/fonts"
    cd /tmp
    curl -L -o nerd-fonts.zip "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/NerdFontsSymbolsOnly.zip"
    unzip -o nerd-fonts.zip -d "$HOME/.local/share/fonts/"
    fc-cache -f -v
    cd -

    echo_success "Fonts installed"
}

step6_nvim() {
    echo_info "Setting up Neovim..."

    if [ -d "$HOME/.config/nvim" ] && [ ! -L "$HOME/.config/nvim" ]; then
        mv "$HOME/.config/nvim" "$HOME/.config/nvim.backup.$(date +%Y%m%d%H%M%S)"
    fi

    ln -sf "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"
    echo_success "Neovim configured (run :Lazy sync in nvim)"
}

step7_dev_tools() {
    echo_info "Installing development tools..."

    # Rust
    if ! has_command cargo; then
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
        source "$HOME/.cargo/env"
    fi

    # Go
    if ! has_command go; then
        local GO_VERSION="1.23.4"
        wget -q "https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz" -O /tmp/go.tar.gz
        sudo rm -rf /usr/local/go
        sudo tar -C /usr/local -xzf /tmp/go.tar.gz
        echo 'export PATH=$PATH:/usr/local/go/bin' >> "$HOME/.zshrc"
        rm /tmp/go.tar.gz
    fi

    # mise
    if ! has_command mise; then
        curl https://mise.run | sh
        echo 'eval "$(mise activate zsh)"' >> "$HOME/.zshrc"
        # Trust the mise config file to prevent LSP issues
        "$HOME/.local/bin/mise" trust ~/dotfiles/mise/config.toml 2>/dev/null || true
    fi

    #node
    if ! has_command node; then
        # ask for node version
        read -p "Enter node version: " NODE_VERSION
        echo_info "Installing node..."
        mise install node@"$NODE_VERSION:20"
    fi

    # opencode
    if ! has_command opencode; then
        echo_info "Installing opencode..."
        curl -fsSL https://opencode.ai/install | bash
    fi

    # tree-sitter-cli (required by nvim-treesitter)
    echo_info "Installing tree-sitter-cli..."
    cargo install tree-sitter-cli
    echo_info "Installing git-cliff..."
    cargo install git-cliff
    echo_info "Installing eza..."
    cargo install eza
    echo_info "Installing go..."
    mise install go

    echo_success "Development tools installed"
}

step8_apps() {
    echo_info "Installing applications..."

    sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

    local flatpak_apps=(
        "app.zen_browser.zen"
        "com.spotify.Client"
        "com.google.Chrome"
        "com.getpostman.Postman"
        "com.mongodb.Compass"
        "io.dbeaver.DBeaverCommunity"
        "com.github.marhkb.Pods"
        "com.bitwarden.desktop"
    )

    for app in "${flatpak_apps[@]}"; do
        if ! flatpak list | grep -q "$app"; then
            echo_info "Installing $app..."
            sudo flatpak install -y flathub "$app" || echo_warn "Failed to install $app"
        fi
    done

    # Install OpenVPN3 client
    echo_info "Installing OpenVPN3 client..."
    # Try to add official OpenVPN repo
    if ! grep -q "openvpn" /etc/apt/sources.list.d/*.list 2>/dev/null; then
        sudo wget -qO - https://swupdate.openvpn.net/repos/repo-public.gpg | sudo apt-key add - || echo_warn "APT key add may have failed"
        echo "deb https://build.openvpn.net/debian/openvpn/stable pop main" | sudo tee /etc/apt/sources.list.d/openvpn-aptrepo.list
        sudo apt update || echo_warn "APT update may have failed"
    fi
    sudo apt install -y openvpn3 || echo_warn "OpenVPN3 client install failed, may need manual install"

    # Install lazydocker
    if ! has_command lazydocker; then
        echo_info "Installing lazydocker..."
        curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash
    fi

    # Enable podman socket for lazydocker (user-level)
    echo_info "Setting up podman socket for lazydocker..."
    systemctl --user enable --now podman.socket || echo_warn "Failed to enable podman socket, you may need to run: systemctl --user enable --now podman.socket"

    echo_success "Applications installed"
}

step9_stow() {
    echo_info "Stowing dotfiles..."

    mkdir -p "$HOME/.config" "$HOME/.local/bin" "$HOME/.local/share/fonts"

    stow_config "nvim"
    stow_config "wezterm"
    stow_config "kitty"
    stow_config "ghostty"
    stow_config "mise"
    stow_config "btop"
    stow_config "lazygit"
    stow_config "zsh" "$HOME/.oh-my-zsh/custom"

    dotlink "zsh/zshrc" ".zshrc"
    dotlink "zsh/starship.toml" ".config/starship.toml"
    dotlink "mise/config.toml" ".config/mise/config.toml"

    echo_success "Dotfiles stowed"
}

step10_cursor() {
    echo_info "Setting up Cursor IDE configuration..."

    # Check if cursor is installed
    if ! has_command cursor; then
        echo_warn "Cursor not found in PATH. You can install it from https://cursor.sh/"
        echo_info "The configuration will be ready when you install Cursor."
    fi

    # Symlink cursor config directory
    if [ -d "$HOME/.cursor" ] && [ ! -L "$HOME/.cursor" ]; then
        echo_warn "Backing up existing ~/.cursor directory"
        mv "$HOME/.cursor" "$HOME/.cursor.backup.$(date +%Y%m%d%H%M%S)"
    fi

    ln -sf "$DOTFILES_DIR/cursor" "$HOME/.cursor"
    echo_success "Linked cursor config directory"

    # Copy cursorrules template to dotfiles root if not exists
    if [ ! -f "$DOTFILES_DIR/.cursorrules" ]; then
        cp "$DOTFILES_DIR/cursor/cursorrules.template" "$DOTFILES_DIR/.cursorrules"
        echo_info "Created .cursorrules template in dotfiles root"
        echo_info "Edit .cursorrules to customize project context"
    fi

    echo_info "To use in any project:"
    echo_info "  ln -s ~/dotfiles/cursor ~/.cursor"
    echo_info "  cp ~/dotfiles/cursor/cursorrules.template .cursorrules"
    echo_success "Cursor configuration ready"
}

# ============================================
# Interactive Menu
# ============================================
show_menu() {
    echo ""
    echo "=============================================="
    echo "Pop!_OS Dotfiles Installation Menu"
    echo "=============================================="
    echo ""
    echo "Available steps:"
    echo ""

    for key in "${!STEPS[@]}"; do
        if [[ "$key" =~ ^[0-9]+$ ]]; then
            printf "  [%2s] %s\n" "$key" "${STEPS[$key]}"
        fi
    done

    echo ""
    echo "  [all] ${STEPS[all]}"
    echo ""
    echo "  [q]  Quit"
    echo ""
    echo "Usage examples:"
    echo "  - Enter '4' to run step 4 (Shell Setup)"
    echo "  - Enter '6 10' to run steps 6 and 10"
    echo "  - Enter '4-7' to run steps 4 through 7"
    echo "  - Enter 'all' to run everything"
    echo ""
}

parse_selection() {
    local input="$1"
    local -a selected=()

    if [[ "$input" == "all" ]] || [[ "$input" == "ALL" ]]; then
        for i in {1..10}; do
            selected+=($i)
        done
    elif [[ "$input" =~ ^[0-9]+-[0-9]+$ ]]; then
        local start=${input%-*}
        local end=${input#*-}
        for ((i=start; i<=end; i++)); do
            selected+=($i)
        done
    else
        for item in $input; do
            if [[ "$item" =~ ^[0-9]+$ ]] && [ "$item" -ge 1 ] && [ "$item" -le 10 ]; then
                selected+=($item)
            fi
        done
    fi

    # Remove duplicates and sort
    printf '%s\n' "${selected[@]}" | sort -n | uniq
}

run_step() {
    local step=$1
    echo ""
    echo "----------------------------------------------"
    echo "Running: ${STEPS[$step]}"
    echo "----------------------------------------------"

    case $step in
        1) step1_update_system ;;
        2) step2_core_deps ;;
        3) step3_terminals ;;
        4) step4_shell ;;
        5) step5_fonts ;;
        6) step6_nvim ;;
        7) step7_dev_tools ;;
        8) step8_apps ;;
        9) step9_stow ;;
        10) step10_cursor ;;
    esac
}

# ============================================
# Main Interactive Loop
# ============================================
main_interactive() {
    # Ensure dotfiles are available first
    ensure_dotfiles

    while true; do
        show_menu

        echo -n "Select steps to run: "
        read -r selection

        if [[ "$selection" == "q" ]] || [[ "$selection" == "Q" ]]; then
            echo "Goodbye!"
            exit 0
        fi

        if [[ -z "$selection" ]]; then
            echo_warn "No selection made. Please try again."
            continue
        fi

        echo ""
        echo "Starting installation..."
        echo ""

        # Parse and run selected steps
        local steps_to_run=$(parse_selection "$selection")

        if [ -z "$steps_to_run" ]; then
            echo_warn "Invalid selection. Please try again."
            continue
        fi

        for step in $steps_to_run; do
            run_step "$step" || echo_warn "Step $step failed but continuing..."
        done

        echo ""
        echo "=============================================="
        echo "Selected steps completed!"
        echo "=============================================="
        echo ""

        echo -n "Run more steps? [y/N]: "
        read -r continue_choice

        if [[ ! "$continue_choice" =~ ^[Yy]$ ]]; then
            echo "Done! You may need to restart your terminal for all changes to take effect."
            break
        fi
    done
}

# ============================================
# Non-interactive mode for install script
# ============================================
run_all() {
    ensure_dotfiles

    echo "=============================================="
    echo "Pop!_OS Dotfiles Installation (Full)"
    echo "=============================================="
    echo ""

    for i in {1..10}; do
        run_step $i || echo_warn "Step $i had issues but continuing..."
    done

    echo ""
    echo "=============================================="
    echo "Installation Complete!"
    echo "=============================================="
    echo ""
    echo "Next steps:"
    echo "1. Log out and back in for all changes to take effect"
    echo "2. Open nvim and run :Lazy sync to install plugins"
    echo ""
}

# ============================================
# Entry Point
# ============================================
main() {
    # Check for flags
    if [[ "$1" == "--all" ]] || [[ "$1" == "-a" ]]; then
        run_all
    elif [[ "$1" == "--help" ]] || [[ "$1" == "-h" ]]; then
        echo "Pop!_OS Dotfiles Installer"
        echo ""
        echo "Usage:"
        echo "  ./install              # Interactive menu"
        echo "  ./install --all, -a    # Run all steps non-interactively"
        echo "  ./install --help, -h   # Show this help"
        echo ""
        echo "Or run the Pop!_OS script directly:"
        echo "  ./scripts/popos.sh           # Interactive mode"
        echo "  ./scripts/popos.sh --all     # Run all steps"
    else
        main_interactive
    fi
}

main "$@"
