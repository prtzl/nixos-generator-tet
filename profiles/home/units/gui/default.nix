{
  lib,
  ...
}:

{
  imports = with (lib.findModules ./.); [
    dunst
    hyprland
    rofi
    themes
    waybar
  ];
}
