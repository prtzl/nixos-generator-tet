{
  lib,
  local,
  pillow,
  pkgs,
  ...
}:

{
  # Apps and configs
  imports =
    with (lib.findModules ./units);
    lib.optionals (pillow.edition == "workstation") [
      virtual
    ]
    ++ lib.optionals (pillow.hasGUI) [
      hyprland
    ]
    ++ lib.optionals (pillow.onHardware) [
      pipewire
      udev
    ];

  environment = {
    shells = with pkgs; [
      bashInteractive
      zsh
    ];
    variables = {
      EDITOR = "vim";
    };
    sessionVariables = {
      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_STATE_HOME = "$HOME/.local/state";
    };
    systemPackages =
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
        xh
      ]
      ++ lib.optionals (pillow.hasGUI) [
        # file explorer
        xfce.thunar
        xfce.thunar-archive-plugin
        xfce.tumbler

        # calculator
        qalculate-gtk

        # media
        vlc # video player
        gthumb # image viewer

        # wine
        wineWowPackages.waylandFull
        winetricks
      ]
      ++ lib.optionals (pillow.onHardware) [
        hwinfo # self explanatory
        monitorets # GUI for temperature sensors
        pciutils # info on pci devices
        smartmontools # disk checks
        udiskie # automounts using udisks2
        usbutils # info on usb devices
      ];
  };

  nixpkgs.hostPlatform = "${pillow.hostPlatform}";

  # Some stuff that can change based on system, so use mkDefault
  boot = {
    kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
    loader = {
      systemd-boot = {
        enable = lib.mkDefault true;
        consoleMode = "max";
      };
      efi.canTouchEfiVariables = lib.mkDefault true;
    };
    # Following nonsense with plymouth is to enable startup animation
    # Silent boot
    consoleLogLevel = 3;
    initrd.verbose = false;
    # loader.timeout = 0;
    kernelParams = [
      "boot.shell_on_fail"
      "quiet"
      "rd.systemd.show_status=auto"
      "splash"
      "udev.log_level=3"
    ];
    plymouth = {
      enable = true;
      theme = "rings";
      themePackages = with pkgs; [
        (adi1090x-plymouth-themes.override {
          selected_themes = [ "rings" ];
        })
      ];
    };
  };

  nix = {
    monitored = {
      enable = true;
      notify = false;
    };
    registry = {
      # nixpkgs (default) == stable branch (my default)
      stable.flake = local.nixpkgs;
      unstable.flake = local.nixpkgs-unstable;
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
  ) pillow.host.interfaces;

  networking = {
    enableIPv6 = false;
    firewall.enable = true;
    hostName = pillow.host.name;
    networkmanager.enable = true;
  };

  i18n = {
    defaultLocale = "en_GB.UTF-8";
    extraLocales = "all";
  };

  services = {
    fwupd.enable = true;
    geoclue2.enable = true; # required for localtimed (fails if not found)
    localtimed.enable = true; # time and datre control (otherwise I'm off :O
    printing.enable = pillow.onHardware;
    udisks2.enable = true; # daemon for mounting storage devices (usbs and such)
    usbmuxd.enable = pillow.onHardware;
  };

  location.provider = "geoclue2"; # required for geoclue2 service, which ...

  programs = {
    firefox.enable = pillow.hasGUI;
    gnome-disks.enable = pillow.onHardware;
    usbtop.enable = pillow.onHardware;
    zsh.enable = true;
  };

  users.defaultUserShell = pkgs.zsh;

  fonts = {
    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = [ "Noto Serif" ];
        sansSerif = [ "Noto Sans" ];
        monospace = [ "FiraCode Nerd Font" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
    fontDir.enable = true;
    packages = with pkgs; [
      fira
      fira-code
      fira-mono
      nerd-fonts.fira-code
      noto-fonts
      noto-fonts-emoji
      noto-fonts-extra
    ];
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true; # enable portals for wlroots-based desktops (hyprland too!)
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
  };

  # xdg.mime.inverted.defaultApplications."gthumb.desktop" = lib.optionals (pillow.hasGUI) [
  #   "image/bmp"
  #   "image/gif"
  #   "image/jpeg"
  #   "image/jpg"
  #   "image/pjpeg"
  #   "image/png"
  #   "image/svg+xml"
  #   "image/svg+xml-compressed"
  #   "image/tiff"
  #   "image/vnd.wap.wbmp"
  #   "image/x-bmp"
  #   "image/x-gray"
  #   "image/x-icb"
  #   "image/x-icns"
  #   "image/x-ico"
  #   "image/x-pcx"
  #   "image/x-png"
  #   "image/x-portable-anymap"
  #   "image/x-portable-bitmap"
  #   "image/x-portable-graymap"
  #   "image/x-portable-pixmap"
  #   "image/x-xbitmap"
  #   "image/x-xpixmap"
  # ];
}
