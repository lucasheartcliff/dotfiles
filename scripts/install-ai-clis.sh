#!/usr/bin/env bash

set -euo pipefail

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

usage() {
    cat <<'USAGE'
Usage: scripts/install-ai-clis.sh [--upgrade]

Installs optional AI coding CLIs with npm global packages:
  - @openai/codex
  - @anthropic-ai/claude-code

Options:
  --upgrade    Install even if the command already exists.
  -h, --help   Show this help message.
USAGE
}

upgrade=false

for arg in "$@"; do
    case "$arg" in
        --upgrade)
            upgrade=true
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            log_error "Unknown option: $arg"
            usage
            exit 1
            ;;
    esac
done

if ! command -v npm >/dev/null 2>&1; then
    log_error "npm is required. Run Home Manager first so Node.js/npm is available."
    exit 1
fi

if [ "$EUID" -eq 0 ]; then
    log_error "Do not run this script with sudo. It installs CLIs into a user npm prefix."
    exit 1
fi

default_npm_prefix="$HOME/.local/share/npm"
npm_prefix="$(npm config get prefix)"

if [ ! -w "$npm_prefix" ]; then
    log_warn "npm global prefix is not writable: $npm_prefix"
    log_info "Configuring npm to use $default_npm_prefix"
    mkdir -p "$default_npm_prefix/bin"
    npm config set prefix "$default_npm_prefix"
    npm_prefix="$default_npm_prefix"
fi

export NPM_CONFIG_PREFIX="$npm_prefix"
export PATH="$npm_prefix/bin:$PATH"

install_cli() {
    local command_name="$1"
    local package_name="$2"

    if command -v "$command_name" >/dev/null 2>&1 && [ "$upgrade" = false ]; then
        log_info "$command_name is already installed; skipping"
        return
    fi

    log_info "Installing $package_name"
    npm install -g "$package_name"
}

install_cli codex @openai/codex
install_cli claude @anthropic-ai/claude-code

log_info "AI CLI setup complete"
log_info "Authenticate when ready:"
log_info "  codex login"
log_info "  claude"
