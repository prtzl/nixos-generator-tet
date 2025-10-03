{ ... }:

{
  imports = [ ./starship.nix ];

  # Let's configure bash with even starship, fzf, and direnv when needed
  # zsh seems to have features I like, but I can still have good
  # ux when bash is required for compatability (nix develop)
  programs.bash = {
    enable = true;
    enableCompletion = true;
    historyFile = ".config/bash/.bash_history";
    historySize = 1000;
    historyFileSize = 100000;
    shellAliases = {
      ls = "eza --group-directories-first --color=always --icons";
      l = "ls -la";
      ll = "ls -l";
      grep = "grep --color=always -n";
      xclip = "xclip -selection clipboard";

      # System
      reboot = ''read -s \?"Reboot? [ENTER]: " && if [ -z "$REPLY" ];then env reboot;else echo "Canceled";fi'';
      poweroff = ''read -s \?"Poweroff? [ENTER]: " && if [ -z "$REPLY" ];then env poweroff;else echo "Canceled";fi'';
      udevreload = "sudo udevadm control --reload-rules && sudo udevadm trigger";
    };
    initExtra = ''
      # Prevents direnv from yapping too much
      export DIRENV_LOG_FORMAT=""
    '';
  };
}
