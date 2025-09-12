{
  lib,
  machine,
  pkgs,
  ...
}:

let
  # Load base configs, we'll add device specific configs to these
  baseconfig = (builtins.fromJSON (builtins.readFile ./dotfiles/waybar/config));
  basestyle = builtins.readFile ./dotfiles/waybar/style.css;

  # BATTERIES
  selectedBatteries = machine.batteries or [ ];

  batteryConfigNames = lib.lists.imap1 (index: battery: "battery") selectedBatteries;

  makeBattery = path: index: {
    battery = {
      bat = "BAT0";
      interval = 60;
      states = {
        warning = 30;
        critical = 15;
      };
      format = "{capacity}%";
      max-length = 25;
    };
  };

  makeBatteryConfigs =
    batteries: lib.lists.imap1 (index: battery: makeBattery battery index) batteries;
  batteryConfigs = lib.foldl' (acc: x: acc // x) { } (makeBatteryConfigs selectedBatteries);

  makeBatteryStyle =
    name: index:
    let
      color = "#028909";
    in
    ''
      #battery {
        color: ${color};
      }
    '';

  batteryStyles = builtins.concatStringsSep "\n" (
    lib.lists.imap1 (index: battery: makeBatteryStyle battery index) selectedBatteries
  );

  # Temperatures
  selectedTempProbes = machine.temp_probes or [ ];

  tempConfigNames = lib.lists.imap1 (
    index: temp_probe: "temperature#${builtins.toString index}"
  ) selectedTempProbes;

  makeTemp =
    temp_probe: index: with temp_probe; {
      "temperature#${builtins.toString index}" = {
        format = "${icon} {temperatureC}°C";
        hwmon-path = [ "${path}" ];
        interval = 2;
        tooltip-format = "${path}: {temperatureC}°C";
      };
    };

  makeTempConfigs = temp_probes: lib.lists.imap1 (index: probe: makeTemp probe index) temp_probes;
  tempConfigs = lib.foldl' (acc: x: acc // x) { } (makeTempConfigs selectedTempProbes);

  # TODO: how to add a default
  makeTempStyle =
    temp_probne: index: with temp_probne; ''
      #temperature.${builtins.toString index} {
        color: ${color};
      }
    '';
  tempStyles = builtins.concatStringsSep "\n" (
    lib.lists.imap1 (index: temp_probe: makeTempStyle temp_probe index) selectedTempProbes
  );

  # DISKS
  selectedDisks = machine.disks or [ ];

  diskConfigNames = lib.lists.imap1 (index: path: "disk#${builtins.toString index}") selectedDisks;

  makeDisks = path: index: {
    "disk#${builtins.toString index}" = {
      format = "󰋊 {percentage_used}%";
      interval = 5;
      path = "${path}";
      tooltip = true;
      tooltip-format = "{path}: Available {free} of {total}";
      unit = "GB";
    };
  };

  makeDiskConfigs = disks: lib.lists.imap1 (index: path: makeDisks path index) disks;
  diskConfigs = lib.foldl' (acc: x: acc // x) { } (makeDiskConfigs selectedDisks);

  diskStyles =
    builtins.concatStringsSep ''
      ,
    '' (lib.lists.imap1 (index: path: "#disk.${builtins.toString index}") selectedDisks)
    + ''
      {
        color: #b58900;
      }
    '';

  ## INTERFACES
  selectedInterfaces = machine.interfaces or [ ];

  # Create list of network interfaces
  networkConfigNames = lib.lists.imap1 (
    index: interface: "network#${builtins.toString index}"
  ) selectedInterfaces;

  makeInterface = interface: index: {
    "network#${builtins.toString index}" = {
      interface = "${interface}";
      format-wifi = " ";
      format-ethernet = " ";
      format-disconnected = "🚫";
      format-disabled = " ";
      tooltip-format = "{ifname}";
      tooltip-format-wifi = " {essid} ({signalStrength}%) {ipaddr}";
      tooltip-format-ethernet = " {ifname} {ipaddr}";
      tooltip-format-disconnected = "{ifname} disconnected";
      max-length = 200;
      on-click = "nm-connection-editor";
      interval = 5;
    };
  };

  # Create css block for styling network interfaces
  networkStyles =
    builtins.concatStringsSep ''
      ,
    '' (lib.lists.imap1 (index: interface: "#network.${builtins.toString index}") selectedInterfaces)
    + ''
      {
        color: #800080;
      }
    '';

  # Create attrset of network config option blocks
  makeNetworkConfigs =
    interfaces: lib.lists.imap1 (index: interface: makeInterface interface index) interfaces;
  networkConfigs = lib.foldl' (acc: x: acc // x) { } (makeNetworkConfigs selectedInterfaces);

  ## Output configs
  # modues-right has cpu - memory - pulse. Put the "dynamic modules" between first two and last.
  modules-right =
    let
      original = baseconfig.modules-right;
      # First are tray, language, cpu, and memory;
      firstBase = lib.lists.take 4 original;
      # Leaves with pulse
      secondBase = lib.lists.take 1 (lib.lists.drop 4 original);
    in
    firstBase
    ++ tempConfigNames
    ++ diskConfigNames
    ++ networkConfigNames
    ++ batteryConfigNames
    ++ secondBase;

  # Write new config and style
  config =
    baseconfig
    // {
      modules-right = modules-right;
    }
    // networkConfigs
    // diskConfigs
    // tempConfigs
    // batteryConfigs;
  style = basestyle + networkStyles + diskStyles + tempStyles + batteryStyles;

in
{
  home.packages = with pkgs; [
    pavucontrol # used to adjust volume with applet. Yes, usefull on it's own, but manly used via applet, so we require it here
  ];

  systemd.user.services.waybar.Unit.After = lib.mkForce "graphical-session.target";
  programs.waybar = {
    enable = true;
    package = pkgs.waybar;
    systemd.enable = true;
    systemd.target = "hyprland-session.target";
    settings = [ config ];
    style = basestyle; # = style, going emo
  };
}
