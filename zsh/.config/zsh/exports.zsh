# Yarn
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

export TMOUT=0

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export PATH="$HOME/.local/bin":$PATH

# PYENV
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

# ASDF
export ASDF_DIR="$HOME/asdf"
export ASDF_DATA_DIR=$ASDF_DIR
export PATH="$ASDF_DATA_DIR/shims:$PATH"
export PATH="$ASDF_DIR/bin:$PATH"
eval "$(pyenv init -)"
