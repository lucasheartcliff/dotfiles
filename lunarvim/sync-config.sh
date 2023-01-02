LVIM_PATH="$HOME/.config/lvim/"
rm -rf $LVIM_PATH/lua/user/
rm -f $LVIM_PATH/config.lua


[ ! -d $LVIM_PATH ] && mkdir $LVIM_PATH

cp -r ./lvim/* $LVIM_PATH
