{
  lib,
  pkgs,
  ...
}:

let
  wslgit = pkgs.writeShellScriptBin "wslgit" (builtins.readFile ./dotfiles/wslgit.sh);
in
{
  imports = with (lib.findModules ./.); [
    bash
    direnv
    fzf
    starship
    zsh
  ];

  home.packages = with pkgs; [
    bat
    eza
    fd
    fzf
    lazygit
    ripgrep
    tree
    wslgit
    xclip
    zsh-completions
  ];

  home.sessionVariables = {
    TERM = "xterm-256color";
  };
}
