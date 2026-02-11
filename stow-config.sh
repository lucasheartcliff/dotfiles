#!/usr/bin/env bash

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Get the directory where the script is located
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DOTFILES_DIR"

# Create timestamped backup
BACKUP_DIR="$HOME/.config-stow-backup-$(date +%Y%m%d-%H%M%S)"

if [ -d "$HOME/.config" ] && [ ! -L "$HOME/.config" ]; then
    log_info "Backing up existing .config to $BACKUP_DIR"
    mkdir -p "$BACKUP_DIR"
    
    # Only backup files that will be replaced by stow
    for package in */; do
        package_name="${package%/}"
        if [ -d "$package/.config/$package_name" ]; then
            if [ -d "$HOME/.config/$package_name" ]; then
                cp -r "$HOME/.config/$package_name" "$BACKUP_DIR/" 2>/dev/null || true
            fi
        fi
    done
    
    log_info "Backup complete"
fi

# Ensure .local/bin exists
mkdir -p "$HOME/.local/bin"

# Define folders to ignore
declare -a ignored_folders=("assets" "tools" "utils" "font-unicode" "home-manager")

# Stow packages
log_info "Stowing dotfiles..."
for package in */; do
    package_name="${package%/}"
    
    # Check if package should be ignored
    if [[ " ${ignored_folders[@]} " =~ " $package_name " ]]; then
        log_info "Skipping: $package_name"
        continue
    fi
    
    # Check if package has any files
    if [ ! "$(ls -A "$package" 2>/dev/null)" ]; then
        log_warn "Empty package: $package_name"
        continue
    fi
    
    log_info "Stowing: $package_name"
    
    # First, unstow to remove any existing symlinks
    stow -D "$package_name" 2>/dev/null || true
    
    # Then stow the package
    if stow "$package_name" 2>&1 | tee /tmp/stow-$package_name.log; then
        log_info "✓ Successfully stowed: $package_name"
    else
        log_error "✗ Failed to stow: $package_name"
        log_error "Check /tmp/stow-$package_name.log for details"
    fi
done

log_info ""
log_info "========================================="
log_info "Stow configuration complete!"
log_info "========================================="
log_info ""
log_info "Backed up configs are in: $BACKUP_DIR"
log_info ""

