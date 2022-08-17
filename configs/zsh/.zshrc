export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="spaceship"

plugins=( 
    kubectl 
    history 
    emoji 
    encode64
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    dnf
    pyenv
    npm
    nvm
    yarn
    pip
)
source $ZSH/oh-my-zsh.sh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh


export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"