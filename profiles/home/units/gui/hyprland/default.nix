{
  lib,
  pkgs,
  pillow,
  nixos_config,
  ...
}:

{
  home.packages = with pkgs; [
    hyprcursor # I guess this has to come separately
    wl-clipboard # clipboard (why is this additional, like  what?)
    networkmanagerapplet # brings network manager applet functionality
    hyprshot # screenshot utility
  ];

  # The jummy thing about this is that now as a service it reloads on configurations change automatically!
  wayland.windowManager.hyprland = {
    enable = true;
    package = nixos_config.programs.hyprland.package; # match nixos installed
    # Enabled hyprland-session.target which links to graphical-session.target.
    # Using this target for other services waiting for the "gui" to start (for example waybar)
    systemd.enable = true;
    extraConfig = builtins.readFile ./hyprland.conf;
    settings =
      let
        defaultSettings = {
          monitor = lib.mkDefault [ ",preferred,auto,1" ];
        };
        userSettings = pillow.settings;
        hyprlandSettings = if (userSettings ? hyprland) then userSettings.hyprland else { };
      in
      defaultSettings // hyprlandSettings;
  };

  # Background setting app
  systemd.user.services.hyprpaper.Unit.After = lib.mkForce "graphical-session.target";
  services.hyprpaper = {
    enable = true;
    settings = {
      preload = "${./doom.jpg}";
      wallpaper = ",${./doom.jpg}";
    };
  };

  # Screen color without affecting screenshot/screenrecording SW
  services.wlsunset = {
    enable = true;
    temperature.day = 4001;
    temperature.night = 4000;
    latitude = 0;
    longitude = 0;
  };
}
