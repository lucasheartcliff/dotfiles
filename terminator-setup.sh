#!bin/bash

sudo add-apt-repository ppa:gnome-terminator
sudo apt-get install terminator
sudo update-alternatives --config x-terminal-emulator

mkdir $HOME/.config/terminator/
cp ./configs/terminator/terminator-config $HOME/.config/terminator/config