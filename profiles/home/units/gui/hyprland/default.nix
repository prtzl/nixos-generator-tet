{
  lib,
  pkgs,
  pillow,
  nixos_config,
  ...
}:

let
  hypershot_shader_toggle = pkgs.writeShellApplication {
    name = "hypershot_shader_toggle";
    runtimeInputs = with pkgs; [
      hyprshade
      hyprshot
    ];
    text = builtins.readFile ./hyprshot_shader_toggle.sh;
  };
in
{
  home.packages = with pkgs; [
    hyprcursor # I guess this has to come separately
    hyprshade # applies a openGL shader to the screen - used for yellow tinging (replacement for redshift on x11)
    wl-clipboard # clipboard (why is this additional, like  what?)
    networkmanagerapplet # brings network manager applet functionality
    hyprshot # screenshot utility - to be global in case I want to use it outside my script

    hypershot_shader_toggle
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

  # Save shaders
  xdg.configFile."hypr/shaders".source = ./shaders;
}
