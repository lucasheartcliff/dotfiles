sudo dnf install -y neovim python3-neovim gcc-c++  

BASE=$(pwd)

rm -rf $HOME/.config/nvim/
mkdir $HOME/.config/nvim

cp -r ./configs/neovim/* $HOME/.config/nvim

