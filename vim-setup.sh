sudo dnf install -y neovim python3-neovim

BASE=$(pwd)

rm -rf $HOME/.config/nvim/
mkdir $HOME/.config/nvim

cp -r ./configs/neovim/* $HOME/.config/nvim
rm -f ~/.vimrc
cp ./configs/vim/.vimrc ~/.vimrc

