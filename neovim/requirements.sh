source ../check_os.sh

if [ is_fedora ]; then
  sudo dnf install -y neovim python3-neovim gcc-c++
else
  sudo apt install -y neovim python3-neovim gcc-c++
fi;

nvm install 16
nvm use 16

yarn global add typescript-language-server
