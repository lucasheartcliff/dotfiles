#!/bin/bash
STOW=$HOME/.stow
CURR_PATH=$(pwd)
rm -rf $STOW
git clone https://github.com/aspiers/stow.git $STOW

cd $STOW

bash bootstrap
bash configure
make 
sudo make install ./
stow --version

cd $CURR_PATH
