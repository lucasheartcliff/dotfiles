{ ... }:

{
  programs.git = {
    enable = true;
    userName = "Lucas Morais";
    userEmail = "lucascdemorais@gmail.com";
    aliases = {
      co = "checkout";
      br = "branch";
      ci = "commit";
      st = "status";
    };
    extraConfig = {
      init.defaultBranch = "main";
      core.editor = "nvim";
      pull.rebase = false;
      push.autoSetupRemote = true;
    };
    delta = {
      enable = true;
      options = {
        navigate = true;
        line-numbers = true;
        syntax-theme = "Dracula";
      };
    };
  };
}
