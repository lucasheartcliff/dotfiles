NVIM_PATH="$HOME/.config/nvim/"
rm -rf $NVIM_PATH/lua
rm -f $NVIM_PATH/init.lua

[ ! -d $NVIM_PATH ] && mkdir $NVIM_PATH

cp -r ./configs/* $NVIM_PATH
