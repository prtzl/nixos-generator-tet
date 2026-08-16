{
  lib,
  pillow,
  pkgs,
  ...
}:

# INFO: use pkgs since that's overriden by hyprland upstream flake along with all of it's related packages
# Therefore hyprcursor, for example, will come from there and will thus depend on hyprland from upstream instead
# of using one from nixpkgs.
{
  home.packages = with pkgs; [
    hyprcursor # I guess this has to come separately
    wl-clipboard # clipboard (why is this additional, like  what?)
    networkmanagerapplet # brings network manager applet functionality
    grimblast # screenshot utility
    wlopm # wayland power management
    brightnessctl # controls screen and keyboard backglight brightness
  ];

  # The jummy thing about this is that now as a service it reloads on configurations change automatically!
  wayland.windowManager.hyprland = {
    enable = true;
    package = null; # match nixos installed
    portalPackage = null; # match nixos installe
    systemd.enable = true;
    configType = "lua";
    # main hyprland config in native format
    # extraConfig = builtins.readFile ./hyprland.conf;
    extraConfig = builtins.readFile ./hyprland.lua;
    # hyprland config in nix format - programmable part
    settings =
      let
        defaultSettings = {
          monitor = lib.mkDefault {
            output = "";
            mode = "preferred";
            position = "auto";
            scale = "1";
          };
        };
        userSettings = pillow.settings;
        hyprlandSettings = if (userSettings ? hyprland) then userSettings.hyprland else { };
      in
      defaultSettings // hyprlandSettings;
  };

  # Background setting app
  services.hyprpaper = {
    enable = true;
    package = pkgs.hyprpaper;
    settings = { };
    systemdTarget = "hyprland-session.target";
  };
  # INFO: exporter does not put monitor at the top, so hyprpaper complains
  home.file.".config/hypr/hyprpaper.conf".text = ''
    wallpaper {
      monitor=
      path=${./doom.jpg}
      fit_mode=cover
    }
  '';

  # Screen color without affecting screenshot/screenrecording SW
  # One of the two following entries (units or restart) makes this work now. There is a race condition that makes the wlsunset start before the wayland is really up
  services.wlsunset = {
    package = pkgs.wlsunset;
    systemdTarget = "hyprland-session.target";
    enable = true;
    temperature.day = 4001;
    temperature.night = 4000;
    latitude = 0;
    longitude = 0;
  };

  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        grace = 1;
        hide_cursor = true;
        ignore_empty_input = true;
      };
      background = {
        monitor = "";
        path = "${./doom.jpg}";
        blur_size = 5;
        blur_passes = 1;
        noise = 0.0117;
        contrast = 1.3000;
        brightness = 0.8000;
        vibrancy = 0.2100;
        vibrancy_darkness = 0.0;
      };

      input-field = [
        {
          monitor = "";
          size = "100, 100";
          outline_thickness = 40;
          outer_color = "$color5";
          inner_color = "$color0";
          font_color = "$color12";
          fade_on_empty = true;
          placeholder_text = "<i>Password...</i>"; # Text rendered in the input box when it's empty.;
          hide_input = true;
          position = "0, 220";
          halign = "center";
          valign = "bottom";
        }
      ];

      # Date;
      label = [
        {
          monitor = "";
          text = "cmd[update:18000000] echo \"<b> $(date +'%-d %B %Y') </b>\"";
          color = "$color12";
          font_size = 34;
          font_family = "Noto Sans 10";

          position = "0, -200";
          halign = "center";
          valign = "top";
        }

        # Day;
        {
          monitor = "";
          text = "cmd[update:18000000] echo \"<b> $(date +'%A') </b>\"";
          color = "$color5";
          font_size = 34;
          font_family = "Noto Sans 10";
          position = "0, -150";
          halign = "center";
          valign = "top";
        }

        # Time;
        {
          monitor = "";
          text = "cmd[update:1000] echo \"<b><big> $(date +'%H:%M:%S') </big></b>\"";
          color = "$color15";
          font_size = 94;
          font_family = "Noto Sans 10";

          position = "0, 0";
          halign = "center";
          valign = "center";
        }

        # User;
        {
          monitor = "";
          text = "   $USER";
          color = "$color12";
          font_size = 18;
          font_family = "Inter Display Medium";

          position = "0, 100";
          halign = "center";
          valign = "bottom";
        }
      ];
    };
  };

  # A bunch of services/routines based on timeouts related to GUI/hyprland
  services.hypridle = {
    enable = true;
    systemdTarget = "hyprland-session.target";
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "wlopm --on '*'";
      };
      listener = [
        # Dim monitor after 30s
        {
          timeout = 120;
          on-resume = "brightnessctl -r";
          on-timeout = "brightnessctl -s set 10";
        }
        # Disable keyboard backlight after 5s
        {
          timeout = 5;
          on-resume = "brightnessctl -rd tpacpi::kbd_backlight";
          on-timeout = "brightnessctl -sd tpacpi::kbd_backlight set 0";
          ignore_inhibit = true; # backlight powers off no matter what
        }
        # disables screen after 2min
        {
          timeout = 600;
          on-resume = "wlopm --on '*'";
          on-timeout = "wlopm --off '*'";
        }
        # locks PC after X minuts
        # for now I want all my machines just on all the time
        # {
        #   timeout = 120;
        #   on-resume = "wlopm --on '*'";
        #   on-timeout = "wlopm --off '*'";
        # }
      ];
    };
  };
}
