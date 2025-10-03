{
  inputs,
  lib,
  ...
}:

lib.pillowSystem {
  pillow = lib.makePillowArgs {
    edition = "workstation";
    buildPlatform = "x86_64-linux"; # where you build it
    hostPlatform = "x86_64-linux"; # target system arch
    hasGUI = true;

    host = rec {
      name = "poli";
      hostname = name;
      interfaces = [ "enp13s0" ];
      temp_probes = [
        {
          path = "/dev/cpu_temp";
          icon = "";
          color = "#3ffc81";
        }
        {
          path = "/dev/gpu_temp";
          icon = "󰍹";
          color = "#982daf";
        }
        {
          path = "/dev/water_temp";
          icon = "";
          color = "#3385e6";
        }
        {
          path = "/dev/motherboard_temp";
          icon = "";
          color = "#982daf";
        }
      ];
      disks = [
        "/"
        "/storage"
      ];
    };
  };

  modules =
    (with (lib.findModules ../../users); [
      matej
    ])
    ++ [
      ./configuration.nix
      ./disko.nix
      ./hardware-configuration.nix
      ./udev.nix
      ../../profiles/system
    ];

  specialArgs = {
    local = inputs;
  };
}
