{
  lib,
  pkgs,
  pillow,
  ...
}:

{
  imports =
    with (lib.findModules ./units);
    [
      ./units/shell
      btop
      git
      nvim
      ranger
      tmux
    ]
    ++ lib.optionals (pillow.hasGUI) [
      ./units/gui
      alacritty
    ]
    ++ lib.optionals (pillow.onHardware) [
      tio
    ];

  home.packages =
    with pkgs;
    [
      dysk
      ffmpeg-full # yes
    ]
    ++ lib.optionals (pillow.hasGUI) [
      # Web
      ungoogled-chromium
      transmission_4-gtk

      # Utility
      pkgs-unfree.enpass

      # Communication
      signal-desktop

      # creation
      audacity
      libreoffice
      gimp
      inkscape
    ];
}
