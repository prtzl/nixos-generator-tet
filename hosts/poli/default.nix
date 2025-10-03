{
  inputs,
  lib,
  ...
}:

lib.pillowSystem {
  pillow = lib.makePillowArgs {
    edition = "workstation";
    hostPlatform = "x86_64-linux";
    hasGUI = true;

    host = {
      name = "poli";
      interfaces = [ "enp13s0" ];
      temp_probes = [
        {
          path = "/dev/cpu_temp";
          icon = "";
          color = "#43a047";
        }
        {
          path = "/dev/gpu_temp";
          icon = "󰍹";
          color = "#fb8c00";
        }
        {
          path = "/dev/water_temp";
          icon = "";
          color = "#1e88e5";
        }
        {
          path = "/dev/motherboard_temp";
          icon = "";
          color = "#8e24aa";
        }
      ];
      disks = [
        "/"
        "/storage"
      ];
    };
  };

  modules =
    (lib.findModulesList ./.)
    ++ (with (lib.findModules ../../users); [
      matej
    ]);

  specialArgs = {
    local = inputs;
  };
}
