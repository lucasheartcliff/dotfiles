source ./check_os.sh

ZSH_PATH=$HOME/.oh-my-zsh

if [ is_fedora ]; then
    sudo dnf install zsh
    wget --no-check-certificate http://install.ohmyz.sh -O - | sh

else
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_PATH/custom/plugins/zsh-syntax-highlighting

git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_PATH/custom/plugins/zsh-autosuggestions

git clone https://github.com/denysdovhan/spaceship-prompt.git "$ZSH_PATH/custom/themes/spaceship-prompt"

ln -s "$ZSH_PATH/custom/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_PATH/custom/themes/spaceship.zsh-theme"

git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_PATH/custom/themes/powerlevel10k"

#Adding Dracula theme
DRACULA_THEME=$ZSH_PATH/custom/themes

git clone https://github.com/dracula/zsh.git $DRACULA_THEME

ln -s $DRACULA_THEME/dracula.zsh-theme $ZSH_PATH/themes/dracula.zsh-theme

# Changing default shell script
sudo chsh -s /usr/bin/zsh
chsh -s $(which zsh)