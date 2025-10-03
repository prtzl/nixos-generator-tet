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
    [
      fonts
      wine
    ]
    ++ lib.optionals (pillow.edition == "workstation") [
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
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "udev.log_level=3"
      "rd.systemd.show_status=auto"
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

  i18n.defaultLocale = "en_GB.UTF-8";

  services = {
    xserver.xkb.layout = "us";
    fwupd.enable = true;
    udisks2.enable = true; # daemon for mounting storage devices (usbs and such)
  };

  programs = {
    firefox.enable = pillow.hasGUI;
    usbtop.enable = true;
    zsh.enable = true;
    gnome-disks.enable = pillow.onHardware;
  };

  users.defaultUserShell = pkgs.zsh;

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
