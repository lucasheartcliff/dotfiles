{ ... }:

{
  imports = [
    ./modules/packages.nix
    ./modules/fish.nix
    ./modules/git.nix
    ./modules/terminal.nix
    ./modules/shell-tools.nix
    ./modules/direnv.nix
    ./modules/lazygit.nix
  ];

  home.username = "lucasmorais";
  home.homeDirectory = "/home/lucasmorais";
  home.stateVersion = "25.05";

  nixpkgs.config.allowUnfree = true;

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    TERMINAL = "kitty";
    BROWSER = "brave";
    NPM_CONFIG_PREFIX = "$HOME/.local/share/npm";
  };

  programs.home-manager.enable = true;
}
