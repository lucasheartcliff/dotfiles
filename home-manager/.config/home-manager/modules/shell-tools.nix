{ ... }:

{
  programs.fish.interactiveShellInit = ''
    atuin init fish | string replace 'bind -M insert -k up _atuin_bind_up' 'bind -M insert up _atuin_bind_up' | source
  '';

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.atuin = {
    enable = true;
    enableFishIntegration = false;
    settings = {
      enter_accept = true;
      filter_mode = "global";
    };
  };
}
