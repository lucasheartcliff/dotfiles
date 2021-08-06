#!/bin/sh

# Should run with sudo 
add-apt-repository ppa:gnome-terminator

apt update

apt install code
snap install intellij-idea-community --classic
snap install pycharm-community --classic

apt-get install terminator
update-alternatives --config x-terminal-emulator

mkdir $HOME/.config/terminator/
cat ./terminator-config >> $HOME/.config/terminator/config

apt install git
apt install curl
apt install wget
apt install nodejs
apt install npm
apt install zsh

curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

apt update

apt install yarn

apt install default-jre
apt install openjdk-11-jre-headless
apt install openjdk-8-jre-headless

apt install -y python3-pip
add-apt-repository universe
apt install python2
python3 get-pip.py
apt install -y build-essential libssl-dev libffi-dev python3-dev
apt-get install make zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev
apt install -y python3-venv

git clone https://github.com/pyenv/pyenv.git ~/.pyenv
git clone https://github.com/pyenv/pyenv-virtualenv.git $(pyenv root)/plugins/pyenv-virtualenv

wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O - | sudo apt-key add -
apt install postgresql postgresql-contrib

echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(pyenv init -)"' >> ~/.bashrc
echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.bashrc
echo 'pyenv virtualenvwrapper' >> ~/.bashrc

curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | zsh 

source ~/.profile  

nvm install node 
nvm install 14
nvm install 12
nvm install 10

#Adding  Oh My ZSH
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

ZSH_PATH=$HOME/.oh-my-zsh

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_PATH/custom/plugins/zsh-syntax-highlighting

git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_PATH/custom/plugins/zsh-autosuggestions

git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install

#Adding Dracula theme
DRACULA_THEME=$ZSH_PATH/custom/themes

git clone https://github.com/dracula/zsh.git $DRACULA_THEME

ln -s $DRACULA_THEME/dracula.zsh-theme $ZSH_PATH/themes/dracula.zsh-theme

# Adding font family

apt install fonts-firacode


# Changing default shell script

chsh -s $(which zsh)
