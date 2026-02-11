{ config, pkgs, ... }:

{
  home.username = "lucasmorais";
  home.homeDirectory = "/home/lucasmorais";
  home.stateVersion = "25.05";

  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    git neovim tmux lazygit fzf lsd ripgrep fd bat delta act gnumake
    nodejs yarn pyenv docker docker-compose vscode brave htop curl wget
    stow xclip neofetch cmatrix flameshot kitty alacritty
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
  ];

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting
      set -gx EDITOR nvim
      set -gx VISUAL nvim
      set -gx PATH $HOME/.local/bin $PATH
      set -gx PATH $HOME/.cargo/bin $PATH
      set -gx FZF_DEFAULT_COMMAND 'fd --type f --hidden --follow --exclude .git'
      set -gx FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
    '';
    shellAbbrs = {
      g = "git"; ga = "git add"; gc = "git commit"; gco = "git checkout";
      gp = "git push"; gl = "git pull"; gs = "git status"; gd = "git diff"; glg = "lazygit";
      ".." = "cd .."; "..." = "cd ../.."; "...." = "cd ../../..";
      ls = "lsd"; ll = "lsd -l"; la = "lsd -la"; lt = "lsd --tree";
      v = "nvim"; vim = "nvim";
      d = "docker"; dc = "docker-compose"; dps = "docker ps"; dimg = "docker images";
      c = "clear";
    };
    plugins = [
      { name = "fzf"; src = pkgs.fishPlugins.fzf-fish.src; }
      { name = "done"; src = pkgs.fishPlugins.done.src; }
    ];
  };

  programs.git = {
    enable = true;
    userName = "Lucas Morais";
    userEmail = "your.email@example.com";
    aliases = { co = "checkout"; br = "branch"; ci = "commit"; st = "status"; };
    extraConfig = {
      init.defaultBranch = "main";
      core.editor = "nvim";
      pull.rebase = false;
      push.autoSetupRemote = true;
    };
    delta = {
      enable = true;
      options = { navigate = true; line-numbers = true; syntax-theme = "Dracula"; };
    };
  };

  programs.alacritty = {
    enable = true;
    settings = {
      env.TERM = "xterm-256color";
      window.opacity = 0.95;
      window.padding = { x = 10; y = 10; };
      font = { normal.family = "FiraCode Nerd Font"; size = 12.0; };
      colors.primary = { background = "#282a36"; foreground = "#f8f8f2"; };
    };
  };

  programs.tmux = {
    enable = true;
    terminal = "screen-256color";
    keyMode = "vi";
    prefix = "C-a";
    mouse = true;
    escapeTime = 0;
    baseIndex = 1;
    plugins = with pkgs.tmuxPlugins; [ sensible yank vim-tmux-navigator ];
    extraConfig = ''
      bind | split-window -h
      bind - split-window -v
      bind r source-file ~/.config/tmux/tmux.conf
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
    '';
  };

  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
    defaultCommand = "fd --type f --hidden --follow --exclude .git";
    defaultOptions = [ "--height 40%" "--layout=reverse" "--border" "--inline-info" ];
  };

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      add_newline = true;
      character = { success_symbol = "[➜](bold green)"; error_symbol = "[➜](bold red)"; };
      git_branch.symbol = " ";
      nodejs.symbol = " ";
      python.symbol = " ";
      rust.symbol = " ";
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.lazygit = {
    enable = true;
    settings = {
      gui.theme = {
        lightTheme = false;
        activeBorderColor = [ "green" "bold" ];
        inactiveBorderColor = [ "white" ];
        selectedLineBgColor = [ "blue" ];
      };
      git.paging = { colorArg = "always"; pager = "delta --dark --paging=never"; };
    };
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    TERMINAL = "alacritty";
    BROWSER = "brave";
  };

  programs.home-manager.enable = true;
}
