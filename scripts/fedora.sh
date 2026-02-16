#!/bin/bash
# Fedora 43 specific installation script - Interactive Version

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
    [8]="Applications (Flatpak + DNF)"
    [9]="Dotfiles Stow"
    [all]="Run All Steps"
)

# ============================================
# Step Functions (unchanged from before)
# ============================================

step1_update_system() {
    echo_info "Updating system packages..."
    sudo dnf upgrade --refresh -y
    echo_success "System updated"
}

step2_core_deps() {
    echo_info "Installing core dependencies..."

    # Enable RPM Fusion repositories
    sudo dnf install -y \
        https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
        https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

    sudo dnf groupinstall -y "Development Tools"

    sudo dnf install -y \
        git curl wget neovim ripgrep fd-find fzf zsh stow \
        tree htop unzip zip p7zip jq yq httpie \
        xclip wl-clipboard gnome-tweaks gnome-extensions-app \
        fontconfig freetype g++ gcc cmake ninja-build \
        python3-devel python3-pip nodejs npm clang-libs \
        clang

    echo_success "Core dependencies installed"
}

step3_terminals() {
    echo_info "Installing terminal emulators..."

    sudo dnf copr enable -y wezfurlong/wezterm-nightly
    sudo dnf install -y wezterm kitty

    # Ghostty terminal
    if ! has_command ghostty; then
        echo_info "Installing Ghostty..."
        sudo dnf copr enable -y scottames/ghostty
        sudo dnf install -y ghostty
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
    fi

    # tree-sitter-cli (required by nvim-treesitter)
    echo_info "Installing tree-sitter-cli..."
    cargo install tree-sitter-cli

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
        "org.ferdium.Ferdium"
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

    sudo dnf install -y git-cola meld vim-enhanced neofetch bat eza zoxide atuin btop

    # Install OpenVPN3 client
    echo_info "Installing OpenVPN3 client..."
    sudo dnf copr enable -y dsommers/openvpn3 || echo_warn "COPR repo already enabled or failed"
    sudo dnf install -y openvpn3-client || echo_warn "OpenVPN3 client install failed, may need manual install"

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
    stow_config "zsh" "$HOME/.oh-my-zsh/custom"

    dotlink "zsh/zshrc" ".zshrc"
    dotlink "zsh/zshenv" ".zshenv"
    dotlink "zsh/starship.toml" ".config/starship.toml"
    dotlink "mise/config.toml" ".config/mise/config.toml"

    echo_success "Dotfiles stowed"
}

# ============================================
# Interactive Menu
# ============================================
show_menu() {
    echo ""
    echo "=============================================="
    echo "Fedora 43 Dotfiles Installation Menu"
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
            if [[ "$item" =~ ^[0-9]+$ ]] && [ "$item" -ge 1 ] && [ "$item" -le 9 ]; then
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
    echo "Fedora 43 Dotfiles Installation (Full)"
    echo "=============================================="
    echo ""

    for i in {1..9}; do
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
        echo "Fedora 43 Dotfiles Installer"
        echo ""
        echo "Usage:"
        echo "  ./install              # Interactive menu"
        echo "  ./install --all, -a    # Run all steps non-interactively"
        echo "  ./install --help, -h   # Show this help"
        echo ""
        echo "Or run the fedora script directly:"
        echo "  ./scripts/fedora.sh           # Interactive mode"
        echo "  ./scripts/fedora.sh --all     # Run all steps"
    else
        main_interactive
    fi
}

main "$@"
