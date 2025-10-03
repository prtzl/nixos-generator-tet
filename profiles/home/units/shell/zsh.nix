{
  ...
}:

{
  programs.zsh = {
    enable = true;
    autocd = true;
    dotDir = ".config/zsh";
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    historySubstringSearch.enable = true;

    shellAliases = {
      # Utilities
      ls = "eza --group-directories-first --color=always --icons";
      l = "ls -la";
      ll = "ls -l";
      grep = "grep --color=always -n";
      ssh = "ssh -C";
      xclip = "xclip -selection clipboard";

      # Programs
      pdf = "evince";
      img = "";
      play = "celluloid";
      sl = "sl -ead -999";
      vim = "nvim";
      gvim = "nvim-qt";

      # System
      reboot = ''read -s \?"Reboot? [ENTER]: " && if [ -z "$REPLY" ];then env reboot;else echo "Canceled";fi'';
      poweroff = ''read -s \?"Poweroff? [ENTER]: " && if [ -z "$REPLY" ];then env poweroff;else echo "Canceled";fi'';
      udevreload = "sudo udevadm control --reload-rules && sudo udevadm trigger";

      git = "wslgit";
    };

    history = {
      expireDuplicatesFirst = true;
      ignoreAllDups = true;
      ignoreDups = true;
      ignoreSpace = true;
      path = "$HOME/.config/zsh/.zsh_history";
      save = 100000;
      share = true;
      size = 100000;
    };

    initContent = ''
      # Nice completion with menus 
      zstyle ':completion:*' menu select
      zstyle ':completion:*' group-name ""
      zstyle ':completion:*' matcher-list "" 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
      _comp_options+=(globdots)

      # F$cked keys, give them back
      bindkey "^[[3~" delete-char
      bindkey "^[[3;5~" delete-char
      bindkey '^H' backward-kill-word
      bindkey '^[[1;5D' backward-word
      bindkey '^[[1;5C' forward-word
      bindkey '\e[11~' "urxvt &\n"

      # enable vim mode (default is insert, esc gets you to normal)
      bindkey -v

      # Don't save a command into history if it failed to evaluate.
      # If it runs but fails, it is still saved. No worries of loosing typoed commands.
      zshaddhistory() {
        whence ''${''${(z)1}[1]} >| /dev/null || return 1
      }

      # Prevents direnv from yapping too much
      export DIRENV_LOG_FORMAT=""

      usage() {
        du -h "''${1:-.}" --max-depth=1 2> /dev/null | sort -hr
      }
    '';
  };
}
