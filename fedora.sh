#!/usr/bin/env bash

set -euo pipefail

echo "Installing Fedora system packages..."

# Update system
sudo dnf upgrade --refresh -y
sudo dnf install -y dnf-plugins-core util-linux-user

# Add repositories
sudo dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc

# Add VS Code repository
printf "[vscode]\nname=packages.microsoft.com\nbaseurl=https://packages.microsoft.com/yumrepos/vscode/\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc\nmetadata_expire=1h" | sudo tee -a /etc/yum.repos.d/vscode.repo

# Install system packages
sudo dnf install -y \
	build-essential \
	cmake \
	freetype-devel \
	fontconfig-devel \
	libxcb-devel \
	g++ \
	clang \
	openssl-devel

echo "System packages installed."
echo "Now running bootstrap to install development tools via Nix/Home Manager..."
echo ""

# Run bootstrap script
bash "$(dirname "$0")/bootstrap.sh"

