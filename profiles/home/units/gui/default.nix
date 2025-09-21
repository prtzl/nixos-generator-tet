{
  lib,
  ...
}:

{
  imports = with (lib.findModules ./.); [
    dunst
    hyprland
    themes
    waybar
  ];
}
