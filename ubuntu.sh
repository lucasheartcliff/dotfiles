#!/bin/bash
sudo add-apt-repository universe
sudo apt update

sudo apt install -y build-essential python xclip x11-utils libssl-dev libffi-dev git curl wget zsh make zlib1g-dev \
	libbz2-dev libreadline-dev libsqlite3-dev terminator tmux stow cmake pkg-config \
	libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev python3

sudo snap install intellij-idea-community --classic
sudo snap install code --classic

curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg

echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O - | apt-key add -

sudo apt update

sudo apt install -y yarn brave-browser postgresql postgresql-contrib mariadb-server ripgrep

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

bash ./tools_install.sh
