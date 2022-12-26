sudo dnf install -y neovim python3-neovim gcc-c++

nvm install 16
nvm use 16

yarn global add typescript-language-server @fsouza/prettierd

BASE=$(pwd)

rm -rf $HOME/.config/nvim/
mkdir $HOME/.config/nvim

cp -r ./configs/neovim/* $HOME/.config/nvim

