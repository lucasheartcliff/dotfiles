#!/usr/bin/env bash

set -euo pipefail

echo "Installing Ubuntu system packages..."

# Update system
sudo add-apt-repository universe -y
sudo apt update

# Install system dependencies
sudo apt install -y \
	build-essential \
	cmake \
	pkg-config \
	libssl-dev \
	libffi-dev \
	zlib1g-dev \
	libbz2-dev \
	libreadline-dev \
	libsqlite3-dev \
	libfontconfig1-dev \
	libxcb-xfixes0-dev \
	libfreetype6-dev \
	libxkbcommon-dev \
	python3 \
	x11-utils

# Add Brave browser repository
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list

# Optional: Install databases if needed
# sudo apt install -y postgresql postgresql-contrib mariadb-server

sudo apt update

echo "System packages installed."
echo "Now running bootstrap to install development tools via Nix/Home Manager..."
echo ""

# Run bootstrap script
bash "$(dirname "$0")/bootstrap.sh"

