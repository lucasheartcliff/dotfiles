#!/usr/bin/env bash

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running as root
if [[ $EUID -eq 0 ]]; then
   log_error "This script should not be run as root"
   exit 1
fi

# Detect OS
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
else
    log_error "Cannot detect OS"
    exit 1
fi

log_info "Detected OS: $OS"

install_kitty_system() {
    if command -v kitty &> /dev/null; then
        log_info "Kitty already installed"
        return
    fi

    log_info "Installing Kitty (system package)..."
    case "$OS" in
        ubuntu|debian|pop|linuxmint)
            sudo apt update
            sudo apt install -y kitty
            ;;
        fedora|rhel|centos)
            sudo dnf install -y kitty
            ;;
        arch|manjaro|endeavouros)
            sudo pacman -Sy --noconfirm kitty
            ;;
        *)
            if [[ "${ID_LIKE:-}" == *debian* ]]; then
                sudo apt update
                sudo apt install -y kitty
            elif [[ "${ID_LIKE:-}" == *rhel* ]] || [[ "${ID_LIKE:-}" == *fedora* ]]; then
                sudo dnf install -y kitty
            elif [[ "${ID_LIKE:-}" == *arch* ]]; then
                sudo pacman -Sy --noconfirm kitty
            else
                log_warn "Unsupported OS for Kitty install: $OS"
                log_warn "Install Kitty manually if needed"
            fi
            ;;
    esac
}

# Install Nix if not already installed
if ! command -v nix &> /dev/null; then
    log_info "Installing Nix package manager..."
    curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate systems.com/nix | sh -s -- install
    
    # Source Nix
    if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
        . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
    fi
    
    log_info "Nix installed successfully"
else
log_info "Nix already installed"
fi

# Install Kitty from system packages (avoid Nix GL issues)
install_kitty_system

# Install Home Manager if not already installed
if ! command -v home-manager &> /dev/null; then
    log_info "Installing Home Manager..."
    
    # Add Home Manager channel
    nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
    nix-channel --update
    
    # Install Home Manager
    nix-shell '<home-manager>' -A install
    
    log_info "Home Manager installed successfully"
else
    log_info "Home Manager already installed"
fi

# Backup existing .config if it exists
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.config-backup-$(date +%Y%m%d-%H%M%S)"

if [ -d "$HOME/.config" ]; then
    log_warn "Backing up existing .config to $BACKUP_DIR"
    mkdir -p "$BACKUP_DIR"
    cp -r "$HOME/.config" "$BACKUP_DIR/" || log_warn "Some files couldn't be backed up"
fi

# Ensure .local/bin exists
mkdir -p "$HOME/.local/bin"

# Link home-manager configuration
log_info "Setting up Home Manager configuration..."
mkdir -p "$HOME/.config/home-manager"

if [ -f "$DOTFILES_DIR/home-manager/.config/home-manager/home.nix" ]; then
    ln -sf "$DOTFILES_DIR/home-manager/.config/home-manager/home.nix" "$HOME/.config/home-manager/home.nix"
    log_info "Linked home-manager configuration"
else
    log_error "home.nix not found in $DOTFILES_DIR/home-manager/.config/home-manager/"
    exit 1
fi

# Apply Home Manager configuration
log_info "Applying Home Manager configuration (this may take a while)..."
home-manager switch

# Check if Fish is installed
if command -v fish &> /dev/null; then
    log_info "Fish shell detected"
    
    # Check if Fish is already the default shell
    if [ "$SHELL" != "$(which fish)" ]; then
        log_info "Setting Fish as default shell..."
        
        # Add Fish to /etc/shells if not already there
        if ! grep -q "$(which fish)" /etc/shells; then
            echo "$(which fish)" | sudo tee -a /etc/shells
        fi
        
        # Change default shell
        chsh -s "$(which fish)"
        log_info "Fish set as default shell. Please log out and log back in for changes to take effect."
    else
        log_info "Fish is already the default shell"
    fi
else
    log_error "Fish shell not found after Home Manager installation"
    exit 1
fi

# Run stow for additional configurations
log_info "Running stow for dotfiles..."
if [ -f "$DOTFILES_DIR/stow-config.sh" ]; then
    bash "$DOTFILES_DIR/stow-config.sh"
else
    log_warn "stow-config.sh not found, skipping stow setup"
fi

log_info ""
log_info "========================================="
log_info "Bootstrap complete!"
log_info "========================================="
log_info ""
log_info "Next steps:"
log_info "1. Log out and log back in to use Fish shell"
log_info "2. Update git user email in ~/.config/home-manager/home.nix"
log_info "3. Run 'home-manager switch' to apply any changes"
log_info ""
log_info "Your old config was backed up to: $BACKUP_DIR"
log_info ""
