{
  inputs,
  lib,
  ...
}:

lib.pillowSystem {
  pillow = {
    edition = "workstation";
    buildPlatform = "x86_64-linux"; # where you build it
    hostPlatform = "x86_64-linux"; # target system arch

    machine = rec {
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

  modules = with (lib.findModules ../../users); [
    ./configuration.nix
    matej
  ];

  specialArgs = {
    local = inputs;
    inherit lib;
  };
}
