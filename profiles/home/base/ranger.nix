{
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [
    ranger
    ueberzug
  ];

  home.file.".config/ranger/rc.conf".source = ./dotfiles/ranger/rc.conf;
}
