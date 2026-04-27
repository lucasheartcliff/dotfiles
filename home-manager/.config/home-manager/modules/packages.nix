{ pkgs, ... }:

{
  home.packages = with pkgs; [
    act
    bat
    brave
    cmatrix
    curl
    delta
    docker
    docker-compose
    fd
    flameshot
    gh
    git
    gnumake
    htop
    jq
    kubectl
    kubectx
    kubernetes-helm
    lazygit
    lsd
    neofetch
    neovim
    nerd-fonts.fira-code
    nodejs
    pyenv
    ripgrep
    stow
    tmux
    vscode
    wget
    xclip
    yarn
  ];
}
