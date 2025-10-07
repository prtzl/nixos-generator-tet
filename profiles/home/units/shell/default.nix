{
  lib,
  pillow,
  pkgs,
  ...
}:

{
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
      lazygit
      ripgrep
      tree
      xclip
      zsh-completions
    ]
    ++ lib.optionals pillow.isWSL [ (import ./wslgit.nix) ];

  home.sessionVariables = {
    TERM = "xterm-256color";
  };
}
