#!/usr/bin/env bash

set -euo pipefail

sudo rm -rf /nix
sudo rm -rf /etc/nix
sudo rm -f /usr/local/bin/nix*
sudo rm -f /etc/systemd/system/nix-daemon.service
sudo rm -f /etc/systemd/system/nix-daemon.socket

restore_file() {
    local backup="$1"
    local target="$2"

    if [ -e "$backup" ]; then
        sudo mv "$backup" "$target"
    fi
}

restore_file /etc/zsh/zshrc.backup-before-nix /etc/zsh/zshrc
restore_file /etc/bash.bashrc.backup-before-nix /etc/bash.bashrc
restore_file /etc/bashrc.backup-before-nix /etc/bashrc
restore_file /etc/profile.d/nix.sh.backup-before-nix /etc/profile.d/nix.sh
restore_file /etc/zshrc.backup-before-nix /etc/zshrc
