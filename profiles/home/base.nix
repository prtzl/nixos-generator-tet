{
  lib,
  pkgs,
  pillow,
  ...
}:

{
  imports =
    with (lib.findModules ./base);
    [
      btop
      git
      nvim
      ranger
      shell
      tmux
    ]
    ++ lib.optionals (pillow.edition == "workstation") [
      alacritty
      dunst
      hyprland
      themes
      tio
      waybar
    ];

  home.packages =
    with pkgs;
    [
      dysk
      ffmpeg-full # yes
    ]
    ++ lib.optionals (pillow.edition == "workstation") [
      # Web
      ungoogled-chromium
      transmission_4-gtk

      # Utility
      pkgs-unfree.enpass # unstable is unfree

      # Communication
      signal-desktop
    ];
}
