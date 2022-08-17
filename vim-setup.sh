curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

BASE=$(pwd)

rm -f ~/.vimrc
cp ./configs/vim/.vimrc ~/.vimrc

