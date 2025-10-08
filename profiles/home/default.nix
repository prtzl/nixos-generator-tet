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
      firefox
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
      qalculate-gtk # calculator fyi
      gnome-disk-utility

      # Communication
      signal-desktop

      # media/creation
      audacity
      libreoffice
      gimp
      inkscape
      haruna # video player (best one yet, nice ui, celluloid is broken somehow)
      gthumb # image viewer

      # file explorer
      xfce.thunar
      xfce.thunar-archive-plugin
      xfce.tumbler

      # wine
      wineWowPackages.waylandFull
      winetricks
    ]
    ++ lib.optionals pillow.onHardware [
      monitorets # GUI for temperature sensors
    ];
}
