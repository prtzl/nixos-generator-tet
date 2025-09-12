{
  inputs,
  lib,
  machineInfo,
  pkgs,
  pillow,
  ...
}:

{
  imports =
    # with (lib.findModules ./base/.);
    [
      ../../profiles/system/base/fonts.nix
    ]
    ++ lib.optionals (pillow.edition == "workstation") [
      ../../profiles/system/base/hyprland.nix
      ../../profiles/system/base/pipewire.nix
      ../../profiles/system/base/udev.nix
      ../../profiles/system/base/wine.nix
    ];

  # Some stuff that can change based on system, so use mkDefault
  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
  boot.loader.systemd-boot.enable = lib.mkDefault true;
  boot.loader.efi.canTouchEfiVariables = lib.mkDefault true;

  nix = {
    monitored.notify = false;
    registry = {
      stable.flake = inputs.nixpkgs;
      unstable.flake = inputs.nixpkgs-unstable;
      master.to = {
        owner = "nixos";
        repo = "nixpkgs";
        type = "github";
      };
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    settings = {
      trusted-users = [
        "root"
        "@wheel"
      ];
      auto-optimise-store = true;
    };
    extraOptions = ''
      experimental-features = nix-command flakes ca-derivations
      binary-caches-parallel-connections = 50
      preallocate-contents = false
    '';
  };

  home-manager.backupFileExtension = "backup";

  systemd.network.wait-online.extraArgs = map (
    interface: "--interface=${interface}"
  ) machineInfo.interfaces;

  networking.useDHCP = true;
  networking.hostName = machineInfo.hostname;
  services.xserver.xkb.layout = "us";
  i18n.defaultLocale = "en_GB.UTF-8";

  programs.firefox = {
    enable = (pillow.edition == "workstation");
    package = pkgs.firefox;
  };

  programs.usbtop.enable = true;

  environment.systemPackages =
    with pkgs;
    [
      bat # replacement for cat
      btop # system info graphs, usage, etc. Modern top
      eza # replacement for exa, replacement for ls
      fastfetch # replacement for neofetch :'(
      fd # modern find
      fx # json  viewer
      jq # json processor
      parted # partitions
      ripgrep # modern grep
      smartmontools # disk checks
      xh
    ]
    ++ lib.optionals (pillow.edition == "workstation") [
      # file explorer
      xfce.thunar
      xfce.thunar-archive-plugin
      xfce.tumbler

      # calculator
      qalculate-gtk

      # media
      vlc # video player
      gthumb # image viewer

      # system utils
      usbutils # info on usb devices
      hwinfo # self explanatory
      pciutils # info on pci devices
      monitorets # GUI for temperature sensors
    ];

  xdg.mime.inverted.defaultApplications."gthumb.desktop" =
    lib.optionals (pillow.edition == "workstation")
      [
        "image/bmp"
        "image/gif"
        "image/jpeg"
        "image/jpg"
        "image/pjpeg"
        "image/png"
        "image/svg+xml"
        "image/svg+xml-compressed"
        "image/tiff"
        "image/vnd.wap.wbmp"
        "image/x-bmp"
        "image/x-gray"
        "image/x-icb"
        "image/x-icns"
        "image/x-ico"
        "image/x-pcx"
        "image/x-png"
        "image/x-portable-anymap"
        "image/x-portable-bitmap"
        "image/x-portable-graymap"
        "image/x-portable-pixmap"
        "image/x-xbitmap"
        "image/x-xpixmap"
      ];
}
