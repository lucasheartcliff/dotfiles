#!/bin/sh

# Should run with sudo
add-apt-repository universe

apt update

apt install code
snap install intellij-idea-community --classic
apt install git
apt install curl
apt install wget
apt install nodejs
apt install npm
apt install zsh

git config --global user.name "Lucas Morais"
git config --global user.email "lucascdemorais@gmail.com"

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


echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(pyenv init -)"' >> ~/.bashrc
echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.bashrc
echo 'pyenv virtualenvwrapper' >> ~/.bashrc

curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | sh 

source ~/.profile  

nvm install node 
nvm install 14
nvm install 12
nvm install 10

# Adding font family


