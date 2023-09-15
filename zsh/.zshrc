#!/bin/sh
[ -f "$HOME/.local/share/zap/zap.zsh" ] && source "$HOME/.local/share/zap/zap.zsh"


# history
HISTFILE=~/.zsh_history

# source
plug "$HOME/.config/zsh/aliases.zsh"
plug "$HOME/.config/zsh/exports.zsh"
plug "$HOME/.config/zsh/keybinds.zsh"

# plugins
plug "zap-zsh/supercharge"
plug "esc/conda-zsh-completion"
plug "zsh-users/zsh-autosuggestions"
plug "hlissner/zsh-autopair"
plug "wintermi/zsh-lsd"
plug "zap-zsh/nvm"
plug "zap-zsh/vim"
plug "zap-zsh/zap-prompt"
plug "zap-zsh/fzf"
plug "Aloxaf/fzf-tab"
plug "dracula/zsh"
plug "chivalryq/git-alias"
plug "MichaelAquilina/zsh-you-should-use"
plug "zsh-users/zsh-syntax-highlighting"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.

if [ -n "$PS1" ] && [ -z "$TMUX" ]; then
  exec tmux new-session -A -s main && 
fi
