{
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [ tio ];
  xdg.configFile."tio/tiorc".source = ./tiorc;
}
