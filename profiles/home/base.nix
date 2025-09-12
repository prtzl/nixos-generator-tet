{
  lib,
  pkgs,
  pillow,
  ...
}:

{
  imports =
    # with (lib.findModules ./base);
    [
      ../../profiles/home/base/btop.nix
      ../../profiles/home/base/nvim.nix
      ../../profiles/home/base/ranger.nix
      ../../profiles/home/base/tmux.nix
      ../../profiles/home/base/shell.nix
    ]
    ++ lib.optionals (pillow.edition == "workstation") [
      ../../profiles/home/base/alacritty.nix
      ../../profiles/home/base/dunst.nix
      ../../profiles/home/base/hyprland.nix
      ../../profiles/home/base/themes.nix
      ../../profiles/home/base/tio.nix
      ../../profiles/home/base/waybar.nix
    ];

  home.packages =
    with pkgs;
    [
      ffmpeg-full # yes
    ]
    ++ lib.optionals (pillow.edition == "workstation") [
      # Web
      ungoogled-chromium
      transmission_4-gtk

      # Utility
      unstable.enpass # unstable is unfree

      # Communication
      signal-desktop
    ];
}
