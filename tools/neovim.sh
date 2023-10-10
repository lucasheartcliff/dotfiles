#!/bin/bash
FOLDER_PATH="/tmp/$(uuidgen -r)"
mkdir $FOLDER_PATH

FILE_PATH="$FOLDER_PATH/nvim-linux64.tar.gz"
wget -P $FOLDER_PATH https://github.com/neovim/neovim/releases/download/v0.9.2/nvim-linux64.tar.gz

NVIM_PATH="$HOME/.neovim"

rm -rf $NVIM_PATH

mkdir $NVIM_PATH
tar -xvzf $FILE_PATH -C $NVIM_PATH

rm -rf $FOLDER_PATH

rm -f $HOME/.local/bin/nvim
ln -s $NVIM_PATH/nvim-linux64/bin/nvim $HOME/.local/bin/nvim
