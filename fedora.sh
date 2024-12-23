#!/bin/bash
sudo dnf upgrade --refresh
sudo dnf install -y dnf-plugins-core util-linux-user
sudo dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc

sudo dnf update

printf "[vscode]\nname=packages.microsoft.com\nbaseurl=https://packages.microsoft.com/yumrepos/vscode/\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc\nmetadata_expire=1h" | sudo tee -a /etc/yum.repos.d/vscode.repo

sudo dnf install -y brave-browser \
	brave-keyring terminator tmux git curl wget make code cmake freetype-devel \
	fontconfig-devel libxcb-devel g++ clang stow zsh xclip ripgrep

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

sh ./tools_install.sh
