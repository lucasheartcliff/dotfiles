
#Adding  Oh My ZSH
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

ZSH_PATH=$HOME/.oh-my-zsh

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

rm -f ~/.zshrc
cp ./configs/zsh/.zshrc ~/.zshrc

# Changing default shell script

chsh -s $(which zsh)