#!/bin/bash
# macOS installation script

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

DRY_RUN=false

# ============================================
# Core Functions
# ============================================

detect_brew() {
  if ! has_command brew; then
    echo_info "Homebrew not found. Installing..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

  # Ensure brew is available in this shell
  if [ -f /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [ -f /usr/local/bin/brew ]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
}

command_for_package() {
  case "$1" in
    neovim) echo "nvim" ;;
    ripgrep) echo "rg" ;;
    fd) echo "fd" ;;
    *) echo "$1" ;;
  esac
}

install_packages() {
  echo_info "Installing packages via Homebrew..."

  detect_brew

  local packages=(
    git
    stow
    zsh
    neovim
    ripgrep
    fd
    fzf
    starship
    atuin
    mise
    lazygit
    btop
    kitty
    ghostty
    wezterm
    lazysql
  )

  for pkg in "${packages[@]}"; do
    local cmd
    cmd=$(command_for_package "$pkg")

    if has_command "$cmd"; then
      echo_info "$pkg already available ($cmd)"
      continue
    fi

    if brew list "$pkg" &>/dev/null; then
      echo_info "$pkg already installed via Homebrew"
      continue
    fi

    if [ "$DRY_RUN" = true ]; then
      echo_info "[DRY RUN] Would install Homebrew package: $pkg"
      continue
    fi

    echo_info "Installing $pkg..."
    brew install "$pkg" || echo_warn "Failed to install $pkg"
  done
}

setup_zsh() {
  echo_info "Setting up zsh..."

  if [ "$DRY_RUN" = true ]; then
    echo_info "[DRY RUN] Would configure zsh"
    return 0
  fi

  # Install oh-my-zsh
  if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo_info "Installing oh-my-zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  else
    echo_info "oh-my-zsh already installed"
  fi

  # Install zsh plugins
  local zsh_custom="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

  if [ ! -d "$zsh_custom/plugins/zsh-autosuggestions" ]; then
    echo_info "Installing zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions "$zsh_custom/plugins/zsh-autosuggestions"
  fi

  if [ ! -d "$zsh_custom/plugins/zsh-syntax-highlighting" ]; then
    echo_info "Installing zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$zsh_custom/plugins/zsh-syntax-highlighting"
  fi

  dotlink "zsh/zshrc" ".zshrc"
  dotlink "zsh/starship.toml" ".config/starship.toml"

  # Set zsh as default shell
  if [ "$SHELL" != "/bin/zsh" ] && [ "$SHELL" != "/usr/local/bin/zsh" ]; then
    echo_info "Setting zsh as default shell..."
    if has_command zsh; then
      chsh -s "$(command -v zsh)" || echo_warn "Could not change default shell"
    fi
  fi
}

configure_git_hooks() {
  echo_info "Configuring git hooks..."

  if [ "$DRY_RUN" = true ]; then
    echo_info "[DRY RUN] Would configure git hooks"
    return 0
  fi

  if [ -d "$DOTFILES_DIR/.git" ]; then
    (cd "$DOTFILES_DIR" && git config core.hooksPath .githooks)
    echo_success "Git hooks configured"
  fi
}

# ============================================
# Main Execution
# ============================================

show_help() {
  cat << 'EOF'
macOS Dotfiles Installer
========================

Installs and synchronizes dotfiles on macOS using Homebrew and GNU Stow.

USAGE:
  ./scripts/macos.sh [OPTIONS] [STEPS...]

OPTIONS:
  -h, --help      Show this help message
  -d, --dry-run   Show what would be done without executing
  -a, --all       Run all steps

STEPS:
  1  Install Homebrew and packages
  2  Shell setup (zsh + oh-my-zsh)
  3  Synchronize active dotfiles
  4  Configure git hooks
  all Run all steps

EXAMPLES:
  ./scripts/macos.sh              # Interactive mode
  ./scripts/macos.sh --all        # Run all steps
  ./scripts/macos.sh --dry-run    # Preview changes

EOF
}

show_menu() {
  echo ""
  echo "=============================================="
  echo "macOS Dotfiles Installation Menu"
  echo "=============================================="
  echo ""
  echo "Available steps:"
  echo ""
  echo "  [1] Install Homebrew and packages"
  echo "  [2] Shell setup (zsh + oh-my-zsh)"
  echo "  [3] Synchronize active dotfiles"
  echo "  [4] Configure git hooks"
  echo ""
  echo "  [all] Run All Steps"
  echo ""
  echo "  [q]  Quit"
  echo ""
}

step_name() {
  case "$1" in
    1) echo "Install Homebrew and packages" ;;
    2) echo "Shell setup (zsh + oh-my-zsh)" ;;
    3) echo "Synchronize active dotfiles" ;;
    4) echo "Configure git hooks" ;;
    *) echo "Unknown step" ;;
  esac
}

run_step() {
  local step=$1

  case "$step" in
    1|2|3|4)
      echo ""
      echo "----------------------------------------------"
      echo "Running Step $step: $(step_name "$step")"
      echo "----------------------------------------------"
      ;;
    *)
      echo_error "Invalid step: $step"
      return 1
      ;;
  esac

  case $step in
    1)
      install_packages
      ;;
    2)
      setup_zsh
      ;;
    3)
      stow_active_configs "macos"
      ;;
    4)
      configure_git_hooks
      ;;
  esac

  echo_success "Step $step completed"
  return 0
}

run_all_steps() {
  echo "=============================================="
  echo "macOS Dotfiles Installation (Full)"
  echo "=============================================="
  echo ""

  local failed=0

  for i in {1..4}; do
    run_step "$i" || {
      echo_warn "Step $i had issues but continuing..."
      failed=$((failed + 1))
    }
  done

  echo ""
  echo "=============================================="
  if [ $failed -eq 0 ]; then
    echo "Installation Complete!"
  else
    echo "Installation completed with $failed warning(s)"
  fi
  echo "=============================================="
  echo ""
  echo "Next steps:"
  echo "1. Restart your terminal"
  echo "2. Run 'nvim --headless \"+Lazy! sync\" +qa' to install plugins"
  echo "3. Run 'mise install' to install dev tools"
  echo ""
}

run_interactive() {
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

    if [[ "$selection" == "all" ]] || [[ "$selection" == "ALL" ]]; then
      run_all_steps
      break
    fi

    for step in $selection; do
      if [[ "$step" =~ ^[1-4]$ ]]; then
        run_step "$step" || echo_warn "Step $step failed but continuing..."
      else
        echo_warn "Invalid step: $step"
      fi
    done

    echo ""
    echo -n "Run more steps? [y/N]: "
    read -r continue_choice

    if [[ ! "$continue_choice" =~ ^[Yy]$ ]]; then
      echo "Done! You may need to restart your terminal for all changes to take effect."
      break
    fi
  done
}

main() {
  while [[ $# -gt 0 ]]; do
    case $1 in
      -h|--help)
        show_help
        exit 0
        ;;
      -d|--dry-run)
        DRY_RUN=true
        echo_info "DRY RUN mode enabled - no changes will be made"
        shift
        ;;
      -a|--all)
        run_all_steps
        exit 0
        ;;
      [1-4]|all)
        run_step "$1"
        shift
        ;;
      *)
        echo_error "Unknown option: $1"
        show_help
        exit 1
        ;;
    esac
  done

  # No arguments: interactive mode
  run_interactive
}

main "$@"
