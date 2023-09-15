STOW=$HOME/.stow
git clone https://github.com/aspiers/stow.git $STOW

bash $STOW/bootstrap
bash $STOW/configure
make $STOW/
sudo make install $STOW
stow --version