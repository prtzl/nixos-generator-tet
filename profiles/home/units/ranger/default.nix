{
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [
    ranger
    ueberzug
  ];
  xdg.configFile."ranger/rc.conf".source = ./rc.conf;
}
