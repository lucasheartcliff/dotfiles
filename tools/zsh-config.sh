wget --no-check-certificate http://install.ohmyz.sh -O - | sh
sudo chsh -s /usr/bin/zsh
chsh -s $(which zsh)
sudo lchsh $USER 