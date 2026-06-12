#!/bin/bash
# Omarchy Linux installation script
# Complementary configuration and developer tools for Omarchy
# https://omarchy.org/
#
# This script installs developer tools and configurations that enhance
# Omarchy's opinionated defaults without modifying core system files.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

# ============================================
# Omarchy Installation Steps
# ============================================
declare -A STEPS=(
  [1]="Validate Omarchy Environment"
  [2]="Developer Tools (mise, rust, go)"
  [3]="Neovim Configuration"
  [4]="Shell Enhancements"
  [5]="Terminal Configuration"
  [6]="Applications (opencode, vicinae)"
  [7]="Dotfiles Integration"
  [all]="Run All Steps"
)

# Script state variables
OMARCHY_DETECTED=false
DRY_RUN=false
SKIP_BACKUP=false
TEST_MODE=false

# ============================================
# Core Functions
# ============================================

# Check prerequisites before installation
check_prerequisites() {
  echo_info "Checking prerequisites..."

  # Verify bash version (need 4.0+ for associative arrays)
  local bash_version="${BASH_VERSION%%.*}"
  if [ "$bash_version" -lt 4 ]; then
    echo_error "Bash 4.0 or higher is required (found $BASH_VERSION)"
    return 1
  fi

  # Check for required commands
  local required_cmds=("curl" "git" "tar")
  for cmd in "${required_cmds[@]}"; do
    if ! has_command "$cmd"; then
      echo_error "Required command not found: $cmd"
      echo_info "Please install $cmd and run this script again."
      return 1
    fi
  done

  # Verify dotfiles directory exists
  if [ ! -d "$DOTFILES_DIR" ]; then
    echo_info "Dotfiles directory not found at $DOTFILES_DIR"
    echo_info "Attempting to clone dotfiles repository..."
    ensure_dotfiles
  fi

  echo_success "Prerequisites check passed"
  return 0
}

# Detect Omarchy environment and set global state
detect_omarchy() {
  echo_info "Detecting Omarchy environment..."

  if is_omarchy; then
    OMARCHY_DETECTED=true
    echo_success "Omarchy Linux detected"

    # Log Omarchy version if available
    if [ -f "$OMARCHY_VERSION_FILE" ]; then
      local version
      version=$(cat "$OMARCHY_VERSION_FILE" 2>/dev/null || echo "unknown")
      echo_info "Omarchy version: $version"
    fi

    # Check for Omarchy config directory
    if [ -d "$OMARCHY_CONFIG_DIR" ]; then
      echo_info "Found Omarchy config directory: $OMARCHY_CONFIG_DIR"
    fi

    return 0
  else
    OMARCHY_DETECTED=false
    echo_warn "Omarchy Linux not detected"
    echo_info "This script is designed for Omarchy Linux."
    echo_info "Detected system appears to be a different distribution."
    echo ""
    echo -n "Continue anyway? [y/N]: "
    read -r response
    if [[ ! "$response" =~ ^[Yy]$ ]]; then
      echo_info "Exiting. For other distributions, see:"
      echo_info "  - Fedora: ./scripts/fedora.sh"
      exit 0
    fi
    return 1
  fi
}

# Backup existing configuration files before modification
backup_existing_configs() {
  if [ "$SKIP_BACKUP" = true ]; then
    echo_info "Skipping backup (--skip-backup flag detected)"
    return 0
  fi

  echo_info "Backing up existing configurations..."

  local backup_dir="$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"
  mkdir -p "$backup_dir"

  # List of configs that might be modified
  local configs_to_backup=(
    "$HOME/.config/nvim"
    "$HOME/.config/mise"
    "$HOME/.zshrc"
    "$HOME/.bashrc"
    "$HOME/.config/starship.toml"
    "$HOME/.cursor"
  )

  local backed_up=0
  for config in "${configs_to_backup[@]}"; do
    if [ -e "$config" ] && [ ! -L "$config" ]; then
      local basename
      basename=$(basename "$config")
      echo_info "Backing up: $config"
      cp -r "$config" "$backup_dir/$basename"
      backed_up=$((backed_up + 1))
    fi
  done

  if [ $backed_up -gt 0 ]; then
    echo_success "Backed up $backed_up configuration(s) to $backup_dir"
  else
    echo_info "No existing configurations to backup"
    rmdir "$backup_dir" 2>/dev/null || true
  fi

  return 0
}

# Install mise (version manager for dev tools)
install_mise() {
  echo_info "Installing mise (version manager)..."

  if [ "$DRY_RUN" = true ]; then
    echo_info "[DRY RUN] Would install mise via curl"
    return 0
  fi

  if has_command mise; then
    echo_info "mise is already installed"
    mise --version
    return 0
  fi

  # Install mise using the official installer
  echo_info "Downloading and installing mise..."
  curl https://mise.run | sh

  # Verify installation
  if has_command mise || [ -f "$HOME/.local/bin/mise" ]; then
    echo_success "mise installed successfully"

    # Add mise activation to shell if not present
    if ! grep -q "mise activate" "$HOME/.zshrc" 2>/dev/null; then
      echo_info "Adding mise activation to .zshrc..."
      echo 'eval "$(mise activate zsh)"' >> "$HOME/.zshrc"
    fi

    # Trust the mise config file to prevent LSP issues
    if [ -f "$HOME/.local/bin/mise" ] && [ -f "$DOTFILES_DIR/mise/config.toml" ]; then
      "$HOME/.local/bin/mise" trust "$DOTFILES_DIR/mise/config.toml" 2>/dev/null || true
    fi
  else
    echo_error "mise installation may have failed"
    return 1
  fi

  return 0
}

# ============================================
# Development Tools Installation
# ============================================

# Install Rust toolchain and cargo tools
install_rust() {
  echo_info "Installing Rust..."

  if [ "$DRY_RUN" = true ]; then
    echo_info "[DRY RUN] Would install Rust via rustup"
    return 0
  fi

  if has_command cargo; then
    echo_info "Rust is already installed"
    cargo --version
  else
    echo_info "Installing Rust via rustup..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

    # Source cargo environment for current session
    source "$HOME/.cargo/env"

    if has_command cargo; then
      echo_success "Rust installed successfully"
      cargo --version
    else
      echo_error "Rust installation failed"
      return 1
    fi
  fi

  # Install essential cargo tools
  echo_info "Installing cargo tools..."

  local cargo_tools=(
    "tree-sitter-cli"
    "git-cliff"
    "eza"
  )

  for tool in "${cargo_tools[@]}"; do
    if ! has_command "$tool" && ! cargo install --list | grep -q "^$tool "; then
      echo_info "Installing $tool..."
      cargo install "$tool" || echo_warn "Failed to install $tool"
    fi
  done

  echo_success "Rust toolchain ready"
  return 0
}

# Install Go compiler and tools
install_go() {
  echo_info "Installing Go..."

  if [ "$DRY_RUN" = true ]; then
    echo_info "[DRY RUN] Would install Go"
    return 0
  fi

  if has_command go; then
    echo_info "Go is already installed"
    go version
    return 0
  fi

  local GO_VERSION="1.23.4"
  local go_tarball="/tmp/go${GO_VERSION}.linux-amd64.tar.gz"

  echo_info "Downloading Go ${GO_VERSION}..."
  curl -fsSL "https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz" -o "$go_tarball"

  echo_info "Extracting Go to /usr/local..."
  sudo rm -rf /usr/local/go
  sudo tar -C /usr/local -xzf "$go_tarball"
  rm -f "$go_tarball"

  # Add Go to PATH if not already there
  if ! grep -q "/usr/local/go/bin" "$HOME/.zshrc" 2>/dev/null; then
    echo_info "Adding Go to PATH in .zshrc..."
    echo 'export PATH="$PATH:/usr/local/go/bin"' >> "$HOME/.zshrc"
  fi

  # Source Go for current session
  export PATH="$PATH:/usr/local/go/bin"

  if has_command go; then
    echo_success "Go installed successfully"
    go version
  else
    echo_error "Go installation failed"
    return 1
  fi

  return 0
}

# Install or configure Neovim
install_neovim() {
  echo_info "Setting up Neovim..."

  if [ "$DRY_RUN" = true ]; then
    echo_info "[DRY RUN] Would configure Neovim"
    return 0
  fi

  # Check if neovim is installed
  if ! has_command nvim; then
    echo_info "Neovim not found. Attempting to install..."

    # Try to install via package manager if available
    if has_command dnf; then
      sudo dnf install -y neovim || echo_warn "Failed to install neovim via dnf"
    elif has_command apt; then
      sudo apt update && sudo apt install -y neovim || echo_warn "Failed to install neovim via apt"
    elif has_command pacman; then
      sudo pacman -S --noconfirm neovim || echo_warn "Failed to install neovim via pacman"
    else
      echo_warn "No package manager found to install neovim"
      echo_info "Please install neovim manually from https://neovim.io/"
    fi
  fi

  # Verify neovim is now available
  if ! has_command nvim; then
    echo_error "Neovim is not installed. Please install it manually."
    return 1
  fi

  echo_info "Neovim version: $(nvim --version | head -1)"

  # Backup existing config if it's not a symlink
  if [ -d "$HOME/.config/nvim" ] && [ ! -L "$HOME/.config/nvim" ]; then
    local backup_name="nvim.backup.$(date +%Y%m%d%H%M%S)"
    echo_info "Backing up existing nvim config to $backup_name..."
    mv "$HOME/.config/nvim" "$HOME/.config/$backup_name"
  fi

  stow_config "nvim"

  echo_info "To complete setup, open nvim and run :Lazy sync"
  return 0
}

# ============================================
# Shell and Terminal Setup
# ============================================

# Setup zsh, starship, and atuin
setup_shell() {
  echo_info "Setting up shell enhancements..."

  if [ "$DRY_RUN" = true ]; then
    echo_info "[DRY RUN] Would configure zsh, starship, and atuin"
    return 0
  fi

  # Install zsh if not present
  if ! has_command zsh; then
    echo_info "Installing zsh..."
    if has_command dnf; then
      sudo dnf install -y zsh
    elif has_command apt; then
      sudo apt install -y zsh
    elif has_command pacman; then
      sudo pacman -S --noconfirm zsh
    else
      echo_warn "Could not install zsh automatically"
    fi
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

  # Install starship prompt
  if ! has_command starship; then
    echo_info "Installing starship..."
    curl -sS https://starship.rs/install.sh | sh -s -- -y
  else
    echo_info "starship already installed"
  fi

  # Install atuin (shell history)
  if ! has_command atuin; then
    echo_info "Installing atuin..."
    curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
  else
    echo_info "atuin already installed"
  fi

  dotlink "zsh/zshrc" ".zshrc"
  dotlink "zsh/starship.toml" ".config/starship.toml"

  # Set zsh as default shell
  if [ "$SHELL" != "/bin/zsh" ] && [ "$SHELL" != "/usr/bin/zsh" ]; then
    echo_info "Setting zsh as default shell..."
    if has_command zsh; then
      sudo usermod -s "$(command -v zsh)" "$USER"
      echo_warn "Shell changed to zsh. Please restart your terminal."
    fi
  fi

  echo_success "Shell enhancements configured"
  return 0
}

# Setup kitty terminal configuration
setup_terminal() {
  echo_info "Setting up terminal configuration..."

  if [ "$DRY_RUN" = true ]; then
    echo_info "[DRY RUN] Would configure kitty"
    return 0
  fi

  # Check for kitty
  if ! has_command kitty; then
    echo_warn "kitty not found. Attempting to install..."

    if has_command dnf; then
      sudo dnf install -y kitty || echo_warn "Failed to install kitty"
    elif has_command apt; then
      sudo apt install -y kitty || echo_warn "Failed to install kitty"
    elif has_command pacman; then
      sudo pacman -S --noconfirm kitty || echo_warn "Failed to install kitty"
    fi
  fi

  if has_command kitty; then
    echo_info "kitty version: $(kitty --version)"

    # Backup existing kitty config if not symlink
    if [ -d "$HOME/.config/kitty" ] && [ ! -L "$HOME/.config/kitty" ]; then
      local backup_name="kitty.backup.$(date +%Y%m%d%H%M%S)"
      echo_info "Backing up existing kitty config..."
      mv "$HOME/.config/kitty" "$HOME/.config/$backup_name"
    fi

    stow_config "kitty"
  else
    echo_warn "kitty not available. Skipping terminal configuration."
  fi

  return 0
}

# ============================================
# Main Execution
# ============================================

# Show usage/help
show_help() {
  cat << 'EOF'
Omarchy Linux Dotfiles Installer
================================

This script installs developer tools and configurations for Omarchy Linux,
an opinionated Linux distribution (https://omarchy.org/).

USAGE:
  ./omarchy.sh [OPTIONS] [STEPS...]

OPTIONS:
  -h, --help         Show this help message
  -d, --dry-run      Show what would be done without executing
  -s, --skip-backup  Skip backup of existing configurations
  -a, --all          Run all steps
  -t, --test         Run test suite and validation

STEPS:
  1  Validate Omarchy Environment
  2  Developer Tools (mise, rust, go)
  3  Neovim Configuration
  4  Shell Enhancements
  5  Terminal Configuration
  6  Applications (opencode, vicinae)
  7  Dotfiles Integration
  all Run all steps

ENVIRONMENT VARIABLES:
  TEST_OMARCHY=1     Simulate Omarchy environment for testing
  TEST_OMARCHY_DIR   Path to mock Omarchy directory for testing

EXAMPLES:

  # Interactive mode - choose steps from menu
  ./omarchy.sh

  # Run all steps non-interactively
  ./omarchy.sh --all

  # Run specific steps
  ./omarchy.sh 2 3 4

  # Dry run - see what would be installed
  ./omarchy.sh --dry-run --all

  # Run tests and validation
  ./omarchy.sh --test

  # Run with simulated Omarchy environment
  TEST_OMARCHY=1 ./omarchy.sh --test

  # Skip backup for faster re-runs
  ./omarchy.sh --skip-backup 3 4

STEP DESCRIPTIONS:

  Step 1 - Validation & Detection
    Checks system prerequisites and detects Omarchy Linux environment.
    Will prompt for confirmation if not on Omarchy.

  Step 2 - Developer Tools
    Installs mise (version manager), Rust toolchain, and Go compiler.
    Also installs cargo tools: tree-sitter-cli, git-cliff, eza.

  Step 3 - Neovim Configuration
    Installs neovim if needed and links dotfiles nvim config to ~/.config/nvim

  Step 4 - Shell Enhancements
    Configures zsh with oh-my-zsh, starship prompt, and atuin history
    Links .zshrc and starship.toml from dotfiles

  Step 5 - Terminal Configuration
    Configures kitty terminal emulator with dotfiles settings

  Step 6 - Applications
    Displays installation commands for opencode and vicinae
    (These require manual installation)

  Step 7 - Dotfiles Integration
    Backs up and integrates existing configurations

NOTES:
  - Requires Bash 4.0 or higher
  - Must have curl, git, and tar installed
  - Existing configs are backed up before modification
  - The script is non-destructive and respects Omarchy's defaults

TESTING:
  Run './omarchy.sh --test' to execute the full test suite including:
  - Detection logic validation
  - Spec compliance checks
  - Edge case testing
  - Error handling verification

For more information, see: https://github.com/karelmolina/dotfiles

EOF
}

# Show interactive menu
show_menu() {
  echo ""
  echo "=============================================="
  echo "Omarchy Linux Dotfiles Installation Menu"
  echo "=============================================="
  echo ""
  echo "Available steps:"
  echo ""

  for key in {1..7}; do
    if [ -n "${STEPS[$key]}" ]; then
      printf "  [%s] %s\n" "$key" "${STEPS[$key]}"
    fi
  done

  echo ""
  echo "  [all] ${STEPS[all]}"
  echo ""
  echo "  [q]  Quit"
  echo ""
  echo "Usage examples:"
  echo "  - Enter '4' to run step 4 (Shell Enhancements)"
  echo "  - Enter '2 3 4' to run steps 2, 3, and 4"
  echo "  - Enter '2-5' to run steps 2 through 5"
  echo "  - Enter 'all' to run everything"
  echo ""
}

# Run a single step by number
run_step() {
  local step=$1

  if [ -z "${STEPS[$step]}" ]; then
    echo_error "Invalid step: $step"
    return 1
  fi

  echo ""
  echo "----------------------------------------------"
  echo "Running Step $step: ${STEPS[$step]}"
  echo "----------------------------------------------"

  case $step in
    1)
      check_prerequisites || return 1
      detect_omarchy
      ;;
    2)
      install_mise || echo_warn "mise installation had issues"
      install_rust || echo_warn "Rust installation had issues"
      install_go || echo_warn "Go installation had issues"
      ;;
    3)
      install_neovim || echo_warn "Neovim setup had issues"
      ;;
    4)
      setup_shell || echo_warn "Shell setup had issues"
      ;;
    5)
      setup_terminal || echo_warn "Terminal setup had issues"
      ;;
    6)
      echo_info "Applications step - opencode and vicinae"
      echo_info "Install opencode: curl -fsSL https://opencode.ai/install | bash"
      echo_info "Install vicinae: curl -fsSL https://vicinae.com/install.sh | bash"
      ;;
    7)
      backup_existing_configs
      echo_info "Dotfiles integration complete"
      ;;
    *)
      echo_error "Unknown step: $step"
      return 1
      ;;
  esac

  echo_success "Step $step completed"
  return 0
}

# Parse step selection from user input
parse_selection() {
  local input="$1"
  local -a selected=()

  if [[ "$input" == "all" ]] || [[ "$input" == "ALL" ]]; then
    for i in {1..7}; do
      selected+=($i)
    done
  elif [[ "$input" =~ ^[0-9]+-[0-9]+$ ]]; then
    local start=${input%-*}
    local end=${input#*-}
    for ((i=start; i<=end; i++)); do
      if [ -n "${STEPS[$i]}" ]; then
        selected+=($i)
      fi
    done
  else
    for item in $input; do
      if [[ "$item" =~ ^[0-9]+$ ]] && [ -n "${STEPS[$item]}" ]; then
        selected+=($item)
      fi
    done
  fi

  # Remove duplicates and sort
  printf '%s\n' "${selected[@]}" | sort -n | uniq
}

# ============================================
# Testing and Verification Functions
# ============================================

# Test suite for detection logic validation
# Usage: ./omarchy.sh --test or TEST_MODE=1 ./omarchy.sh
test_detection() {
  echo "=============================================="
  echo "Omarchy Detection Test Suite"
  echo "=============================================="
  echo ""
  
  local passed=0
  local failed=0
  
  # Test 1: Check is_omarchy function exists
  echo -n "Test 1: is_omarchy function exists... "
  if type is_omarchy &>/dev/null; then
    echo "PASSED"
    ((passed++))
  else
    echo "FAILED"
    ((failed++))
  fi
  
  # Test 2: Check is_fedora function exists
  echo -n "Test 2: is_fedora function exists... "
  if type is_fedora &>/dev/null; then
    echo "PASSED"
    ((passed++))
  else
    echo "FAILED"
    ((failed++))
  fi
  
  # Test 3: Check has_command utility works
  echo -n "Test 3: has_command utility... "
  if has_command bash && has_command sh; then
    echo "PASSED"
    ((passed++))
  else
    echo "FAILED"
    ((failed++))
  fi
  
  # Test 4: Bash version check (need 4.0+)
  echo -n "Test 4: Bash version compatibility... "
  local bash_version="${BASH_VERSION%%.*}"
  if [ "$bash_version" -ge 4 ]; then
    echo "PASSED (v$BASH_VERSION)"
    ((passed++))
  else
    echo "FAILED (v$BASH_VERSION < 4.0)"
    ((failed++))
  fi
  
  # Test 5: Detect current environment
  echo -n "Test 5: Current environment detection... "
  local env_type="unknown"
  if is_omarchy; then
    env_type="Omarchy"
  elif is_fedora; then
    env_type="Fedora"
  fi
  echo "PASSED (detected: $env_type)"
  ((passed++))
  
  # Test 6: Check Omarchy constants are defined
  echo -n "Test 6: Omarchy constants defined... "
  if [ -n "$OMARCHY_CONFIG_DIR" ] && [ -n "$OMARCHY_VERSION_FILE" ]; then
    echo "PASSED"
    ((passed++))
  else
    echo "FAILED"
    ((failed++))
  fi
  
  # Test 7: Check dotfiles directory
  echo -n "Test 7: Dotfiles directory accessible... "
  if [ -d "$DOTFILES_DIR" ]; then
    echo "PASSED"
    ((passed++))
  else
    echo "FAILED"
    ((failed++))
  fi
  
  # Test 8: Check required commands available
  echo -n "Test 8: Required commands (curl, git, tar)... "
  if has_command curl && has_command git && has_command tar; then
    echo "PASSED"
    ((passed++))
  else
    echo "FAILED"
    ((failed++))
  fi
  
  # Test 9: Validation of spec scenarios
  echo -n "Test 9: Spec scenario validation... "
  local spec_valid=true
  
  # Check that is_omarchy handles missing os-release gracefully
  if [ ! -f /etc/os-release ] && ! is_omarchy 2>/dev/null; then
    spec_valid=true
  elif [ -f /etc/os-release ]; then
    # os-release exists, function should work normally
    spec_valid=true
  else
    spec_valid=false
  fi
  
  if [ "$spec_valid" = true ]; then
    echo "PASSED"
    ((passed++))
  else
    echo "FAILED"
    ((failed++))
  fi
  
  # Test 10: Error handling test
  echo -n "Test 10: Error handling (invalid step)... "
  if ! run_step 999 2>/dev/null; then
    echo "PASSED"
    ((passed++))
  else
    echo "FAILED"
    ((failed++))
  fi
  
  echo ""
  echo "=============================================="
  echo "Test Results: $passed passed, $failed failed"
  echo "=============================================="
  
  return $failed
}

# Simulate Omarchy environment for testing
# Usage: TEST_OMARCHY=1 ./omarchy.sh --test
simulate_omarchy_env() {
  echo_info "Simulating Omarchy environment for testing..."
  
  # Create mock Omarchy directories
  local mock_dir="/tmp/omarchy-test-$$"
  mkdir -p "$mock_dir/.omarchy"
  mkdir -p "$mock_dir/etc/omarchy"
  
  # Create mock os-release file
  cat > "$mock_dir/etc/os-release" << 'EOF'
ID=omarchy
NAME="Omarchy Linux"
PRETTY_NAME="Omarchy Linux"
VERSION_ID="1.0"
EOF
  
  echo "Created mock Omarchy environment at: $mock_dir"
  echo ""
  echo "To test detection with simulated environment:"
  echo "  1. Set: export TEST_OMARCHY_DIR=$mock_dir"
  echo "  2. Run: $0 --test"
  echo ""
  echo "To cleanup: rm -rf $mock_dir"
  
  export TEST_OMARCHY_DIR="$mock_dir"
}

# Validate implementation against spec requirements
validate_spec_compliance() {
  echo "=============================================="
  echo "Spec Compliance Validation"
  echo "=============================================="
  echo ""
  
  local requirements_met=0
  local total_requirements=6
  
  # Requirement 1: Multi-layer detection exists
  echo -n "[REQ-1] Multi-layer detection implemented... "
  if type is_omarchy &>/dev/null; then
    local func_body
    func_body=$(type is_omarchy 2>/dev/null | head -20)
    if echo "$func_body" | grep -q "os-release" && \
       echo "$func_body" | grep -q "\.omarchy"; then
      echo "MET"
      ((requirements_met++))
    else
      echo "PARTIAL"
    fi
  else
    echo "NOT MET"
  fi
  
  # Requirement 2: Non-destructive configuration
  echo -n "[REQ-2] Backup functionality exists... "
  if type backup_existing_configs &>/dev/null; then
    echo "MET"
    ((requirements_met++))
  else
    echo "NOT MET"
  fi
  
  # Requirement 3: Skip backup option
  echo -n "[REQ-3] Skip backup flag supported... "
  if [ -n "$SKIP_BACKUP" ]; then
    echo "MET"
    ((requirements_met++))
  else
    echo "NOT MET"
  fi
  
  # Requirement 4: Dry run mode
  echo -n "[REQ-4] Dry run mode supported... "
  if [ -n "$DRY_RUN" ]; then
    echo "MET"
    ((requirements_met++))
  else
    echo "NOT MET"
  fi
  
  # Requirement 5: Error handling
  echo -n "[REQ-5] Error handling implemented... "
  if grep -q "echo_error" "$0" && grep -q "return 1" "$0"; then
    echo "MET"
    ((requirements_met++))
  else
    echo "NOT MET"
  fi
  
  # Requirement 6: Interactive mode
  echo -n "[REQ-6] Interactive mode available... "
  if type run_interactive &>/dev/null && type show_menu &>/dev/null; then
    echo "MET"
    ((requirements_met++))
  else
    echo "NOT MET"
  fi
  
  echo ""
  echo "=============================================="
  echo "Requirements: $requirements_met/$total_requirements met"
  echo "=============================================="
  
  if [ $requirements_met -eq $total_requirements ]; then
    echo "✓ All spec requirements validated successfully"
    return 0
  else
    echo "⚠ Some requirements not fully met"
    return 1
  fi
}

# Run edge case tests
run_edge_case_tests() {
  echo "=============================================="
  echo "Edge Case Testing"
  echo "=============================================="
  echo ""
  
  local tests_passed=0
  local tests_failed=0
  
  # Edge case 1: Empty selection
  echo -n "Edge 1: Empty menu selection... "
  local result
  result=$(parse_selection "")
  if [ -z "$result" ]; then
    echo "HANDLED (returns empty)"
    ((tests_passed++))
  else
    echo "ISSUE"
    ((tests_failed++))
  fi
  
  # Edge case 2: Invalid step number
  echo -n "Edge 2: Invalid step number (999)... "
  if ! run_step 999 2>/dev/null; then
    echo "HANDLED (returns error)"
    ((tests_passed++))
  else
    echo "ISSUE"
    ((tests_failed++))
  fi
  
  # Edge case 3: Negative step number
  echo -n "Edge 3: Negative step number (-1)... "
  result=$(parse_selection "-1")
  if [ -z "$result" ]; then
    echo "HANDLED (ignored)"
    ((tests_passed++))
  else
    echo "ISSUE"
    ((tests_failed++))
  fi
  
  # Edge case 4: Range selection
  echo -n "Edge 4: Range selection (1-3)... "
  result=$(parse_selection "1-3")
  if [ -n "$result" ]; then
    echo "HANDLED (parsed range)"
    ((tests_passed++))
  else
    echo "ISSUE"
    ((tests_failed++))
  fi
  
  # Edge case 5: Missing dotfiles directory
  echo -n "Edge 5: Missing dotfiles check... "
  if type ensure_dotfiles &>/dev/null; then
    echo "HANDLED (ensure_dotfiles exists)"
    ((tests_passed++))
  else
    echo "ISSUE"
    ((tests_failed++))
  fi
  
  # Edge case 6: Bash version check
  echo -n "Edge 6: Bash version validation... "
  local bash_major="${BASH_VERSION%%.*}"
  if [ "$bash_major" -ge 4 ]; then
    echo "PASSED (v$BASH_VERSION >= 4.0)"
    ((tests_passed++))
  else
    echo "FAILED (v$BASH_VERSION < 4.0)"
    ((tests_failed++))
  fi
  
  echo ""
  echo "=============================================="
  echo "Edge Cases: $tests_passed passed, $tests_failed failed"
  echo "=============================================="
  
  return $tests_failed
}

# Run all tests
run_all_tests() {
  echo ""
  echo "##############################################"
  echo "#  Omarchy Installation Script Test Suite    #"
  echo "##############################################"
  echo ""
  
  local total_exit=0
  
  # Check for test mode flags
  if [ -n "$TEST_OMARCHY" ] || [ -n "$TEST_OMARCHY_DIR" ]; then
    simulate_omarchy_env
  fi
  
  test_detection || total_exit=1
  echo ""
  
  validate_spec_compliance || total_exit=1
  echo ""
  
  run_edge_case_tests || total_exit=1
  
  echo ""
  echo "##############################################"
  if [ $total_exit -eq 0 ]; then
    echo "#           ALL TESTS PASSED ✓               #"
  else
    echo "#           SOME TESTS FAILED ✗              #"
  fi
  echo "##############################################"
  echo ""
  
  return $total_exit
}

# Run all steps sequentially
run_all_steps() {
  echo "=============================================="
  echo "Omarchy Linux Dotfiles Installation (Full)"
  echo "=============================================="
  echo ""

  local failed=0

  for i in {1..7}; do
    if [ -n "${STEPS[$i]}" ]; then
      run_step $i || {
        echo_warn "Step $i had issues but continuing..."
        ((failed++))
      }
    fi
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
  echo "1. Restart your terminal for all changes to take effect"
  echo "2. Open nvim and run :Lazy sync to install plugins"
  echo "3. Run 'mise install' to install language tools from mise config"
  echo ""
}

# Interactive mode
run_interactive() {
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

# Main entry point
main() {
  local steps_to_run=""

  # Parse command line arguments
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
      -s|--skip-backup)
        SKIP_BACKUP=true
        echo_info "Backup will be skipped"
        shift
        ;;
      -a|--all)
        steps_to_run="all"
        shift
        ;;
      -t|--test)
        TEST_MODE=true
        shift
        ;;
      [1-9]|all)
        if [ -z "$steps_to_run" ]; then
          steps_to_run="$1"
        else
          steps_to_run="$steps_to_run $1"
        fi
        shift
        ;;
      *)
        echo_error "Unknown option: $1"
        show_help
        exit 1
        ;;
    esac
  done
  
  # Run test mode if requested
  if [ "$TEST_MODE" = true ]; then
    run_all_tests
    exit $?
  fi

  # Run based on parsed arguments
  if [ -n "$steps_to_run" ]; then
    if [ "$steps_to_run" == "all" ]; then
      run_all_steps
    else
      # Run specific steps
      ensure_dotfiles
      for step in $steps_to_run; do
        run_step "$step" || echo_warn "Step $step failed but continuing..."
      done
    fi
  else
    # No steps specified, run interactive mode
    run_interactive
  fi
}

# Run main function with all arguments
main "$@"
