#!/bin/bash
CUR_PATH=$(pwd)
ALACRITTY_DIR="$HOME/.alacritty"

SHORTCUT="[Desktop Entry]
Type=Application
TryExec=alacritty
Exec=env WINIT_UNIX_BACKEND=x11 alacritty
Icon=Alacritty
Terminal=false
Categories=System;TerminalEmulator;

Name=Alacritty
GenericName=Terminal
Comment=A fast, cross-platform, OpenGL terminal emulator
StartupWMClass=Alacritty
Actions=New;

[Desktop Action New]
Name=New Terminal
Exec=env WINIT_UNIX_BACKEND=x11 alacritty"

rm -rf $ALACRITTY_DIR
git clone https://github.com/zenixls2/alacritty.git $ALACRITTY_DIR
cd $ALACRITTY_DIR
git checkout ligature
cargo build --release
# sudo tic -xe alacritty,alacritty-direct extra/alacritty.info
sudo cp target/release/alacritty /usr/local/bin
sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
echo $SHORTCUT extra/linux/Alacritty.desktop
sudo desktop-file-install extra/linux/Alacritty.desktop
sudo update-desktop-database
cd $CUR_PATH
echo "The Alacritty installation requires a reboot."
