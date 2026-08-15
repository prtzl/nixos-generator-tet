{
  pkgs,
  lib,
  pillow,
  ...
}:

let
  myShell = {
    aliases = {
      # shell utils
      ls = "eza --group-directories-first --icons auto";
      l = "eza -lag  --group-directories-first --icons auto";
      ll = "eza -lg  --group-directories-first --icons auto";
      xclip = "xclip -selection clipboard";
      rg = "rg -S --color=auto"; # I would like smart case normally for ripgrep
      df = "df -h"; # human readable units
      free = "free -m"; # memory units

      # System
      udevreload = "sudo udevadm control --reload-rules && sudo udevadm trigger";
    }
    // (if (pillow.edition == "wsl") then { git = "wslgit"; } else { });

    historySize = 100000;
    historyFileSize = 100000;

    posixInit = ''
      # Prevents direnv from yapping too much
      export DIRENV_LOG_FORMAT=""

      usage() {
        du -h "''${1:-.}" --max-depth=1 2> /dev/null | sort -hr
      }

      git_bare_remote() {
        remote=$1
        git config remote.$remote.fetch "+refs/heads/*:refs/remotes/$remote/*"
        git fetch $remote
      }

      grt() {
        local root
          root=$(git rev-parse --show-toplevel 2>/dev/null) || return
          cd "$root"
      }

      reboot() {
        read -s "?Reboot? [ENTER]: "
          if [ -z "$REPLY" ]; then
            command reboot
          else
            echo "Canceled"
              fi
      }

      poweroff() {
        read -s "?Poweroff? [ENTER]: "
          if [ -z "$REPLY" ]; then
            command poweroff
          else
            echo "Canceled"
              fi
      }
    '';
  };
in
{
  _module.args = { inherit myShell; };

  imports = with (lib.findModules ./.); [
    bash
    direnv
    fzf
    starship
    zsh
  ];

  home.packages =
    with pkgs;
    [
      bat
      eza
      fd
      fzf
      ripgrep
      tree
      xclip
      zsh-completions
    ]
    ++ lib.optionals (pillow.edition == "wsl") [ (import ./wslgit.nix { inherit pkgs; }) ];

  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };

  programs.difftastic.enable = true; # fancy diff tool

  home.sessionVariables = {
    TERM = "xterm-256color";
  };
}
