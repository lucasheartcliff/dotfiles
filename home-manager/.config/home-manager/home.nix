{ config, pkgs, ... }:

{
  home.username = "lucasmorais";
  home.homeDirectory = "/home/lucasmorais";
  home.stateVersion = "25.05";

  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    git neovim tmux lazygit fzf lsd ripgrep fd bat delta act gnumake
    nodejs yarn pyenv docker docker-compose vscode brave htop curl wget
    stow xclip neofetch cmatrix flameshot
    nerd-fonts.fira-code
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
      if test -f $HOME/asdf/asdf.fish
        set -gx ASDF_DATA_DIR $HOME/asdf
        source $HOME/asdf/asdf.fish
        if not test -d $HOME/.config/fish/completions
          mkdir -p $HOME/.config/fish/completions
        end
        if not test -f $HOME/.config/fish/completions/asdf.fish
          asdf completion fish > $HOME/.config/fish/completions/asdf.fish
        end
      end

      # JAVA 21 (used by jdtls / Neovim)
      set -l java21_candidates \
        $JAVA21_HOME \
        $JDK21_HOME \
        /usr/lib/jvm/java-21-openjdk-amd64 \
        /usr/lib/jvm/java-1.21.0-openjdk-amd64 \
        /usr/lib/jvm/default-java \
        $HOME/.sdkman/candidates/java/current

      for java_home in $java21_candidates
        if test -n "$java_home"; and test -x "$java_home/bin/java"
          if "$java_home/bin/java" -version 2>&1 | string match -qr 'version "21'
            set -gx JAVA21_HOME "$java_home"
            break
          end
        end
      end
      if set -q JAVA21_HOME
        set -gx JAVA_HOME "$JAVA21_HOME"
      end
    '';
    shellAbbrs = {
      g = "git"; ga = "git add"; gaa = "git add --all"; gap = "git add --patch";
      gb = "git branch"; gba = "git branch -a";
      gc = "git commit"; gca = "git commit --amend"; gcan = "git commit --amend --no-edit";
      gco = "git checkout"; gcb = "git checkout -b"; gcm = "git checkout main";
      gd = "git diff"; gds = "git diff --staged";
      gf = "git fetch"; gfa = "git fetch --all --prune";
      gl = "git pull"; glog = "git log --oneline --graph --decorate --all";
      gp = "git push"; gpf = "git push --force-with-lease";
      gr = "git restore"; grs = "git restore --staged";
      gs = "git status"; gsw = "git switch"; gswm = "git switch main"; gt = "git tag";
      glg = "lazygit";
      ".." = "cd .."; "..." = "cd ../.."; "...." = "cd ../../..";
      ls = "lsd"; ll = "lsd -l"; la = "lsd -la"; lt = "lsd --tree";
      cat = "bat --style=plain"; grep = "rg"; find = "fd";
      v = "nvim"; vim = "nvim";
      d = "docker"; dc = "docker-compose"; dps = "docker ps"; dimg = "docker images";
      dcu = "docker-compose up -d"; dcd = "docker-compose down";
      dcl = "docker-compose logs -f"; dce = "docker-compose exec";
      h = "history"; md = "mkdir -p"; c = "clear";
    };
    plugins = [
      { name = "fzf"; src = pkgs.fishPlugins.fzf-fish.src; }
      { name = "done"; src = pkgs.fishPlugins.done.src; }
      { name = "autopair"; src = pkgs.fishPlugins.autopair.src; }
      { name = "fish-git-abbr"; src = pkgs.fishPlugins.git-abbr.src; }
      { name = "fish-you-should-use"; src = pkgs.fishPlugins.fish-you-should-use.src; }
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
