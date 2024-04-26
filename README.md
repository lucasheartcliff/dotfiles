# Dotfiles

![setup screenshot](./assets/setup.png)


**Warning**: Don’t blindly use my settings unless you know what that entails. Use at your own risk!

## Contents

- neovim
- tmux
- zsh
- fzf
- lsd
- gnome
- brave
- fonts (Nerd Fonts)
- pyenv
- sdkman
- nvm
- stow

## Usage

To install all requirements, use the following commands for each operational system:

### Ubuntu

```sh
./ubuntu.sh
```

### Fedora

```sh
./fedora.sh
```

Then, run the command to copy all config files:

```sh
./stow-config.sh
```

## Extras

Sometime the `jdtls` a module installed by mason comes with `lombok.jar` setted without permission to execute, so be aware on use it.

```bash
chmod 755 $HOME/.local/share/lvim/mason/packages/jdtls/lombok.jar
```

