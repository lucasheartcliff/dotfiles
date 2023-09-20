#!/bin/bash
FOLDER_PATH="/tmp/$(uuidgen -r)/"
mkdir $FOLDER_PATH

FILE_PATH="$FOLDER_PATH/neovim.taz.gz"
wget -P $FILE_PATH  https://github.com/neovim/neovim/releases/download/v0.9.2/nvim-linux64.tar.gz

NVIM_PATH=$HOME/.neovim/

rm -rf $NVIM_PATH

tar -xzvf $FILE_PATH -C $NVIM_PATH

rm -rf $FOLDER_PATH

rm -f $HOME/.local/bin/nvim
ln -s $NVIM_PATH/bin/nvim $HOME/.local/bin/nvim

LV_BRANCH='release-1.3/neovim-0.9' bash <(curl -s https://raw.githubusercontent.com/LunarVim/LunarVim/release-1.3/neovim-0.9/utils/installer/install.sh)
