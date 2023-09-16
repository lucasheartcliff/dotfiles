#!/usr/bin/env bash
source ../check_os.sh

if [ is_fedora ]; then
  sudo dnf install -y neovim python3-neovim gcc-c++
else
  sudo apt install -y neovim python3-neovim;
  sudo apt-get install python-dev python-pip python3-dev python3-pip;
fi;
