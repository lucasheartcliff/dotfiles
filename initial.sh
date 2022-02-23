#!/bin/sh

# Should run with sudo
add-apt-repository ppa:gnome-terminator
add-apt-repository universe

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

curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

apt update

apt install yarn

apt install default-jdk
apt install openjdk-11-jdk
apt install openjdk-8-jdk

apt install -y python3-pip
apt install python2
python3 get-pip.py
apt install -y build-essential libssl-dev libffi-dev python3-dev
apt-get install make zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev
apt install -y python3-venv

git clone https://github.com/pyenv/pyenv.git ~/.pyenv
git clone https://github.com/pyenv/pyenv-virtualenv.git $(pyenv root)/plugins/pyenv-virtualenv

wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O - | apt-key add -
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

git clone https://github.com/denysdovhan/spaceship-prompt.git "$ZSH_PATH/custom/themes/spaceship-prompt"

ln -s "$ZSH_PATH/custom/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_PATH/custom/themes/spaceship.zsh-theme"

git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install

#Adding Dracula theme
DRACULA_THEME=$ZSH_PATH/custom/themes

git clone https://github.com/dracula/zsh.git $DRACULA_THEME

ln -s $DRACULA_THEME/dracula.zsh-theme $ZSH_PATH/themes/dracula.zsh-theme

# Adding font family

apt install fonts-firacode


# Changing default shell script

chsh -s $(which zsh)

apt install apt-transport-https

curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg

echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main"|tee /etc/apt/sources.list.d/brave-browser-release.list

apt update

apt install brave-browser


echo '[Desktop Entry]
Name=Brave Browser
Exec=/usr/bin/brave-browser-stable %U --remote-debugging-port=9222
StartupNotify=true
Terminal=false
Icon=brave-browser
Type=Application
Categories=Network;WebBrowser;' >> ~/.local/share/applications/brave-browser.desktop

apt install mariadb-server
mysql_secure_installation