{
  pkgs,
  ...
}:

let
  rofilauncher = pkgs.writeShellApplication {
    name = "rofilauncher";
    runtimeInputs = with pkgs; [ bc ];
    text = builtins.readFile ./dotfiles/rofi/rofilauncher.sh;
  };
in
{
  home.packages = [ rofilauncher ];

  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
    theme = ./dotfiles/rofi/myrofitheme.rasi;
  };
}
